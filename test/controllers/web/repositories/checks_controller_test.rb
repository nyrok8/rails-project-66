# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user

    @repository = repositories(:one)
    @check = repository_checks(:one)
  end

  test 'should get show' do
    get repository_check_url(@repository, @check)
    assert_response :success
  end

  test 'should redirect show when not signed in' do
    sign_out
    get repository_check_url(@repository, @check)
    assert_redirected_to root_url
  end

  test 'should create check' do
    assert_difference('Repository::Check.count', 1) do
      post repository_checks_url(@repository)
    end

    created = @repository.checks.order(created_at: :desc).first
    assert { created.persisted? }
    assert_redirected_to repository_url(@repository)
  end

  test 'should not create check when not signed in' do
    sign_out

    assert_no_difference('Repository::Check.count') do
      post repository_checks_url(@repository)
    end

    assert_redirected_to root_url
  end

  test 'should not show check of another user' do
    sign_out
    sign_in users(:two)

    get repository_check_url(@repository, @check)
    assert_redirected_to root_url
  end
end
