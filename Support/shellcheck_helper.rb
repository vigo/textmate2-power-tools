#!/usr/bin/env ruby

require 'json'
require ENV['TM_SUPPORT_PATH'] + '/lib/exit_codes'
require ENV['TM_SUPPORT_PATH'] + '/lib/tm/process'

TM_SHELLCHECK_DISABLE = ENV['TM_SHELLCHECK_DISABLE'] || false

module Shellcheck
  module_function

    def reset_markers
      system(
        ENV['TM_MATE'],
        "--uuid",
        ENV['TM_DOCUMENT_UUID'],
        "--clear-mark=note",
        "--clear-mark=warning",
        "--clear-mark=error",
        "--clear-mark=search"
        )
    end

    def set_markers(payload)
      filename = payload["file"] || "n/a"
      line = payload["line"] || 1
      column = payload["column"] || 1
      code = payload["code"] || "n/a"
      message = payload["message"] || "no message"

      case payload["level"]
      when "error","info"
        level = "error"
      when "style"
        level = "note"
      else
        level = "warning"
      end

      message = "#{level}:[#{code}]  - #{message}"

      tm_args = [
        "--uuid",
        ENV['TM_DOCUMENT_UUID'],
        "--line=#{line}:#{column}",
        "--set-mark=#{message}",
      ]
      system(ENV['TM_MATE'], *tm_args)
    end

    def boxify(text)
      "#{"-" * 40}\n #{text}\n#{"-" * 40}"
    end

  def run
    reset_markers
    return if TM_SHELLCHECK_DISABLE
    input_text = STDIN.read
    return if input_text.size == 0
    return if input_text.split("\n").first.include?("disable=all")

    cmd = ENV["TM_SHELLCHECK"] || `command -v shellcheck`.chomp
    TextMate.exit_show_tool_tip(boxify("shellcheck binary not found!")) if cmd.empty?

    cmd_args = ["-f", "json", "-s", "bash"]
    out, err = TextMate::Process.run(cmd, cmd_args, ENV["TM_FILEPATH"])

    TextMate.exit_show_tool_tip(err) unless err.empty?
    TextMate.exit_show_tool_tip(boxify("Good to go 🚀")) if out.length <= 3

    begin
      errors = JSON.parse(out)
    rescue JSON::ParserError
      TextMate.exit_show_tool_tip("JSON parse error!")
    end

    errors.each do |err|
      set_markers(err)
    end
    errors_length = errors.length
    TextMate.exit_show_tool_tip("you have: \"#{errors_length}\" error#{errors_length > 1 ? 's' : ''} ...")
  end
end
