module Iamswer::Test::Cookies
  # set the cookie used by Iamswer to store successful signed in data
  def write_session_cookies given_values = {}
    session_cookie_name = Iamswer::SessionHandler.session_cookie_name
    session_id = SecureRandom.alphanumeric
    signed_session_id = Iamswer::SessionHandler.session_verifier.generate(session_id)
    backend_session_object = mock_session(given_values.merge(id: session_id))
    backend_user_object = backend_session_object.user

    allow(Iamswer::Session).to receive(:find_by_id!)
      .with(session_id)
      .and_return(backend_session_object)

    allow(Iamswer::User).to receive(:find_by_id!)
      .with(backend_user_object.id)
      .and_return(backend_user_object.iamswer_user)

    if respond_to?(:page)
      # if entering this block, we are doing end-to-end testing using capybara
      page.driver.set_cookie session_cookie_name, signed_session_id
    else
      # if entering this block, we are doing integration testing on the controller
      cookies[session_cookie_name] = Iamswer::SessionHandler.session_verifier.generate(session_id)
    end
  end
end
