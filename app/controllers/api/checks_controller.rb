# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    event = request.headers['X-GitHub-Event']

    return head :ok if event == 'ping'
    return head :unprocessable_entity unless event == 'push'

    repo_id = params[:repository][:id]
    commit_id = params[:after]

    repository = Repository.find_by(github_id: repo_id)
    return head :not_found unless repository

    check = repository.checks.create!(commit_id: commit_id)

    LinterJob.perform_later(check.id)

    head :created
  end
end
