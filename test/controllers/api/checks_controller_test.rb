# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
  end

  test 'should respond with ok to ping event' do
    post api_checks_url,
         headers: { 'X-GitHub-Event' => 'ping' },
         as: :json

    assert_response :ok
  end

  test 'should respond with 422 to unsupported event' do
    post api_checks_url,
         headers: { 'X-GitHub-Event' => 'issues' },
         as: :json

    assert_response :unprocessable_entity
  end

  test 'should respond with 404 if repository not found' do
    post api_checks_url,
         headers: { 'X-GitHub-Event' => 'push' },
         params: {
           repository: { id: 999_999 },
           after: 'abc123'
         },
         as: :json

    assert_response :not_found
  end

  test 'should create check and enqueue job for valid push event' do
    assert_difference('Repository::Check.count', 1) do
      post api_checks_url,
           headers: { 'X-GitHub-Event' => 'push' },
           params: {
             repository: { id: @repository.github_id },
             after: 'abc123'
           },
           as: :json
    end

    created = @repository.checks.order(created_at: :desc).first

    assert { created }
    assert_response :created
  end
end
