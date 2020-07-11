class Iamswer::Session
  include ActiveModel::Model

  attr_accessor :id,
    :is_invalidated,
    :logged_out_at,
    :valid_until,
    :user

  alias_attribute :isInvalidated, :is_invalidated
  alias_attribute :loggedOutAt, :logged_out_at
  alias_attribute :validUntil, :valid_until
  alias_method :invalidated?, :is_invalidated

  def self.new_from_json body
    Iamswer::Error.add_context body: body

    error = body["error"]
    raise Iamswer::Error.from error if error
    raise Iamswer::Error::TypeError, "Invalid type" if body["type"] != "session"

    session = new body.slice :id,
      :isInvalidated,
      :loggedOutAt,
      :validUntil

    session.user = Iamswer::User.new_from_json body["user"]
    session
  end

  def self.authenticate!(login, password)
    body = Iamswer::Client.post(
      "/api/v1/sessions/authenticate",
      login: login,
      password: password,
    )

    new_from_json body
  end

  def valid_until=(value)
    @valid_until = DateTime.parse(value)
  end

  def logged_out?
    logged_out_at.present?
  end
end
