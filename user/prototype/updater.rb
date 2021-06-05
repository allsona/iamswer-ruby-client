module Iamswer::User::Prototype::Updater
  extend ActiveSupport::Concern

  included do
    def update!
      body = Iamswer::Client.post "/api/v1/users/update", fields
      iamswer_user = Iamswer::User.new_from_json body
      Iamswer::CacheManager.cache!(iamswer_user)
      self.iamswer_user = iamswer_user
    end

    def save!
      update!
    end
  end
end
