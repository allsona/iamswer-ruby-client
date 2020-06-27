class Zenta::User
  require_relative "user/initializer"
  require_relative "user/finder"

  include ActiveModel::Model
  include Zenta::Concern::DatedRecord
  include Zenta::User::Initializer
  include Zenta::User::Finder

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
