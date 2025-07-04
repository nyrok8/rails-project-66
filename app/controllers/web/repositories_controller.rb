# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user!

  def index
    @repositories = current_user.repositories.includes(:checks).order(created_at: :desc)
  end

  def show
    @repository = Repository.find(params[:id])
    authorize @repository, :owner?

    @checks = @repository.checks.order(created_at: :desc)
  end

  def new
    @repository = Repository.new
    @repos = github.filtered_repos
  end

  def create
    @repository = current_user.repositories.build(github_id: repository_params[:github_id])

    if @repository.save
      RepoLoaderJob.perform_later(@repository.id)
      redirect_to repositories_path, notice: t('.success')
    else
      @repos = github.filtered_repos
      render :new, status: :unprocessable_entity
    end
  end

  private

  def github = (@github ||= ApplicationContainer[:github].new(current_user.token))

  def repository_params
    params.require(:repository).permit(:github_id)
  end
end
