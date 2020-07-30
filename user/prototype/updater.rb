module Iamswer::User::Prototype::Updater
  extend ActiveSupport::Concern

  included do
    def update!
      body = Iamswer::Client.post "/api/v1/users/update", fields
      self.iamswer_user = Iamswer::User.new_from_json body
    end

    def save!
      update!
    end
  end
end
