module Iamswer::Test::Mock
  def mock_user
    Iamswer::User.new.tap do |user|
      user.id = SecureRandom.alphanumeric
      user.email = "user@example.org"
      user.first_name = "Adam"
      user.last_name = "Notodikromo"
      user.username = "adamnoto"
      user.locale = Iamswer::Meta::Locales::AMERICAN_ENGLISH
    end
  end
end
