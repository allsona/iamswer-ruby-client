class Iamswer::Invitation
  include ActiveModel::Model
  include Iamswer::Concern::DatedRecord
  include Iamswer::Invitation::Initializer
  include Iamswer::Invitation::Finder
  include Iamswer::Invitation::Remover
  include Iamswer::Invitation::Creator
  include Iamswer::Invitation::Resender

  attr_accessor :id,
    :status,
    :code,
    :differ,
    :email,
    # a user record
    :inviter,
    # a user record
    :user

  dated_field :registered_at
  dated_field :seen_at
  dated_field :sent_at
end
