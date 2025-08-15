FactoryBot.define do
  factory :user_plan do
    association :user
    association :plan

    purchase_at { Faker::Date.backward(days: 14) }
    expires_at { Faker::Date.forward(days: 14) }
    status { "active" }
  end
end
