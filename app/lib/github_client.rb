# frozen_string_literal: true

class GithubClient
  SUPPORTED_LANGS = Repository.language.values.freeze

  def initialize(token)
    @client = Octokit::Client.new(access_token: token, auto_paginate: true)
  end

  def repo(repo_id)
    @client.repo(repo_id.to_i)
  end

  def filtered_repos
    @client.repos.select do |repo|
      SUPPORTED_LANGS.include?(repo.language.to_s.downcase.strip)
    end
  end

  def commit_id(repo_id)
    @client.commits(repo_id, nil, per_page: 1).first.sha
  end

  def create_hook(repo_full_name)
    url = Rails.application.routes.url_helpers.url_for(
      controller: 'api/checks',
      action: 'create',
      only_path: false,
      host: Rails.application.config.default_url_options[:host]
    )

    return if @client.hooks(repo_full_name).any? { |h| h.dig(:config, :url) == url }

    @client.create_hook(
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
