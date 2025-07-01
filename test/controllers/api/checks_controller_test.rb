# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
  end

  test 'should create check' do
    assert_difference('Repository::Check.count', 1) do
      post api_checks_url,
           headers: { 'X-GitHub-Event' => 'push' },
           params: {
             repository: { id: @repository.github_id },
             after: 'abc123'
           },
           as: :json
    end

    assert_response :ok
  end
end
