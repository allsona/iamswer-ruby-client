class Iamswer::CacheManager
  include Singleton

  KEY_PREFIX = "lib/iamswer:"

  class << self
    delegate :enabled?,
      :set,
      :get,
      :cache!,
      :reset_cache,

      to: :instance
  end

  # check if redis is available
  def enabled?
    @enabled ||= begin
      require "connection_pool"
      Redis
      Hiredis::Connection

      true
    rescue
      false
    end
  end

  def connection_pool
    return unless enabled?

    @connection_pool ||= begin
      ConnectionPool.new(size: 5, timeout: 5) { ::Redis.new(url: redis_url) }
    end
  end

  # this function acts as a facade to the real function
  # that get the value from the cache. currently, it only
  # support redis backend.
  def get given_key
    key = "#{KEY_PREFIX}#{given_key}"

    connection_pool.with do |redis|
      redis.get key
    end
  end

  # this function acts as a facade to the real function
  # that set a value to the cache system. currently, it only
  # support redis as the system backend.
  def set given_key, string
    key = "#{KEY_PREFIX}#{given_key}"

    connection_pool.with do |redis|
      result = redis.set key, string
      result == "OK"
    end
  end

  def cache! object
    return unless enabled?

    case object
    when Iamswer::User
      Iamswer::CacheManager::User.cache object
    when Iamswer::Session
      Iamswer::CacheManager::Session.cache object
    else
      raise Iamswer::Error, "Unable to cache a #{object.class} instance: #{object}"
    end
  end

  # remove everything in the cache
  def reset_cache
    return unless enabled?

    connection_pool.with do |redis|
      redis.keys("#{KEY_PREFIX}*").each do |key|
        redis.del key
      end
    end
  end

  private

    def redis_url
      Iamswer::Config.redis_url
    end

end
