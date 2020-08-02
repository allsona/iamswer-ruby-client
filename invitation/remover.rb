module Iamswer::Invitation::Remover
  extend ActiveSupport::Concern

  class_methods do
    def remove_by_id! id
      body = Iamswer::Client.delete "/api/v1/invitations/remove_by_id", id: id
      new_from_json body
    end
  end

  included do
    def remove!
      self.class.remove_by_id! id
      true
    end
  end
end
