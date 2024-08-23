# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    street { Faker::Address.street_address }
    ward { Faker::Address.community }
    district { Faker::Address.state }
    house_number { Faker::Number.between(from: 1, to: 50) }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
