# frozen_string_literal: true

class LinterStub
  def self.run(_repo)
    path = Rails.root.join('test/fixtures/files/linter_result.json')
    stdout = File.read(path)

    [true, false, stdout]
  end
end
