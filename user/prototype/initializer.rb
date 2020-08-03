module Iamswer::User::Prototype::Initializer
  extend ActiveSupport::Concern

  included do
    def initialize
      self.iamswer_user = Iamswer::User.new
    end
  end

  class_methods do
    # User of Iamswer should have a real User class of their own, rather
    # than depending on Iamswer::User. To instantiate such a class,
    # we use this method. The first argument is an instance of
    # Iamswer::User.
    def construct_record_from iamswer_user
      user = new
      user.iamswer_user = iamswer_user
      iamswer_assign_extra_fields! user

      user
    end
  end
end
