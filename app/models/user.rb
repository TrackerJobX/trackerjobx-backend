# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_paranoid
  has_secure_password

  before_validation :generate_username, on: :create

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true

  private

  def generate_username
    return if username.present?

    base = "#{first_name}#{last_name}".parameterize.presence || email.split("@").first
    candidate = base
    counter = 1

    # Pastikan username unik
    while User.where(username: candidate).exists?
      candidate = "#{base}#{counter}"
      counter += 1
    end

    self.username = candidate
  end
end
