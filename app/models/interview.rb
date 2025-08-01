class Interview < ApplicationRecord
  acts_as_paranoid

  belongs_to :job_application

  enum :interview_type, {
    online: "online",
    offline: "offline",
    phone: "phone"
  }, default: :online

  validates :interview_date, presence: true
  validates :interview_type, inclusion: { in: interview_types.keys }
end
