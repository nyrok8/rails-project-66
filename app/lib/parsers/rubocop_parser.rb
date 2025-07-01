# frozen_string_literal: true

require 'json'

module Parsers
  class RubocopParser
    class << self
      def run(result_json)
        return {} if result_json.blank?

        files_array(result_json).each_with_object({}) do |file, acc|
          offenses = build_offenses(file['offenses'])
          next if offenses.empty?

          acc[relative_path(file['path'])] = offenses
        end
      end

      private

      def files_array(json)
        JSON.parse(json).fetch('files', [])
      rescue JSON::ParserError
        []
      end

      def build_offenses(offenses)
        Array(offenses).map do |offense|
          location = offense['location'] || {}
          {
            message: offense['message'],
            cop_name: offense['cop_name'],
            line_col: "#{location['line'] || location['start_line']}:#{location['column'] || location['start_column']}"
          }
        end
      end

      def relative_path(path)
        path.to_s.sub(%r{\Atmp/repos/[^/]+/[^/]+/}, '')
      end
    end
  end
end
