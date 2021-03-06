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

  # to define the specific user class, this class should `include`
  # `Iamswer::User::Prototype`.
  attr_accessor :user_class

  # if provided, the app stores and fetch user from the redis store
  # instead of from Iamswer's backend
  attr_accessor :redis_url

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

      :user_class,
      :user_class=,

      :redis_url,
      :redis_url=,

      to: :instance
  end

  def self.configure
    yield self
  end

  def api_endpoint
    @api_endpoint.present? ? @api_endpoint : endpoint
  end

  def self.constantized_user_class
    return nil unless user_class

    @constantized_user_class ||= user_class.constantize
  end

  def self.has_user_class?
    !!constantized_user_class
  end
end
