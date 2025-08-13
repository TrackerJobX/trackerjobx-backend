# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_paranoid
  has_secure_password
  has_secure_token :email_verification_token

  before_validation :generate_username, on: :create
  after_create :send_verification_email

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true
  enum :role, { member: "member", admin: "admin" }, default: :member

  def send_verification_email
    update(email_verification_sent_at: Time.current)
    UserMailer.email_verification(self).deliver_later
  end

  def verify_email!
    update(email_verified: true, email_verification_token: nil)
  end

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
