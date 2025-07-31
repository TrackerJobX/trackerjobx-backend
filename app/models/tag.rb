class Tag < ApplicationRecord
  acts_as_paranoid

  validates :name, presence: true, uniqueness: true
end
