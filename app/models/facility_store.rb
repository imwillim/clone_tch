# frozen_string_literal: true

class FacilityStore < ApplicationRecord
  self.table_name = 'facilities_stores'

  belongs_to :facility
  belongs_to :store
end
