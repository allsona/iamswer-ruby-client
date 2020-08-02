module Iamswer::Invitation::Creator
  extend ActiveSupport::Concern

  class_methods do
    def create! fields
      body = Iamswer::Client.post "/api/v1/invitations/create", fields
      new_from_json body
    end
  end

  included do
    # fields attributes understood by API requests
    # especially for creating the data
    def fields
      if !inviter.is_a?(Iamswer::User::Prototype) && !inviter.is_a?(Iamswer::User)
        raise "Inviter must be a User"
      end

      {
        email: email,
        inviter_id: inviter.id,
        differ: differ,
      }
    end

    def save!
      raise "Field is already persisted" if id

      self.class.create! fields
    end
  end
end
