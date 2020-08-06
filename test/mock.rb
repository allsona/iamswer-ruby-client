module Iamswer::Test::Mock
  def user_json_response given_values = {}
    {
      id: SecureRandom.alphanumeric,
      type: "user",
      email: "u#{rand(10_000)}@example.org",
      locale: "id-ID",
      appId: SecureRandom.alphanumeric,
      firstName: "Adam",
      lastName: "Baihaqi",
      name: "Adam Baihaqi",
      roles: [],
      username: "adambaihaqi#{rand(10_000)}",
      extraFields: {},
      createdAt: Time.current.to_datetime.to_s,
      updatedAt: Time.current.to_datetime.to_s,
    }.with_indifferent_access.merge(given_values.deep_symbolize_keys)
  end

  def session_json_response given_values = {}
    given_values.deep_symbolize_keys!

    {
      type: "session",
      id: SecureRandom.alphanumeric,
      isInvalidated: false,
      loggedOutAt: nil,
      validUntil: 5.days.from_now.to_datetime.to_s,
      user: user_json_response
    }.with_indifferent_access.merge(given_values.deep_symbolize_keys)
  end

  def mock_user given_values = {}
    Iamswer::User.typed_new_from_json user_json_response(given_values)
  end

  def mock_session given_values = {}
    Iamswer::Session.new_from_json session_json_response(given_values)
  end
end
