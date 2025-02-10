# frozen_string_literal: true

# # frozen_string_literal: true
#
# require 'rails_helper'
#
# RSpec.describe User do
#   let(:user) { build(:user) }
#
#   describe 'validations' do
#     it { is_expected.to validate_presence_of(:email) }
#     it { is_expected.to validate_presence_of(:password) }
#
#     before do
#       user.update(password: '1')
#     end
#
#     it 'raise an error' do
#       expect(user).not_to be_valid
#       expect(user.errors[:password].first).to eq 'is too short (minimum is 6 characters)'
#     end
#   end
# end
