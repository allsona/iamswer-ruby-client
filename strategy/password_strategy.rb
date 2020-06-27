class Zenta::Strategy::PasswordStrategy < Warden::Strategies::Base
  def valid?
    return false if request.get?

    user_data = params.fetch("user", {})
    user_data["email"].present? &&
      user_data["password"].present?
  end

  def authenticate!
  end
end
