module Iamswer::City::Finder
  extend ActiveSupport::Concern

  class_methods do
    def collect_by_province_id province_id
      body = Iamswer::Client.get "/api/v1/places/collect_cities_by_province_id", province_id: province_id
      body["collection"].map { |b| new_from_json(b) }
    end
  end
end
