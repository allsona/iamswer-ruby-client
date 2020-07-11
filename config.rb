class Iamswer::Config
  include Singleton

  attr_accessor :endpoint,
    :secret_key,
    :session_key_base,
    :subdomain

  class << self
    delegate :endpoint,
      :endpoint=,
      :secret_key,
      :secret_key=,
      :session_key_base,
      :session_key_base=,
      :subdomain,
      :subdomain=
      to: :instance
  end

  def self.configure
    yield self
  end
end
