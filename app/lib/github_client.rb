# frozen_string_literal: true

class GithubClient
  def self.client(token)
    Octokit::Client.new(access_token: token, auto_paginate: true)
  end

  def self.repo(client, repo_id)
    client.repo(repo_id.to_i)
  end

  def self.filtered_repos(client)
    supported = Repository.language.values
    client.repos.select do |repo|
      language = repo.language.to_s.downcase.strip
      supported.include?(language)
    end
  end

  def self.commit_id(client, repo_id)
    client.commits(repo_id, nil, per_page: 1).first.sha
  end

  def self.set_hook(client, repo_full_name)
    url = Rails.application.routes.url_helpers.url_for(
      controller: 'api/checks',
      action: 'create',
      only_path: false,
      host: Rails.application.config.default_url_options[:host]
    )

    existing_hook = client.hooks(repo_full_name).find do |hook|
      hook[:config][:url] == url
    end

    return if existing_hook

    client.create_hook(
      repo_full_name,
      'web',
      {
        url: url,
        content_type: 'json'
      },
      {
        events: ['push'],
        active: true
      }
    )
  end
end
