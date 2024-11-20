# frozen_string_literal: true

class StoreSerializer < ActiveModel::Serializer
  attributes :name, :image_urls
end
