#!/usr/bin/env ruby18

require ENV['TM_SUPPORT_PATH'] + '/lib/exit_codes'
require ENV['TM_SUPPORT_PATH'] + '/lib/textmate'
require ENV['TM_SUPPORT_PATH'] + '/lib/tm/executor'
require ENV['TM_SUPPORT_PATH'] + '/lib/tm/process'
require ENV['TM_SUPPORT_PATH'] + '/lib/tm/save_current_document'

# TM_GO must set...
# TM_GOPATH must set...
ENV['PATH'] = "#{File.dirname(ENV['TM_GO'])}:#{ENV['PATH']}"
ENV['PATH'] = "#{ENV['TM_GOPATH']}/bin:#{ENV['PATH']}"

$OUTPUT = ""
$DOCUMENT = STDIN.read
$SETUP_OK = false
$ALL_ERRORS = []
$DEBUG_OUT = []

$DEBUG_OUT << "TM_DISABLE_GOFUMPT: #{ENV['TM_DISABLE_GOFUMPT']}"
$DEBUG_OUT << "TM_DISABLE_GOFMT: #{ENV['TM_DISABLE_GOFMT']}"
$DEBUG_OUT << "TM_DISABLE_GOIMPORTS: #{ENV['TM_DISABLE_GOIMPORTS']}"
$DEBUG_OUT << "TM_DISABLE_GOLINES: #{ENV['TM_DISABLE_GOLINES']}"
$DEBUG_OUT << "TM_DISABLE_GOVET: #{ENV['TM_DISABLE_GOVET']}"
$DEBUG_OUT << "TM_DISABLE_GOLANGCI: #{ENV['TM_DISABLE_GOLANGCI']}"
$DEBUG_OUT << "TM_DISABLE_STATIC_CHECK: #{ENV['TM_DISABLE_STATIC_CHECK']}"


def wrap_str(s, width=80)
  s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
end

def boxify(s)
  line =  "━" * (s.length / 2)
  "┏#{line}┓\n┃  #{s}  ┃\n┗#{line}┛"
end

def wrap_text(txt, limit)
  out = ['']
  input = txt.gsub(/\n/," ")
  words = input.split(" ")
  line = 0
  while input != ""
    word = words.shift
    break if not word
    if out[line].length + word.length > limit
      out[line].squeeze!(" ")
      line += 1
      out[line] = ""
    end
    out[line] << word + " "
  end
  out.join("\n")
end

