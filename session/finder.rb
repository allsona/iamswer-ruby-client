module Iamswer::Session::Finder
  extend ActiveSupport::Concern

  class_methods do
    def find_by_id! id
      body = Iamswer::Client.get "/api/v1/sessions/find_by_id", id: id
      new_from_json body
    end
  end
end
