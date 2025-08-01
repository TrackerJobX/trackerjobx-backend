class Attachment < ApplicationRecord
  acts_as_paranoid

  belongs_to :job_application

  validates :attachment_type, :attachment_url, presence: true
end