module Go
  def Go::handle_err_messages(title)
    err_max_lines = ENV['TM_ERROR_TOOLTIP_MAX_LINE'] || 120
    err_max_lines = err_max_lines.to_i
    err_max_lines = 150 if err_max_lines > 150
    
    $ALL_ERRORS.each_with_index do |err, index|
      err_lines = err.split("\n")
      err_lines.each_with_index do |e, i|
        err_lines[i] = wrap_text(e, err_max_lines)
      end
      $ALL_ERRORS[index] = err_lines.join("\n")
    end

    err_msg = ""
    err_msg = err_msg + $DEBUG_OUT.map{|i| "# #{i}"}.join("\n") + "\n" if ENV['TM_GOLINTER_DEBUG']
    err_msg = err_msg + "#{title}\n\n"
    err_msg = err_msg + $ALL_ERRORS.join("\n\n")
    
    if ENV['TM_GOLINTER_DEBUG']
      TextMate.exit_create_new_document(err_msg)
    else
      TextMate.exit_show_tool_tip(err_msg)
    end
  end

  def Go::reset_markers
    system(ENV['TM_MATE'], "--uuid", ENV['TM_DOCUMENT_UUID'], "--clear-mark=note", "--clear-mark=warning", "--clear-mark=error", "--clear-mark=search")
  end
  
  def Go::set_markers(input, sender, style)
    $DEBUG_OUT << "set_markers input: #{input}"

    current_file = "#{File.basename(ENV['TM_DIRECTORY'])}/#{ENV['TM_FILENAME']}"

    case sender
    when "golangci-lint"
      input.split(%r{^(.+:\d+:.+)$}).select{|i| i.size > 0 }.each_slice(2) do |s|
        s[0].split(%r{(^.[^:]+:\d+:\d*:? ?)}).select{|i| i.size > 0 }.each_slice(2) do |slice|
          file_info = slice[0].split(':').select{|i| i != " " }
          
          filepath = file_info[0]
          lineno = file_info[1]
          column = file_info.size == 3 ? file_info[2] : 1
          err_mesage = slice[1]
          
          next if err_mesage.start_with?(": # ")
          
          $DEBUG_OUT << "case: golangci-lint"
          $DEBUG_OUT << "file_info: #{file_info}"
          $DEBUG_OUT << "set_markers(#{sender}): filepath: #{filepath} #{filepath.size}"
          $DEBUG_OUT << "set_markers(#{sender}): current_file: #{current_file} #{current_file.size}"
          $DEBUG_OUT << "filepath.include?(current_file): #{filepath.include?(current_file)}"

          $ALL_ERRORS << "[#{sender}] #{filepath}\n#{lineno}:#{column} -> #{err_mesage}"
          
          if ENV['TM_FILEPATH'].include?(filepath)
            err_mesage = wrap_str(err_mesage, ENV['TM_ERROR_TOOLTIP_MAX_LINE'] || 120)
            err_mesage = "[#{sender}] - #{err_mesage}" unless sender.empty?
            mark_message = "#{style}:#{err_mesage} -> #{lineno}:#{column}"
          
            tm_args = [
              "--uuid", 
              ENV['TM_DOCUMENT_UUID'], 
              "--line=#{lineno}:#{column || '1'}", 
              "--set-mark=#{mark_message}"
            ]
            system(ENV['TM_MATE'], *tm_args)
          end
        end
      end
    else
      ss = input.split("\n").select{|l| !l.start_with?("#")}.map do |s|
        s.sub!(/vet: /, "") if s.start_with?("vet: ")
        s
      end
      
      ss.join("\n").split(%r{^(.*?:\d+:\d+):}).select{|i| i.size > 0 }.each_slice(2) do |slice|
            filepath, lineno, column = slice[0].split(":")
            err_mesage = slice[1]
            
            filepath = File.basename(filepath) if filepath.start_with?("./")
            
            $DEBUG_OUT << "case: else"
            $DEBUG_OUT << "filepath: #{filepath}"
            $DEBUG_OUT << "set_markers(#{sender}): filepath: #{filepath}"
            $DEBUG_OUT << "set_markers(#{sender}): current_file: #{current_file}"
            $DEBUG_OUT << "current_file.include?(filepath): #{current_file.include?(filepath)}"

            $ALL_ERRORS << "[#{sender}] #{filepath}\n#{lineno}:#{column} -> #{err_mesage}"
            
            if ENV['TM_FILEPATH'].include?(filepath)
              err_mesage = "[#{sender}] - #{err_mesage}" unless sender.empty?
              mark_message = "#{style}:#{err_mesage} -> #{lineno}:#{column}"
            
              tm_args = [
                "--uuid", 
                ENV['TM_DOCUMENT_UUID'], 
                "--line=#{lineno}:#{column || '1'}", 
                "--set-mark=#{mark_message}"
              ]
              system(ENV['TM_MATE'], *tm_args)
            end
          end
    end
  end

  # callback.document.will-save
  def Go::gofumpt
    cmd = `command -v gofumpt`.chomp
    out, err = TextMate::Process.run(cmd, :input => $DOCUMENT)
    unless err.nil? || err == ""
      self.handle_err_messages("gofumpt error: #{err}")
    end
    $DOCUMENT = out
  end

  # callback.document.will-save
  def Go::gofmt
    cmd = `command -v gofmt`.chomp
    $OUTPUT, err = TextMate::Process.run(cmd, :input => $DOCUMENT)
    unless err.nil? || err == ""
      self.set_markers(err, "gofmt", "warning")
      self.handle_err_messages("Fix the gofmt error(s)!")
    end
  end

  # callback.document.will-save
  def Go::goimports
    cmd = `command -v goimports`.chomp
    $OUTPUT, err = TextMate::Process.run(cmd, :input => $DOCUMENT)
    unless err.nil? || err == ""
      self.set_markers(err, "goimports", "error")
      self.handle_err_messages(wrap_str("Fix the goimports error(s)!"))
    end
  end

  # callback.document.will-save
  def Go::golines
    max_len = ENV['TM_GOLINES_MAX_LEN'] || '100'
    tab_len = ENV['TM_GOLINES_TAB_LEN'] || '4'

    cmd = `command -v golines`.chomp
    params = ["-m", max_len, "-t", tab_len]

    $OUTPUT, err = TextMate::Process.run(cmd, params, :input => $DOCUMENT)
    self.handle_err_messages("golines error: #{err}") unless err.empty?
  end

  # ---
  
  # callback.document.did-save
  def Go::govet
    current_dir = ENV['TM_PROJECT_DIRECTORY']
    go_mod = "#{current_dir}/go.mod"

    lookup = File.exists?(go_mod) ? "./..." : ENV['TM_FILENAME']
    
    cmd = `command -v go`.chomp
    params = ["vet", lookup]
    
    out, err = TextMate::Process.run(cmd, params, :chdir => ENV['TM_PROJECT_DIRECTORY'])
    unless (err.nil? || err == "")
      self.set_markers(err, "govet", "error")
      self.handle_err_messages("Fix the go vet error(s)!")
    end

    unless ENV['TM_DISABLE_GOVET_SHADOW']
      shadow_bin = `command -v shadow`.chomp
      vet_params = ["vet", "-vettool", shadow_bin, lookup]
      out, err = TextMate::Process.run(cmd, vet_params, :chdir => ENV['TM_PROJECT_DIRECTORY'])
      unless (err.nil? || err == "") and err.include?(ENV['TM_FILENAME'])
        if err.include?(ENV['TM_FILENAME'])
          self.set_markers(err, "govet", "error")
          self.handle_err_messages("Fix the go vet shadow error(s)!")
        end
      end
    end
    
  end

  # callback.document.did-save
  def Go::golangci_lint
    cmd = `command -v golangci-lint`.chomp
    params = ["--color", "never", "run"]

    has_config_file = false
    ['yml', 'yaml', 'toml', 'json'].each do |ext|
      if File.exists?("#{ENV['TM_PROJECT_DIRECTORY']}/.golangci.#{ext}")
        has_config_file = true
        break
      end
    end
    
    log_level = ENV['TM_GOLANGCI_LINT_LOG_LEVEL'] || 'error'
    ENV['LOG_LEVEL'] = log_level unless log_level == ''
    params += ENV['TM_GOLANGCI_LINT_MANUAL'].split(" ") if !has_config_file && ENV['TM_GOLANGCI_LINT_MANUAL']
    params << ENV['TM_FILENAME'] unless File.exists?("#{ENV['TM_PROJECT_DIRECTORY']}/go.mod")
    
    if ENV['TM_GOLINTER_DEBUG']
      cmd_version = `#{cmd} --version`.chomp
      $DEBUG_OUT << "#{cmd_version}"
    end
    
    out, err = TextMate::Process.run(
      cmd,
      params,
      :chdir => ENV["TM_PROJECT_DIRECTORY"]
    )

    unless err.nil? || err == ""
      self.set_markers(err, "golangci-lint", "error")
      self.handle_err_messages("Fix the golangci-lint error(s)!")
    end

    unless out.empty?
      self.set_markers(out, "golangci-lint", "error")
      self.handle_err_messages("Fix the golangci-lint error(s)! (2)")
    end
  end
  
  # callback.document.did-save
  def Go::staticcheck
    cmd = `command -v staticcheck`.chomp
    params = [ENV['TM_FILENAME']]

    out, err = TextMate::Process.run(cmd, params)
    unless out.empty? || !err.empty?
      self.set_markers(out, "staticcheck", "error")
      self.handle_err_messages("Fix the staticcheck error(s)!")
    end
  end
  
  def Go::check_bundle_config
    err_msg = nil
    
    # check env
    required_env_names = ['TM_GO', 'TM_GOPATH']
    required_envs_set = required_env_names.all?{|val| ENV[val]}
    
    # check bins
    required_bins = []
    required_bins << 'gofumpt' unless ENV['TM_DISABLE_GOFUMPT']
    required_bins << 'goimports' unless ENV['TM_DISABLE_GOIMPORTS']
    required_bins << 'golangci-lint' unless ENV['TM_DISABLE_GOLANGCI_LINT']
    required_bins << 'golines' unless ENV['TM_DISABLE_GOLINES']
    required_bins << 'shadow' unless ENV['TM_DISABLE_GOVET_SHADOW']
    required_bins << 'staticcheck' unless ENV['TM_DISABLE_STATIC_CHECK']

    if required_bins.length > 0
      required_bins_exists = required_bins.all?{|name| !`command -v #{name} > /dev/null 2>&1 && echo $?`.chomp.empty? }
    else
      required_bins_exists = true
    end
    
    all_conditions = [required_envs_set, required_bins_exists].all?

    if all_conditions
      $SETUP_OK = true
    else
      err_msg = "Bundle config error, please check TM environment variables.\n
