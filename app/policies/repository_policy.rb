# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def owner?
    record.user_id == user.id
  end
end
