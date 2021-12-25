#!/usr/bin/env ruby18

require ENV['TM_SUPPORT_PATH'] + '/lib/exit_codes'
require ENV['TM_SUPPORT_PATH'] + '/lib/textmate'
require ENV['TM_SUPPORT_PATH'] + '/lib/tm/executor'
require ENV['TM_SUPPORT_PATH'] + '/lib/tm/process'
require ENV['TM_SUPPORT_PATH'] + '/lib/tm/save_current_document'

# TM_GO must set...
# GOPATH must set...
ENV['PATH'] = "#{File.dirname(ENV['TM_GO'])}:#{ENV['PATH']}"
ENV['PATH'] = "#{ENV['GOPATH']}/bin:#{ENV['PATH']}"

$OUTPUT = ""
$DOCUMENT = STDIN.read
$SETUP_OK = false
$ALL_ERRORS = []

def wrap_str(s, width=80)
  s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
end

def boxify(s)
  line =  "━" * (s.length / 2)
  "┏#{line}┓\n┃  #{s}  ┃\n┗#{line}┛"
end

module Go
  def Go::reset_markers
    system(ENV['TM_MATE'], "--uuid", ENV['TM_DOCUMENT_UUID'], "--clear-mark=note", "--clear-mark=warning", "--clear-mark=error", "--clear-mark=search")
  end
  
  def Go::set_markers(input, sender, style)
    ss = input.split("\n").select{|l| !l.start_with?("#")}.map do |s|
      s.sub!(/vet: /, "") if s.start_with?("vet: ")
      s
    end
    
    ss.join("\n").split(%r{^(.*?:\d+:\d+):}).select{|i| i.size > 0 }.each_slice(2) do |slice|
      file, lineno, column = slice[0].split(":")
      messages = slice[1]
      messages.chomp! unless slice[1].nil?
      
      case sender
      when "golangci-lint"
        filepath = file
        filepath = "#{File.basename(ENV['TM_DIRECTORY'])}/#{file}" unless ENV['TM_PROJECT_DIRECTORY'] == ENV['TM_DIRECTORY']
        $ALL_ERRORS << "[#{sender}] #{filepath}\n#{lineno}:#{column} -> #{messages}"
      else
        $ALL_ERRORS << "[#{sender}] : #{lineno}:#{column} -> #{messages}"
      end

      messages = "#{style}:#{messages} -> #{lineno}:#{column}"
      messages = "#{messages} - (#{sender})" unless sender.empty?
      tm_args = ["--uuid", ENV['TM_DOCUMENT_UUID'], "--line=#{lineno}:#{column || '1'}", "--set-mark=#{messages}"]
      system(ENV['TM_MATE'], *tm_args)
    end
  end

  # callback.document.will-save
  def Go::gofumpt
    out, err = TextMate::Process.run("gofumpt", :input => $DOCUMENT)
    unless err.nil? || err == ""
      TextMate.exit_show_tool_tip("gofumpt error: #{err}")
    end
    $DOCUMENT = out
  end

  # callback.document.will-save
  def Go::gofmt
    $OUTPUT, err = TextMate::Process.run("gofmt", :input => $DOCUMENT)
    unless err.nil? || err == ""
      self.set_markers(err, "gofmt", "warning")
      TextMate.exit_show_tool_tip("Fix the gofmt error(s)!\n\n#{$ALL_ERRORS.join("\n")}")
    end
  end

  # callback.document.will-save
  def Go::goimports
    $OUTPUT, err = TextMate::Process.run("goimports", :input => $DOCUMENT)
    unless err.nil? || err == ""
      self.set_markers(err, "goimports", "error")
      TextMate.exit_show_tool_tip(wrap_str("Fix the goimports error(s)!\n\n#{$ALL_ERRORS.join("\n")}"))
    end
  end

  # callback.document.will-save
  def Go::golines
    max_len = ENV['TM_GOLINES_MAX_LEN'] || '100'
    tab_len = ENV['TM_GOLINES_TAB_LEN'] || '4'

    $OUTPUT, err = TextMate::Process.run("golines", "-m", max_len, "-t", tab_len, :input => $DOCUMENT)
    TextMate.exit_show_tool_tip("golines error: #{err}") unless err.empty?
  end

  # ---

  # callback.document.did-save
  def Go::golint
    out, err = TextMate::Process.run("golint", ENV['TM_FILEPATH'])

    unless err.nil? || err == ""
      self.set_markers(err, "golint", "error")
      TextMate.exit_show_tool_tip("Fix the golint error(s)!\n\n#{$ALL_ERRORS.join("\n")}")
    end

    unless out.empty?
      self.set_markers(out, "golint", "warning")
      TextMate.exit_show_tool_tip("Fix the golint error(s)!\n\n#{$ALL_ERRORS.join("\n")}")
    end
  end

  # callback.document.did-save
  def Go::govet
    current_dir = ENV['TM_PROJECT_DIRECTORY']
    go_mod = "#{current_dir}/go.mod"
    
    lookup = File.exists?(go_mod) ? "." : ENV['TM_FILENAME']

    out, err = TextMate::Process.run("go", "vet", lookup)

    unless (err.nil? || err == "") and err.include?(ENV['TM_FILENAME'])
      if err.include?(ENV['TM_FILENAME'])
        self.set_markers(err, "govet", "warning")
        TextMate.exit_show_tool_tip("Fix the go vet error(s)!\n\n#{$ALL_ERRORS.join("\n")}")
      end
    end
  end

  # callback.document.did-save
  def Go::golangci_lint
    current_dir = ENV['TM_PROJECT_DIRECTORY']
    go_mod = "#{current_dir}/go.mod"
    
    params = ["golangci-lint", "--color", "never", "run"]
    params << ENV['TM_FILENAME'] unless File.exists?(go_mod)
    
    out, err = TextMate::Process.run(*params)

    unless err.nil? || err == ""
      self.set_markers(err, "golangci-lint", "error")
      TextMate.exit_show_tool_tip("Fix the golangci-lint error(s)!\n\n#{$ALL_ERRORS.join("\n")}")
    end

    unless out.empty?
      self.set_markers(out, "golangci-lint", "error")
      TextMate.exit_show_tool_tip("Fix the golangci-lint error(s)!\n\n#{$ALL_ERRORS.join("\n")}")
    end
  end
  
  def Go::check_bundle_config
    err_msg = nil
    
    # check env
    required_env_names = ['TM_GO', 'GOPATH']
    required_envs_set = required_env_names.all?{|val| ENV[val]}
    
    # check bins
    required_bins = [
      'gofumpt', 'goimports', 'golangci-lint',
      'golines',
    ]
    required_bins_exists = required_bins.all?{|name| !`command -v #{name} > /dev/null 2>&1 && echo $?`.chomp.empty? }
    
    all_conditions = [required_envs_set, required_bins_exists].all?

    if all_conditions
      $SETUP_OK = true
    else
      err_msg = "Bundle config error, please check TM environment variables.\n\n#{required_env_names.join(' or ')}\n\nmust set...\n\nor check binaries #{required_bins_exists.join(' or ')}"
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

    self.golint unless ENV['TM_DISABLE_GOLINT']
    self.govet unless ENV['TM_DISABLE_GOVET']
    self.golangci_lint unless ENV['TM_DISABLE_GOLANGCI']

    TextMate.exit_show_tool_tip(boxify("Good to go 🚀"))
  end
  
end
