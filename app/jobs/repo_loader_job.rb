# frozen_string_literal: true

class RepoLoaderJob < ApplicationJob
  queue_as :default

  def perform(repo_id)
    repository = Repository.find_by(id: repo_id)
    return unless repository

    github = ApplicationContainer[:github].new(repository.user.token)
    repo = github.repo(repository.github_id)

    repository.update!(
      name: repo.name,
      full_name: repo.full_name,
      language: repo.language.to_s.downcase.strip,
      clone_url: repo.clone_url,
      ssh_url: repo.ssh_url
    )

    github.create_hook(repo.full_name)
  end
end
