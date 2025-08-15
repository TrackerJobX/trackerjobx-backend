FactoryBot.define do
  factory :plan do
    name { Faker::Job.field + SecureRandom.hex(2) }
    description { Faker::Lorem.paragraph }
    price { Faker::Number.number(digits: 3) }
  end
end
