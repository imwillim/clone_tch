# frozen_string_literal: true

class StoreSerializer < ActiveModel::Serializer
  attributes :id, :name, :address

  has_many :working_hours

  def address
    "#{object.address.house_number} #{object.address.street}, #{object.address.ward}, #{object.address.district}, #{object.city.name}"
  end
end
