# A module to help define many kinds of relationships from
# some instances, to any `Iamswer::User` instances
module Iamswer::User::Relationship
  extend ActiveSupport::Concern

  class_methods do
    include Iamswer::User::Relationship::OwnedBy
  end
end
