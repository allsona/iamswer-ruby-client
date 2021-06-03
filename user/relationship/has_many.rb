module Iamswer::User::Relationship::HasMany
  # To define a has_many association, we can do something like this:
  #
  # class User
  #   has_many :organizations
  # end
  #
  # That is assuming if we have an Organization model, the foreign key
  # to the User record is defined by a user_id field. If the foreign
  # key uses different term, we can provide a field_name option
  # when defining the association, as follows:
  #
  # class User
  #   has_many :organizations, field_name: :user_id
  # end
  def has_many association_label, field_name: :user_id, class_name: ""
    define_method association_label do
      record_cls = class_name

      if record_cls.blank?
        record_cls = association_label.to_s
          .singularize
          .camelize
          .constantize
      end

      record_cls.where field_name => id
    end
  end
end
