module Iamswer::Province::Finder
  extend ActiveSupport::Concern

  class_methods do
    def collect_by_country_code country_code
      body = Iamswer::Client.get "/api/v1/places/collect_provinces_by_country_code", country_code: country_code
      body["collection"].map { |b| new_from_json(b) }
    end
  end
end
