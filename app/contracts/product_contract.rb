# frozen_string_literal: true

require 'dry-validation'

class ProductContract < Dry::Validation::Contract
  schema do
    required(:id).value(:string, :uuid_v4?)
  end
end
