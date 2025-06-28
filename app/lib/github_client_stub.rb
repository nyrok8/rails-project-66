# frozen_string_literal: true

class GithubClientStub
  def self.client(_token); end

  def self.repo(_client, _repo_id)
    load_repo
  end

  def self.filtered_repos(_client)
    [load_repo]
  end

  def self.commit_id(_client, _repo_id)
    '86c521df09a0fcc38925119307051382e0e9dc44'
  end

  def self.set_hook(_client, _repo_full_name); end

  def self.load_repo
    path = Rails.root.join('test/fixtures/files/repo.json')
    payload = JSON.parse(File.read(path))

    agent = Sawyer::Agent.new('http://example.test')
    Sawyer::Resource.new(agent, payload)
  end
  private_class_method :load_repo
end
