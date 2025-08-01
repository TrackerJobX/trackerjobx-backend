class Tag < ApplicationRecord
  acts_as_paranoid

  has_many :job_application_tags
  has_many :job_applications, through: :job_application_tags

  validates :name, presence: true, uniqueness: true
end
