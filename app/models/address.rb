# frozen_string_literal: true

class Address < ApplicationRecord
  validates :house_number, presence: true
  validates :street, presence: true
  validates :ward, presence: true
  validates :district, presence: true
  validates :house_number, uniqueness: { scope: %i[street ward district],
                                         message: I18n.t('errors.models.taken', record: :address) }

  belongs_to :city
  belongs_to :store
end
