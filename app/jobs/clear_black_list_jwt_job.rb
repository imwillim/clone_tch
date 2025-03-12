# frozen_string_literal: true

class ClearBlackListJwtJob < ApplicationJob
  queue_as :default


  # TODO: write again not flushall
  def perform(*_args)
    RedisWrapper.redis_pool.then(&:flushall)
  end
end
