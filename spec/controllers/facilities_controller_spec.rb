# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FacilitiesController, type: :controller do
  describe 'GET #show' do
    let(:params) do
      { id: }
    end
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

  describe 'POST #create' do
    let(:params) do
      {
        store_id:,
        name:,
        icon:
      }
    end
    context 'when request fails validation' do
      let(:store_id) { 'invalid' }
      let(:name) { {} }
      let(:icon) { {} }
      it 'returns 400 response' do
        post(:create, params:)

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body['errors']).to eq 'store_id must be an integer, name is missing, icon is missing'
      end
    end

    context 'when request succeeds' do
      let(:store_id) { store.id }
      let(:name) { 'Name' }
      let(:icon) { 'Icon' }
      let!(:store) { create(:store) }

      context 'when facility exists' do
        it 'returns a 201 response' do
          post(:create, params:)

          expect(response).to have_http_status(:created)
          expect(response.parsed_body['id']).to eq(Facility.first.id)
          expect(Facility.count).to eq 1
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:facility) { create(:facility) }
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
        expect(response.parsed_body['errors']).to eq 'id is not a valid UUID'
      end
    end

    context 'when request succeeds' do
      context 'when request body is filled' do
        let(:id) { facility.id }
        let(:name) { 'Name' }
        let(:icon) { 'Icon' }

        it 'returns a 200 response of updated facility' do
          patch(:update, params:)

          expect(response).to have_http_status(:accepted)
          expect(response.parsed_body['id']).to eq(facility.id)
          expect(response.parsed_body['name']).to eq(name)
          expect(response.parsed_body['icon']).to eq(icon)
          expect(Facility.first.name).to eq(name)
          expect(Facility.first.icon).to eq(icon)
        end
      end

      context 'when request body is empty' do
        let(:params) { { id: } }
        let(:id) { facility.id }

        it 'returns a 200 response of original facility' do
          patch(:update, params:)

          expect(response).to have_http_status(:accepted)
          expect(response.parsed_body['id']).to eq(facility.id)
          expect(response.parsed_body['name']).to eq(facility.name)
          expect(response.parsed_body['icon']).to eq(facility.icon)
          expect(Facility.first.name).to eq(facility.name)
          expect(Facility.first.icon).to eq(facility.icon)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:params) do
      { id: }
    end
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
      let(:id) { facility.id }

      context 'when facility exists' do
        it 'returns a 204 response' do
          delete(:destroy, params:)

          expect(response).to have_http_status(:no_content)
          expect(Facility.count).to eq 0
        end
      end
    end
  end
end
