# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CacheManager do
  include_context 'redis mock'

  let(:key) { 'key' }
  let(:value) { 'value' }

  describe '#fetch_value' do
    it 'retrieves the value for a given key' do
      redis.set(key, value)

      expect(CacheManager.fetch_value(key)).to eq('value')
    end

    context 'given specific expired' do
      let(:time) { 1.minute.to_i }

      it 'retrieves the value for a given key with specific expired' do
        redis.set(key, value, ex: time)

        expect(CacheManager.fetch_value(key)).to eq('value')

        Timecop.freeze(Time.zone.now + time) do
          expect(CacheManager.fetch_value(key)).to eq(nil)
        end
      end
    end
  end

  describe '#assign_value' do
    it 'sets the value for a given key' do
      CacheManager.assign_value(key, value)

      expect(redis.get(key)).to eq(value)
    end

    context 'given specific expired' do
      let(:time) { 1.minute.to_i }

      it 'sets the value for a given key with specific expired' do
        CacheManager.assign_value(key, value, time)

        expect(redis.get(key)).to eq(value)

        Timecop.freeze(Time.zone.now + time) do
          expect(redis.get(key)).to eq(nil)
        end
      end
    end
  end

  describe '#unassign_value' do
    it 'delete a key-value pair' do
      redis.set(key, value)

      expect(CacheManager.unassign_value(key)).to eq(1)
      expect(redis.get(key)).to eq(nil)
    end
  end

  describe '#exists?' do
    it 'check if a key-value pair exists in cache' do
      redis.set(key, value)

      expect(CacheManager.exists?(key)).to eq(true)
    end
  end
end
