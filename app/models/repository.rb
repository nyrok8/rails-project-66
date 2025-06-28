# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user

  has_many :checks, class_name: 'Repository::Check', dependent: :destroy, inverse_of: :repository

  validates :github_id, presence: true, uniqueness: { scope: :user_id }

  enumerize :language, in: %w[Ruby JavaScript]
end
