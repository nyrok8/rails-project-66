# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    user = User.find_or_initialize_by(email: auth.info.email)
    user.nickname = auth.info.nickname
    user.token = auth.credentials.token

    user.save

    sign_in(user)
    redirect_to root_path, notice: t('.signed_in')
  end

  def destroy
    sign_out
    redirect_to root_path, notice: t('.signed_out')
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
