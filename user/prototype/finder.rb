module Iamswer::User::Prototype::Finder
  extend ActiveSupport::Concern

  class_methods do
    def find_by_id! id
      iamswer_user = Iamswer::User.find_by_id! id
      construct_record_from iamswer_user
    end

    def find_by_email! email
      iamswer_user = Iamswer::User.find_by_email! email
      construct_record_from iamswer_user
    end

    def find_by_username! username
      iamswer_user = Iamswer::User.find_by_username! username
      construct_record_from iamswer_user
    end
  end
end
