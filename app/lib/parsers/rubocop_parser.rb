# frozen_string_literal: true

require 'json'

module Parsers
  class RubocopParser
    def self.run(result_json)
      return {} if result_json.blank?

      data = JSON.parse(result_json)
      files = data['files'] || []
      return {} if files.empty?

      grouped = {}
      files.each do |file|
        file_name = file['path'].sub(%r{\Atmp/repos/[^/]+/[^/]+/}, '')

        offenses = file['offenses'].map do |offense|
          loc = offense['location'] || {}
          {
            message: offense['message'],
            cop_name: offense['cop_name'],
            line_col: "#{loc['line'] || loc['start_line']}:#{loc['column'] || loc['start_column']}"
          }
        end

        grouped[file_name] = offenses unless offenses.empty?
      end

      grouped
    end
  end
end
