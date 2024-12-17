# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FacilitiesController, type: :controller do
  describe 'GET #show' do
    let(:params) {
      { id: }
    }
    context 'when request fails validation' do
      let(:id) { 'invalid' }
      it 'returns 400 response' do
        get(:show, params:)

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['errors']).to eq 'id is not a valid UUID'
      end
    end

    context 'when request succeeds' do
      let!(:facility) { create(:facility, name: 'Name') }

      context 'when facility exists' do
        let(:id) { facility.id }
        it 'returns a 200 response' do
          get(:show, params:)

          expect(response).to have_http_status(:ok)
          expect(response.parsed_body['id']).to eq(facility.id)
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:facility) { create(:facility, name: 'Facility') }
    let(:params) do
      {
        id:,
        name:,
        icon:
      }
    end

    context 'when request fails validation' do
      let(:id) { 'invalid' }
      let(:name) { '' }
      let(:icon) { '' }

      it 'returns 400 response' do
        patch(:update, params:)

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['errors']).to eq 'id is not a valid UUID, name must be filled, icon must be filled'
      end
    end

    context 'when request succeeds' do
      let(:name) { 'Name' }
      let(:icon) { 'Icon' }

      context 'when facility exists' do
        let(:id) { facility.id }
        it 'returns a 200 response' do
          patch(:update, params:)

          expect(response).to have_http_status(:accepted)
          expect(response.parsed_body['id']).to eq(facility.id)
          expect(response.parsed_body['name']).to eq(name)
          expect(response.parsed_body['icon']).to eq(icon)
          expect(Facility.first.name).to eq(name)
          expect(Facility.first.icon).to eq(icon)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:params) {
      { id: }
    }
    context 'when request fails validation' do
      let(:id) { 'invalid' }
      it 'returns 400 response' do
        delete(:destroy, params:)

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['errors']).to eq 'id is not a valid UUID'
      end
    end

    context 'when request succeeds' do
      let!(:facility) { create(:facility, name: 'Name') }

      context 'when facility exists' do
        let(:id) { facility.id }
        it 'returns a 204 response' do
          delete(:destroy, params:)

          expect(response).to have_http_status(:no_content)
          expect(Facility.count).to eq 0
        end
      end
    end
  end
end
