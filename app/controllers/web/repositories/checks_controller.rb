# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  before_action :authenticate_user!

  def show
    @check = Repository::Check.find(params[:id])
    authorize @check.repository

    parser = Parsers::ParserResolver.for(@check.repository.language)
    @parsed_result = parser.run(@check.result)
  end

  def create
    repository = Repository.find(params[:repository_id])
    authorize repository

    check = repository.checks.create!

    LinterJob.perform_later(check.id)
    CheckLoaderJob.perform_later(check.id)

    redirect_to repository_path(repository), notice: t('.running')
  end
end
