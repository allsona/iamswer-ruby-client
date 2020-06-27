class Zenta::Controller::UnauthorizedController < ActionController::Metal
  include ActionController::UrlFor
  include ActionController::Redirecting
  include Rails.application.routes.mounted_helpers

  delegate :flash, to: :request

  def self.call(env)
    # initialize the controller and call the #respond method
    @respond ||= action :respond
    @respond.call env
  end

  def respond
    message = env["warden.options"].fetch(:message, "unauthorized.user")
    flash.alert = I18n.t(message)

    redirect_to Zenta::Config.new_session_url
  end
end
