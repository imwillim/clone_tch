# frozen_string_literal: true

class RedisWrapper
  POOL_TIME_OUT = 5
  POOL_SIZE = 5

  def self.redis_pool
    @redis_pool ||= ConnectionPool.new(timeout: POOL_TIME_OUT, size: POOL_SIZE) { Redis.new }
  end
end
