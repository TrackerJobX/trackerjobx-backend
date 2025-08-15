class Plan < ApplicationRecord
  acts_as_paranoid

  has_many :user_plans, dependent: :destroy
  has_many :users, through: :user_plans

  validates :name, presence: true, uniqueness: true
end
