# frozen_string_literal: true

module Parsers
  class ParserResolver
    PARSERS = {
      'Ruby' => RubocopParser,
      'JavaScript' => EslintParser
    }.freeze

    def self.for(language)
      PARSERS[language]
    end
  end
end
