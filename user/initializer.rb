module Iamswer::User::Initializer
  extend ActiveSupport::Concern

  class_methods do
    def new_from_json body
      Iamswer::Error.add_context body: body

      error = body["error"]
      raise Iamswer::Error.from error if error
      raise Iamswer::Error::TypeError, "Invalid type" if body["type"] != "user"

      user = new body.slice :id,
        :email,
        :locale,
        :firstName,
        :lastName,
        :name,
        :roles,
        :username,
        :extraFields,
        :createdAt,
        :updatedAt

      user
    end
  end
end
