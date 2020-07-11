class Iamswer::Config
  include Singleton

  class << self
    delegate :new_session_url, to: :instance
  end

  def new_session_url
    "/signin"
  end
end
