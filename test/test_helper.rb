# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

OmniAuth.config.test_mode = true

WebMock.disable_net_connect!(allow_localhost: true)

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)

    fixtures :all

    setup do
      queue_adapter.perform_enqueued_jobs = true
      queue_adapter.perform_enqueued_at_jobs = true
    end
  end
end

class ActionDispatch::IntegrationTest
  def sign_in(user)
    auth_hash = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '12345',
      info: {
        nickname: user.nickname,
        email: user.email
      },
      credentials: {
        token: user.token
      }
    )

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_url('github')
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def sign_out
    delete logout_path
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
