module Iamswer::User::Belonging
  extend ActiveSupport::Concern

  class_methods do
    def owned_by user_class, field_name: :user
      unless user_class.ancestors.include? Iamswer::User::Prototype
        raise Iamswer::Error::DslError, "#{user_class} does not implements Iamswer::User::Prototype"
      end

      field_writer = "#{field_name}="
      id_field = "#{field_name}_id"
      instance_variable = :"@#{field_name}"

      define_method field_writer do |user|
        instance_variable_set instance_variable, user
        write_attribute id_field, user.id
      end

      define_method field_name do
        instance = instance_variable_get instance_variable

        unless instance
          instance = user_class.find_by_id!(read_attribute(id_field))
          instance_variable_set instance_variable, instance
        end

        instance
      end

      validates_presence_of id_field
    end
  end
end
