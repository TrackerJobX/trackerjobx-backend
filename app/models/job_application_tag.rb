class JobApplicationTag < ApplicationRecord
  acts_as_paranoid

  belongs_to :job_application
  belongs_to :tag
end
