# This class should not be inherited directly by any User model.
# A User model should include the Iamswer::User::Prototype. In turn,
# the prototype is an interface to an instance of `Iamswer::User`.
class Iamswer::User
  include ActiveModel::Model
  include Iamswer::Concern::DatedRecord
  include Iamswer::User::Initializer
  include Iamswer::User::Finder

  attr_accessor :id,
    :email,
    :first_name,
    :last_name,
    :name,
    :username,
    :locale,
    :roles,
    :extra_fields

  alias_attribute :firstName, :first_name
  alias_attribute :lastName, :last_name
  alias_attribute :extraFields, :extra_fields
end
