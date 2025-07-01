# frozen_string_literal: true

require 'json'

module Parsers
  class EslintParser
    class << self
      def run(result_json)
        return {} if result_json.blank?

        files_array(result_json).each_with_object({}) do |file, acc|
          offenses = build_offenses(file['messages'])
          next if offenses.empty?

          acc[relative_path(file['filePath'] || file['path'])] = offenses
        end
      end

      private

      def files_array(json)
        parsed = JSON.parse(json)
        parsed.is_a?(Array) ? parsed : parsed.fetch('files', [])
      rescue JSON::ParserError
        []
      end

      def build_offenses(messages)
        Array(messages).map do |msg|
          {
            message: msg['message'],
            cop_name: msg['ruleId'],
            line_col: "#{msg['line']}:#{msg['column']}"
          }
        end
      end

      def relative_path(path)
        path.to_s.sub(%r{\Atmp/repos/[^/]+/[^/]+/}, '')
      end
    end
  end
end
