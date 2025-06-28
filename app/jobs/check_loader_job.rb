# frozen_string_literal: true

class CheckLoaderJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    check = Repository::Check.find_by(id: check_id)

    return unless check

    repository = check.repository

    client = ApplicationContainer[:github].client(repository.user.token)
    commit_id = ApplicationContainer[:github].commit_id(client, repository.github_id)

    check.update!(commit_id: commit_id)
  end
end
