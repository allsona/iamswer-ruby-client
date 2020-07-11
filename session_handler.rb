module Iamswer::SessionHandler
  def session_verifier
    @session_verifier ||= ActiveSupport::MessageVerifier.new Iamswer::Config.session_key_base
  end

  # the name of the app's cookie that will store the user's session ID
  def session_cookie_name
    "#{current_app.subdomain}_iamswer_session"
  end

  def remove_session_cookies
    cookies.delete session_cookie_name, domain: :all
  end

  def current_session
    session_id = cookies.permanent[session_cookie_name]
    session_id = session_verifier.verify session_id
    Iamswer::Session.find_by_id! session_id
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  rescue => e
    ErrorReporter.call e
    nil
  end

  def current_user
    @current_register ||= current_session&.user
  end

  def authenticate!
    return if current_user

    redirect_to Iamswer::Config.endpoint
  end
end
