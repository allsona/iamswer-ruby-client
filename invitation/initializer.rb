module Iamswer::Invitation::Initializer
  extend ActiveSupport::Concern

  class_methods do
    def new_from_json body
      Iamswer::Error.add_context body: body

      error = body["error"]
      raise Iamswer::Error.from error if error

      invitation = new body.slice :id,
        :status,
        :code,
        :differ,
        :email,
        :registeredAt,
        :seenAt,
        :sentAt

      invitation.inviter = Iamswer::User.typed_new_from_json body[:inviter]

      if body[:user]
        invitation.user = Iamswer::User.new_from_json body[:user]
      end

      invitation
    end
  end
end
