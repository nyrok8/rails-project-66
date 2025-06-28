# frozen_string_literal: true

class User < ApplicationRecord
  has_many :repositories, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :nickname, presence: true
  validates :token, presence: true
end
