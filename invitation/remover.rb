module Iamswer::Invitation::Remover
  extend ActiveSupport::Concern

  class_methods do
    def remove_by_id! id
      Iamswer::Client.delete "/api/v1/invitations/remove_by_id", id: id
      true
    end
  end

  included do
    def remove!
      self.class.remove_by_id! id
    end
  end
end
