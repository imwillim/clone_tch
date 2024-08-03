# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :image_urls, :sizes

  has_many :sizes, serializer: SizeSerializer
  has_many :toppings, serializer: ToppingSerializer
  has_one :tag, serializer: TagSerializer
end
