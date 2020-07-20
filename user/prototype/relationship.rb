module Iamswer::User::Prototype::Relationship
  extend ActiveSupport::Concern

  class_methods do
    include Iamswer::User::Relationship::HasMany
    include Iamswer::User::Relationship::OwnedBy
  end
end