\t#{required_env_names.join(' or ')}\n\nmust set...\n
#{required_env_names.map{|en| "\t#{en} -> #{ENV[en]} ?[#{File.exists?(ENV[en])}]" if ENV[en] }.join("\n")}\n
or check binaries:
#{required_bins.map{|bin| "\t#{bin} -> #{`command -v #{bin}`.chomp}" }.join("\n")}"
    end

    TextMate.exit_show_tool_tip(err_msg) unless $SETUP_OK
  end
  
  # callback.document.will-save
  def Go::run_document_will_save
    if ENV['TM_DISABLE_GO_LINTER']
      print $DOCUMENT
      return
    end

    self.check_bundle_config
    self.reset_markers

    self.gofumpt unless ENV['TM_DISABLE_GOFUMPT']
    self.gofmt unless ENV['TM_DISABLE_GOFMT']
    self.goimports unless ENV['TM_DISABLE_GOIMPORTS']
    self.golines unless ENV['TM_DISABLE_GOLINES']

    print $OUTPUT
  end

  # callback.document.did-save
  def Go::run_document_did_save
    return if ENV['TM_DISABLE_GO_LINTER']

    self.check_bundle_config
    self.reset_markers

    self.govet unless ENV['TM_DISABLE_GOVET']
    self.golangci_lint unless ENV['TM_DISABLE_GOLANGCI']
    self.staticcheck unless ENV['TM_DISABLE_STATIC_CHECK']
    
    success_msg = boxify("Good to go 🚀")
    if ENV['TM_GOLINTER_SHOW_TOOL_VERSIONS']
      version_info = []
        
      cmd_gofumpt = `command -v gofumpt`.chomp
      unless cmd_gofumpt.empty?
        version_gofumpt = `#{cmd_gofumpt} -version`.chomp
        version_info << "gofumpt: #{version_gofumpt}"
      end

      cmd_golines = `command -v golines`.chomp
      unless cmd_golines.empty?
        version_golines = `#{cmd_golines} --version`.chomp
        version_info << "golines: #{version_golines}"
      end

      cmd_golangci_lint = `command -v golangci-lint`.chomp
      unless cmd_golangci_lint.empty?
        version_golangci_lint = `#{cmd_golangci_lint} --version`.chomp
        version_info << "golangci-lint: #{version_golangci_lint}"
      end

      success_msg = version_info.collect{|m| boxify(m)}.join("\n")
    end
    
    TextMate.exit_show_tool_tip(success_msg)
  end
  
end
