module Iamswer::Invitation::Finder
  extend ActiveSupport::Concern

  class_methods do
    def find_by_id! id
      body = Iamswer::Client.get "/api/v1/invitations/find_by_id", id: id
      new_from_json body
    end

    def find_by_email_and_differ email, differ
      body = Iamswer::Client.get "/api/v1/invitations/find_by_email_and_differ",
        email: email, differ: differ

      new_from_json body
    end

    def collect_by_differ differ
      body = Iamswer::Client.get "/api/v1/invitations/collect_by_differ", differ: differ
      body["collection"].map { |b| new_from_json(b) }
    end
  end
end
