# A finder class methods attached to Iamswer::User, which is
# an internal implementation, a prototype of the actual model.
# Hence, methods defined here is by definition internal methods.
module Iamswer::User::Finder
  extend ActiveSupport::Concern

  class_methods do
    def find_by_id! id
      user = Iamswer::CacheManager::User.find_by_id id
      return user if user

      body = Iamswer::Client.get "/api/v1/users/find_by_id", id: id
      Iamswer::CacheManager.cache!(new_from_json(body))
      new_from_json body
    end

    def find_by_email! email
      user = Iamswer::CacheManager::User.find_by_email email
      return user if user

      body = Iamswer::Client.get "/api/v1/users/find_by_email", email: email
      Iamswer::CacheManager.cache!(new_from_json(body))
      new_from_json body
    end

    def find_by_username! username
      user = Iamswer::CacheManager::User.find_by_username username
      return user if user

      body = Iamswer::Client.get "/api/v1/users/find_by_username", username: username
      Iamswer::CacheManager.cache!(new_from_json(body))
      new_from_json body
    end
  end
end
