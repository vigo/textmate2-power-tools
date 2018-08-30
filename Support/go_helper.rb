#!/usr/bin/env ruby18

require ENV['TM_SUPPORT_PATH'] + '/lib/exit_codes'
require ENV['TM_SUPPORT_PATH'] + '/lib/textmate'
require ENV['TM_SUPPORT_PATH'] + '/lib/tm/executor'
require ENV['TM_SUPPORT_PATH'] + '/lib/tm/process'
require ENV['TM_SUPPORT_PATH'] + '/lib/tm/save_current_document'

ENV['PATH'] = "#{ENV['TM_GOPATH']}/bin:#{ENV['PATH']}"
ENV['PATH'] = "/usr/local/bin:#{ENV['PATH']}"

$OUTPUT = ""
$DOCUMENT = STDIN.read

module Go
  def Go::reset_markers
    system(ENV['TM_MATE'], "--uuid", ENV['TM_DOCUMENT_UUID'], "--clear-mark=note", "--clear-mark=warning", "--clear-mark=error")
  end
  
  def Go::set_markers(input)
    input.split("\n").each do |line|
      if line =~ /^(.*?)(:(?:(\d+):)?(?:(\d+):)?)\s*(.*?)$/ and not $1.nil?
        file, prefix, lineno, column, message = $1, $2, $3, $4, $5
        file = File.basename(file)
        unless lineno.nil?
          value = (message =~ /^\s*(error|warning|note):/ ? $1 : "warning") + ":#{message} - [#{file}]"
          tm_args = ["--uuid", ENV['TM_DOCUMENT_UUID'], "--line=#{lineno}:#{column || '1'}", "--set-mark=#{value}"]
          system(ENV['TM_MATE'], *tm_args)
        end
      end
    end
  end

  def Go::gofmt
    $OUTPUT, err = TextMate::Process.run("gofmt", :input => $DOCUMENT)
    TextMate.exit_show_tool_tip(err) unless err.nil? || err == ""
  end
  
  def Go::goimports
    $OUTPUT, err = TextMate::Process.run("goimports", :input => $DOCUMENT)
    TextMate.exit_show_tool_tip(err) unless err.nil? || err == ""
  end

  def Go::golint
    out, err = TextMate::Process.run("golint", ENV['TM_FILEPATH'])
    TextMate.exit_show_tool_tip(err) unless err.nil? || err == ""

    unless out.empty?
      self.set_markers(out)
      TextMate.exit_show_tool_tip("Fix the lint error(s)!")
    end
  end

  def Go::govet
    lookup_path = ENV['TM_FILEPATH']
    lookup_path = ENV['TM_DIRECTORY'] if ENV['TM_FILEPATH'].start_with?(ENV['GOPATH'])
    out, err = TextMate::Process.run("go", "vet", lookup_path)

    unless (err.nil? || err == "") and err.include?(ENV['TM_FILENAME'])
      if err.include?(ENV['TM_FILENAME'])
        self.set_markers(err)
        TextMate.exit_show_tool_tip("Fix the vet error(s)!")
      end
    end
  end
  
  # callback.document.will-save
  def Go::run_gofmt_and_goimports
    self.gofmt
    self.goimports
    
    print $OUTPUT
  end

  # callback.document.did-save
  def Go::run_golint_and_govet
    self.reset_markers
    self.golint
    self.govet

    TextMate.exit_show_tool_tip("Good to go!")
  end
  
end
