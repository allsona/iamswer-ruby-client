# A finder class methods attached to Iamswer::User, which is
# an internal implementation, a prototype of the actual model.
# Hence, methods defined here is by definition internal methods.
module Iamswer::User::Finder
  extend ActiveSupport::Concern

  class_methods do
    def find_by_id! id
      body = Iamswer::Client.get "/api/v1/users/find_by_id", id: id
      new_from_json body
    end

    def find_by_email! email
      body = Iamswer::Client.get "/api/v1/users/find_by_email", email: email
      new_from_json body
    end

    def find_by_username! username
      body = Iamswer::Client.get "/api/v1/users/find_by_username", username: username
      new_from_json body
    end
  end
end
