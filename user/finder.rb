module Zenta::User::Finder
  extend ActiveSupport::Concern

  class_methods do
    def find_by_id! id
      body = Zenta::Client.get "/api/v1/users/find_by_id", id: id
      new_from_json body
    end

    def find_by_email! email
      body = Zenta::Client.get "/api/v1/users/find_by_email", email: email
      new_from_json body
    end

    def find_by_username! username
      body = Zenta::Client.get "/api/v1/users/find_by_username", username: username
      new_from_json body
    end
  end
end
