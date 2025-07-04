# frozen_string_literal: true

class GithubClientStub
  def initialize(_token); end

  def repo(_repo_id)
    load_repo
  end

  def filtered_repos
    [load_repo]
  end

  def commit_id(_repo_id)
    '86c521df09a0fcc38925119307051382e0e9dc44'
  end

  def create_hook(_repo_full_name); end

  private

  def load_repo
    path = Rails.root.join('test/fixtures/files/repo.json')
    payload = JSON.parse(File.read(path))
    agent = Sawyer::Agent.new('http://example.test')

    Sawyer::Resource.new(agent, payload)
  end
end
