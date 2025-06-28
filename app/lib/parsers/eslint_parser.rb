# frozen_string_literal: true

require 'json'

module Parsers
  class EslintParser
    def self.run(result_json)
      return {} if result_json.blank?

      data = JSON.parse(result_json)
      files = data || []
      return {} if files.empty?

      grouped = {}
      files.each do |file|
        file_name = file['path'].sub(%r{\Atmp/repos/[^/]+/[^/]+/}, '')

        offenses = file['messages'].map do |message|
          {
            message: message['message'],
            cop_name: message['ruleId'],
            line_col: "#{message['line']}:#{message['column']}"
          }
        end

        grouped[file_name] = offenses unless offenses.empty?
      end

      grouped
    end
  end
end
