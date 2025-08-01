FactoryBot.define do
  factory :interview do
    association :job_application
    interview_date { Faker::Date.backward(days: 14) }
    location { Faker::Address.city }
    interview_type { %w[online offline phone].sample }
    notes { Faker::Lorem.paragraph }
  end
end
