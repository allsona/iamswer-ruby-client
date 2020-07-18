class Iamswer::Config
  include Singleton

  # the subdomain (without any protocol)
  attr_accessor :subdomain

  # The endpoint is user-facing endpoint to Sonasign.
  attr_accessor :endpoint

  # The endpoint to Iamswer's API system. In a dockerized application,
  # this might be different from the public endpoint, since API endpoint
  # is called within the container, thus could not have access to the
  # localhost outside of the container
  attr_accessor :api_endpoint

  # a credential for authentication when sending API requests
  attr_accessor :secret_key

  # used for reading/signing cookies. this value should be the same
  # with what's set at Iamswer's own system
  attr_accessor :session_key_base

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
