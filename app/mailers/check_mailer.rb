# frozen_string_literal: true

class CheckMailer < ApplicationMailer
  def failed_check(check)
    @check = check
    @repository = check.repository
    @user = @repository.user

    mail(
      to: @user.email,
      subject: "Проверка репозитория #{@repository.full_name} завершилась с ошибками"
    )
  end
end
