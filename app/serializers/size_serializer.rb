# frozen_string_literal: true

class SizeSerializer < ActiveModel::Serializer
  attributes :id, :name, :icon, :price
end
