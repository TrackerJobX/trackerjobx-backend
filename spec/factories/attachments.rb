FactoryBot.define do
  factory :attachment do
    attachment_type { Faker::Job.field }
    attachment_url { Faker::Internet.url }
    version { 'v1.0' }
  end
end
