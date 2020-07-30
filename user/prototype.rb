# Equip to a User-like model to gain access to underlying
# Iamswer::User, so that the User-like model does not need to
# directly inherit Iamswer::User, making Iamswer::User an internal
# prototype to the actual model
module Iamswer::User::Prototype
  extend ActiveSupport::Concern

  include Iamswer::User::Prototype::Initializer
  include Iamswer::User::Prototype::Fields
  include Iamswer::User::Prototype::ExtraFields
  include Iamswer::User::Prototype::Updater
  include Iamswer::User::Prototype::Finder
  include Iamswer::User::Prototype::Relationship

  included do
    include ActiveModel::Validations

    attr_accessor :iamswer_user

    iamswer_fields :created_at, :updated_at

    def ==(other_user)
      fields == other_user.fields
    end

    def reload
      self.class.find_by_id! id
    end
  end
end
