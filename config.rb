class Iamswer::Config
  include Singleton

  attr_accessor :endpoint,
    :api_endpoint,
    :secret_key,
    :session_key_base,
    :subdomain

  class << self
    delegate :endpoint,
      :endpoint=,
      :api_endpoint,
      :api_endpoint=,
      :secret_key,
      :secret_key=,
      :session_key_base,
      :session_key_base=,
      :subdomain,
      :subdomain=,
      to: :instance
  end

  def self.configure
    yield self
  end

  def api_endpoint
    @api_endpoint.present? ? @api_endpoint : endpoint
  end
end
