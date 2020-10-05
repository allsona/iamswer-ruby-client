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

  def attributes(json_compatible: false)
    attributes = {
      id: id, # string
      email: email,
      extra_fields: extra_fields,
      first_name: first_name,
      last_name: last_name,
      locale: locale,
      name: name,
      roles: roles,
      created_at: json_compatible ? created_at.to_s : created_at,
      updated_at: json_compatible ? updated_at.to_s : updated_at,
    }

    if json_compatible
      attributes[:firstName] = attributes.delete :first_name
      attributes[:lastName] = attributes.delete :last_name
      attributes[:extraFields] = attributes.delete :extra_fields
      attributes[:createdAt] = attributes.delete :created_at
      attributes[:updatedAt] = attributes.delete :updated_at
    end

    attributes
  end
end
