# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include AuthConcern
  include Pundit::Authorization

  helper_method :current_user, :signed_in?

  allow_browser versions: :modern

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    redirect_to root_path, alert: t('web.auth.unauthorized')
  end

  def authenticate_user!
    return if signed_in?

    redirect_to root_path, alert: t('web.auth.unauthenticated')
  end
end
