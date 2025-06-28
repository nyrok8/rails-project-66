# frozen_string_literal: true

class LinterJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    check = Repository::Check.find_by(id: check_id)

    return unless check

    check.run!

    success, passed, output = ApplicationContainer[:linter].run(check.repository)

    if success
      check.update!(
        passed: passed,
        result: output
      )
      check.finish!
      unless passed
        CheckMailer.failed_check(check).deliver_later
      end
    else
      check.fail!
      CheckMailer.failed_check(check).deliver_later
    end
  end
end
