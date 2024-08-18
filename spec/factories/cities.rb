# frozen_string_literal: true

FactoryBot.define do
  factory :city do
    name { Faker::Address.unique.city }
    code { Faker::Address.unique.state_abbr }
  end
end
