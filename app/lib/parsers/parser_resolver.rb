# frozen_string_literal: true

module Parsers
  class ParserResolver
    PARSERS = {
      'ruby' => RubocopParser,
      'javascript' => EslintParser
    }.freeze

    def self.for(language)
      PARSERS[language]
    end
  end
end
