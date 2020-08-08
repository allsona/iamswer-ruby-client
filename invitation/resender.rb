module Iamswer::Invitation::Resender
  extend ActiveSupport::Concern

  included do
    def resend!
      Iamswer::Client.post "/api/v1/invitations/resend", id: id
      true
    end
  end
end
