class JobApplication < ApplicationRecord
  acts_as_paranoid

  belongs_to :user

  enum :status, {
    draft: 'draft',
    applied: 'applied',
    interview: 'interview',
    offer: 'offer',
    rejected: 'rejected',
    ghosted: 'ghosted'
  }, default: :draft

  validates :company_name, presence: true
end
