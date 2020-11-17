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

module Go
  def Go::reset_markers
    system(ENV['TM_MATE'], "--uuid", ENV['TM_DOCUMENT_UUID'], "--clear-mark=note", "--clear-mark=warning", "--clear-mark=error")
  end
  
  def Go::set_markers(input)
    input.split("\n").each do |line|
      if line =~ /^(.*?):(\d+):(\d+):\s*(.*)$/
        file, lineno, column, message = $1, $2, $3, $4
        file = File.basename(file)
        message = "warning:#{message}"
        tm_args = ["--uuid", ENV['TM_DOCUMENT_UUID'], "--line=#{lineno}:#{column || '1'}", "--set-mark=#{message}"]
        system(ENV['TM_MATE'], *tm_args)
      end
    end
  end

  def Go::gofmt
    $OUTPUT, err = TextMate::Process.run("gofmt", :input => $DOCUMENT)
    unless err.nil? || err == ""
      self.set_markers(err)
      TextMate.exit_show_tool_tip("Fix the gofmt error(s)!")
    end
  end
  
  def Go::goimports
    $OUTPUT, err = TextMate::Process.run("goimports", :input => $DOCUMENT)
    unless err.nil? || err == ""
      self.set_markers(err)
      TextMate.exit_show_tool_tip("Fix the goimports error(s)!")
    end
  end

  def Go::golint
    out, err = TextMate::Process.run("golint", ENV['TM_FILEPATH'])

    unless err.nil? || err == ""
      self.set_markers(err)
      TextMate.exit_show_tool_tip("Fix the golint error(s)!")
    end

    unless out.empty?
      self.set_markers(out)
      TextMate.exit_show_tool_tip("Fix the golint error(s)!")
    end
  end

  def Go::govet
    out, err = TextMate::Process.run("go", "vet", ".")
    
    unless (err.nil? || err == "") and err.include?(ENV['TM_FILENAME'])
      if err.include?(ENV['TM_FILENAME'])
        self.set_markers(err)
        TextMate.exit_show_tool_tip("Fix the go vet error(s)!\n\n#{err}")
      end
    end
  end
  
  def Go::check_bundle_config
    err_msg = nil
    
    # check env
    required_env_names = ['TM_GO', 'TM_GOPATH']
    required_envs_set = required_env_names.all?{|val| ENV[val]}

    if required_envs_set
      $SETUP_OK = true
    else
      err_msg = "Bundle config error, please check TM environment variables.\n\n#{required_env_names.join(' or ')}\n\nmust set..."
    end

    TextMate.exit_show_tool_tip(err_msg) unless $SETUP_OK
  end
  
  # callback.document.will-save
  def Go::run_gofmt_and_goimports
    self.check_bundle_config

    self.reset_markers
    self.gofmt
    self.goimports

    print $OUTPUT
  end

  # callback.document.did-save
  def Go::run_golint_and_govet
    self.check_bundle_config

    self.reset_markers
    self.golint
    self.govet

    TextMate.exit_show_tool_tip("Good to go!")
  end
  
end
