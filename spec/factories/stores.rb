# frozen_string_literal: true

FactoryBot.define do
  factory :store do
    name { Faker::Commerce.unique.vendor }
  end
end
