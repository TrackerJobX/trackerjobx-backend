class JobApplication < ApplicationRecord
  acts_as_paranoid

  belongs_to :user

  has_many :job_application_tags, dependent: :destroy
  has_many :tags, through: :job_application_tags

  enum :status, {
    draft: "draft",
    applied: "applied",
    interview: "interview",
    offer: "offer",
    rejected: "rejected",
    ghosted: "ghosted"
  }, default: :draft

  validates :company_name, presence: true
end
