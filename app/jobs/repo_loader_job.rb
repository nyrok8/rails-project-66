# frozen_string_literal: true

class RepoLoaderJob < ApplicationJob
  queue_as :default

  def perform(repo_id)
    repository = Repository.find_by(id: repo_id)

    return unless repository

    client = ApplicationContainer[:github].client(repository.user.token)
    repo = ApplicationContainer[:github].repo(client, repository.github_id)

    repository.update!(
      name: repo.name,
      full_name: repo.full_name,
      language: repo.language,
      clone_url: repo.clone_url,
      ssh_url: repo.ssh_url
    )

    ApplicationContainer[:github].set_hook(client, repo.full_name)
  end
end
