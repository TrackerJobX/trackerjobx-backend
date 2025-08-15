class UserPlan < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :plan

  enum :status, {
    not_active: "not_active",
    active: "active",
    expired: "expired",
    canceled: "canceled"
  }, default: :not_active
end
