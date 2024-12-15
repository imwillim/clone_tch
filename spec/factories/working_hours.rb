# frozen_string_literal: true

FactoryBot.define do
  factory :working_hour do
    day { 'Monday' }
    open_hour { '9:30' }
    close_hour { '22:00' }
  end
end
