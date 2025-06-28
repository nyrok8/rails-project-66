# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user

    @repository = repositories(:one)
  end

  test 'should get index' do
    get repositories_url
    assert_response :success
  end

  test 'should get show' do
    get repository_url(@repository)
    assert_response :success
  end

  test 'should redirect show when not signed in' do
    sign_out
    get repository_url(@repository)

    assert_redirected_to root_url
  end

  test 'should get new' do
    get new_repository_url
    assert_response :success
  end

  test 'should redirect new when not signed in' do
    sign_out
    get new_repository_url

    assert_redirected_to root_url
  end

  test 'should create repository' do
    github_id = 123

    assert_difference('Repository.count', 1) do
      post repositories_url, params: {
        repository: { github_id: github_id }
      }
    end

    created = Repository.find_by(github_id: github_id)
    assert { created.user == @user }
    assert_redirected_to repositories_url
  end

  test 'should not create repository with duplicate github_id' do
    assert_no_difference('Repository.count') do
      post repositories_url, params: {
        repository: { github_id: @repository.github_id }
      }
    end

    assert_response :unprocessable_entity
  end

  test 'should redirect create when not signed in' do
    sign_out

    assert_no_difference('Repository.count') do
      post repositories_url, params: {
        repository: { github_id: 123 }
      }
    end

    assert_redirected_to root_url
  end

  test 'should not show repository of another user' do
    sign_out
    sign_in users(:two)

    get repository_url(@repository)
    assert_redirected_to root_url
  end
end
