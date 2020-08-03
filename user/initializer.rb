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

    # Instantiating Iamswer::User with a JSON data, after that passing it
    # to instantiate the real user class, the class where `Iamswer::User::Prototype`
    # is included within. However, if there is no such a class, or such a
    # class is not defined in the config through `user_class`, then
    # an instance of `Iamswer::User` is returned instead
    def typed_new_from_json body
      user = Iamswer::User.new_from_json body

      Iamswer::Config.has_user_class? ?
        Iamswer::Config.constantized_user_class.construct_record_from(user) :
        user
    end
  end
end
