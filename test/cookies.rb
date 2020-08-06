module Iamswer::Test::Cookies
  # set the cookie used by Iamswer to store successful signed in data
  def write_session_cookies given_values = {}
    session_cookie_name = Iamswer::SessionHandler.session_cookie_name
    session_id = SecureRandom.alphanumeric
    cookies[session_cookie_name] = Iamswer::SessionHandler.session_verifier.generate(session_id)
    allow(Iamswer::Session).to receive(:find_by_id!).with(session_id).and_return(mock_session(given_values.merge(id: session_id)))
  end
end
