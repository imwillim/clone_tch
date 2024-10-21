# frozen_string_literal: true

RSpec.shared_context 'redis mock' do
  let(:redis) { MockRedis.new }

  before do
    allow(RedisWrapper).to receive(:redis_pool).and_return(ConnectionPool.new { redis })
  end
end
