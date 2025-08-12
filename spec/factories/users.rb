# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username    { Faker::Internet.username }
    email       { Faker::Internet.unique.email }
    password    { "password123" }
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    phone       { Faker::PhoneNumber.cell_phone_in_e164 }
    role        { "member" }
  end
end
