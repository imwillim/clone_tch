# frozen_string_literal: true

class CacheManager
  def self.fetch_value(key)
    RedisWrapper.redis_pool.then do |redis|
      redis.get(key)
    end
  end

  def self.assign_value(key, value)
    RedisWrapper.redis_pool.then do |redis|
      redis.set(key, value)
    end
  end

  def self.unassign_value(key)
    RedisWrapper.redis_pool.then do |redis|
      redis.del(key)
    end
  end

  def self.exists?(key)
    RedisWrapper.redis_pool.then do |redis|
      redis.exists?(key)
    end
  end
end
