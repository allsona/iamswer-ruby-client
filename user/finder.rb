# A finder class methods attached to Iamswer::User, which is
# an internal implementation, a prototype of the actual model.
# Hence, methods defined here is by definition internal methods.
module Iamswer::User::Finder
  extend ActiveSupport::Concern

  class_methods do
    def find_by_id! id
      body = Iamswer::CacheManager::User.find_by_id id

      unless body
        body = Iamswer::Client.get "/api/v1/users/find_by_id", id: id
        record = Iamswer::CacheManager.cache(new_from_json(body))
      end

      new_from_json body
    end

    def find_by_email! email
      body = Iamswer::CacheManager::User.find_by_email email

      unless body
        body = Iamswer::Client.get "/api/v1/users/find_by_email", email: email
        record = Iamswer::CacheManager.cache(new_from_json(body))
      end

      new_from_json body
    end

    def find_by_username! username
      body = Iamswer::CacheManager::User.find_by_username username

      unless body
        body = Iamswer::Client.get "/api/v1/users/find_by_username", username: username
        record = Iamswer::CacheManager.cache(new_from_json(body))
      end

      new_from_json body
    end
  end
end
