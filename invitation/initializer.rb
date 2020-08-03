module Iamswer::Invitation::Initializer
  extend ActiveSupport::Concern

  class_methods do
    def new_from_json body
      Iamswer::Error.add_context body: body

      error = body["error"]
      raise Iamswer::Error.from error if error
      raise Iamswer::Error::TypeError, "Invalid type" unless body["type"] == "invitation"

      invitation = new body.slice :id,
        :status,
        :code,
        :differ,
        :email,
        :registeredAt,
        :seenAt,
        :sentAt

      invitation.inviter = Iamswer::User.typed_new_from_json body[:inviter]

      if body[:register]
        invitation.register = Iamswer::User.new_from_json body[:register]
      end

      invitation
    end
  end
end
