class Iamswer::City
  include ActiveModel::Model
  include Iamswer::City::Finder

  attr_accessor :id,
    :province_id,
    :name

  alias_attribute :provinceId, :province_id

  def self.new_from_json body
    Iamswer::Error.add_context body: body

    error = body["error"]
    raise Iamswer::Error.from error if error
    raise Iamswer::Error::TypeError, "Invalid type" if body["type"] != "city"

    city = new body.slice :id,
      :provinceId,
      :name
  end
end
