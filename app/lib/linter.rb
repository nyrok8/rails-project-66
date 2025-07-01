# frozen_string_literal: true

class Linter
  LINTERS = {
    'ruby' => ['rubocop', '--config', Rails.root.join('.rubocop.yml').to_s, '--format', 'json'],
    'javascript' => ['npx', 'eslint', '--config', Rails.root.join('eslint.config.mjs').to_s, '--format', 'json']
  }.freeze

  def self.run(repo)
    dir = Rails.root.join('tmp/repos')
    FileUtils.mkdir_p(dir)

    repo_dir = dir.join(repo.full_name)
    FileUtils.rm_rf(repo_dir)

    _, _, status = Open3.capture3('git', 'clone', repo.clone_url, repo_dir.to_s)
    return [false, nil, nil] unless status.success?

    cmd = LINTERS[repo.language] + [repo_dir.to_s]

    stdout, _, status = Open3.capture3(*cmd)
    case status.exitstatus
    when 0
      [true, true, stdout]
    when 1
      [true, false, stdout]
    else
      [false, nil, nil]
    end
  ensure
    FileUtils.rm_rf(repo_dir)
  end
end
