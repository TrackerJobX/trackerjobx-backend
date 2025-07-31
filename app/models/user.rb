# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_paranoid
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true
end
