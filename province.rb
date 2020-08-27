class Iamswer::Province
  include ActiveModel::Model
  include Iamswer::Province::Finder

  attr_accessor :id,
    :country_code,
    :name

  alias_attribute :countryCode, :country_code

  def self.new_from_json body
    Iamswer::Error.add_context body: body

    error = body["error"]
    raise Iamswer::Error.from error if error
    raise Iamswer::Error::TypeError, "Invalid type" if body["type"] != "substate"

    province = new body.slice :id,
      :countryCode,
      :name

    province
  end
end
