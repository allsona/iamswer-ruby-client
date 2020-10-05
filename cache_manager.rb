class Iamswer::CacheManager
  include Singleton

  class << self
    delegate :enabled?,
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

  def redis
    return unless enabled?

    connection_pool.with do |redis|
      yield redis
    end
  end

  private

    def redis_url
      Iamswer::Config.redis_url
    end

end
