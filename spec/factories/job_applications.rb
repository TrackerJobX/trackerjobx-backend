FactoryBot.define do
  factory :job_application do
    association :user
    company_name { Faker::Company.name }
    position_title { Faker::Job.title }
    application_link { Faker::Internet.url }
    status { 'draft' }
    application_date { Faker::Date.backward(days: 14) }
    deadline_date { Faker::Date.forward(days: 14) }
    notes { Faker::Lorem.paragraph }
  end
end
