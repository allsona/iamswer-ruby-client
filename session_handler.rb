module Iamswer::SessionHandler
  def self.session_verifier
    @session_verifier ||= ActiveSupport::MessageVerifier.new Iamswer::Config.session_key_base
  end

  def session_verifier
    Iamswer::SessionHandler.session_verifier
  end

  def self.session_cookie_name
    @session_cookie_name ||= "#{Iamswer::Config.subdomain}_iamswer_session"
  end

  # the name of the app's cookie that will store the user's session ID
  def session_cookie_name
    Iamswer::SessionHandler.session_cookie_name
  end

  def remove_session_cookies
    cookies.delete session_cookie_name, domain: :all
  end

  def current_session
    # rails cookies respond to permanent, but others don't (eg: Grape::Cookies)
    if cookies.respond_to? :permanent
      session_id = cookies.permanent[session_cookie_name]
    else
      session_id = cookies[session_cookie_name]
    end

    session_id = session_verifier.verify session_id
    Iamswer::Session.find_by_id! session_id
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    # note that we should never catch blindly, we should never catch all type of errors
    # otherwise, those errors will be swallowed. let's just swallow errors that we know
    # it is a result of invalid cookies, not because of, for example, a missing method
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
