# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Coffee.unique.blend_name }
    description { 'MyString' }
    price { 9.99 }
    thumbnail { 'MyString' }
  end
end
