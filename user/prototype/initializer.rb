module Iamswer::User::Prototype::Initializer
  extend ActiveSupport::Concern

  included do
    def initialize
      self.iamswer_user = Iamswer::User.new
    end
  end

  class_methods do
    def construct_record_from iamswer_user
      user = new
      user.iamswer_user = iamswer_user
      iamswer_assign_extra_fields! user

      user
    end
  end
end
