# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user!

  def index
    @repositories = current_user.repositories.includes(:checks).order(created_at: :desc)
  end

  def show
    @repository = Repository.find(params[:id])
    authorize @repository

    @checks = @repository.checks.order(created_at: :desc)
  end

  def new
    @repository = Repository.new

    client = ApplicationContainer[:github].client(current_user.token)
    @repos = ApplicationContainer[:github].filtered_repos(client)
  end

  def create
    @repository = current_user.repositories.build(github_id: repository_params[:github_id])

    if @repository.save
      RepoLoaderJob.perform_later(@repository.id)
      redirect_to repositories_path, notice: t('.success')
    else
      client = ApplicationContainer[:github].client(current_user.token)
      @repos = ApplicationContainer[:github].filtered_repos(client)

      render :new, status: :unprocessable_entity
    end
  end

  private

  def repository_params
    params.require(:repository).permit(:github_id)
  end
end
