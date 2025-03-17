# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :image_urls

  has_many :sizes, serializer: SizeSerializer
  has_many :toppings, serializer: ToppingSerializer
  has_many :tags, serializer: TagSerializer
end
