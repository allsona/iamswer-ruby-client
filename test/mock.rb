module Iamswer::Test::Mock
  def user_json_response given_values = {}
    first_name = ["Adam", "Sam", "Herry", "Michael", "Feri", "Iwan"].sample
    last_name = ["Santoso", "Noto", "Darmadji", "Wirawan", "Gunawan"].sample
    name = "#{first_name} #{last_name}"

    {
      id: SecureRandom.alphanumeric,
      type: "user",
      email: "u#{rand(10_000)}@example.org",
      locale: "id-ID",
      appId: SecureRandom.alphanumeric,
      firstName: first_name,
      lastName: last_name,
      name: name,
      roles: [],
      username: "adambaihaqi#{rand(10_000)}",
      extraFields: {},
      createdAt: Time.current.to_datetime.to_s,
      updatedAt: Time.current.to_datetime.to_s,
    }.with_indifferent_access.merge(given_values.deep_symbolize_keys)
  end

  def mock_user given_values = {}
    Iamswer::User.typed_new_from_json user_json_response(given_values)
  end

  def session_json_response given_values = {}
    {
      type: "session",
      id: SecureRandom.alphanumeric,
      isInvalidated: false,
      loggedOutAt: nil,
      validUntil: 5.days.from_now.to_datetime.to_s,
      user: user_json_response
    }.with_indifferent_access.merge(given_values.deep_symbolize_keys)
  end

  def mock_session given_values = {}
    Iamswer::Session.new_from_json session_json_response(given_values)
  end

  def invitation_json_response given_values = {}
    {
      id: SecureRandom.alphanumeric,
      type: "invitation",
      status: "sent",
      email: "a@a.com",
      differ: "123",
      createdAt: Time.current.to_datetime.to_s,
      sentAt: Time.current.to_datetime.to_s,
      seenAt: nil,
      registeredAt: nil,
      inviter: user_json_response
    }.with_indifferent_access.merge(given_values.deep_symbolize_keys)
  end

  def mock_invitation given_values = {}
    Iamswer::Invitation.new_from_json invitation_json_response(given_values)
  end
end
