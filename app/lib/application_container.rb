# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :github, -> { GithubClientStub }
    register :linter, -> { LinterStub }
  else
    register :github, -> { GithubClient }
    register :linter, -> { Linter }
  end
end
