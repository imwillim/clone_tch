# frozen_string_literal: true

class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', dependent: :destroy, inverse_of: 'parent', foreign_key: 'parent_id'
  has_many :products, dependent: :destroy
end
