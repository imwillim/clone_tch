# frozen_string_literal: true

class FacilitySerializer < ActiveModel::Serializer
  attributes :id, :name, :icon, :created_at, :updated_at
  attribute :store_id, if: -> { @instance_options[:store_id].present? }

  def store_id
    @instance_options[:store_id]
  end
end
