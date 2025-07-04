# frozen_string_literal: true

class CheckLoaderJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    check = Repository::Check.find_by(id: check_id)
    return unless check

    repo = check.repository
    github = ApplicationContainer[:github].new(repo.user.token)
    commit = github.commit_id(repo.github_id)

    check.update!(commit_id: commit)
  end
end
