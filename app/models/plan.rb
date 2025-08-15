class Plan < ApplicationRecord
  acts_as_paranoid

  has_many :user_plans, dependent: :destroy
  has_many :users, through: :user_plans

  validates :name, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :job_applications_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :interviews_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :attachments_limit, numericality: { greater_than_or_equal_to: 0 }
end
