FactoryBot.define do
  factory :tag do
    name { Faker::Job.field + SecureRandom.hex(2) }
  end
end
