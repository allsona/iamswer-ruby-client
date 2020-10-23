module Iamswer::Session::Finder
  extend ActiveSupport::Concern

  class_methods do
    def find_by_id! id
      session = Iamswer::CacheManager::Session.find_by_id id
      return session if session

      body = Iamswer::Client.get "/api/v1/sessions/find_by_id", id: id

      if body && body["user"].present?
        Iamswer::CacheManager.cache!(new_from_json(body))
      end

      new_from_json body
    end
  end
end
