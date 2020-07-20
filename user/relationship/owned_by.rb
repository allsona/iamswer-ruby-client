module Iamswer::User::Relationship::OwnedBy
  def owned_by user_class, field_name: :user
    unless user_class.is_a? Class
      raise Iamswer::Error::DslError, "#{user_class} is not a Class, but a #{user_class.class}. It must be a Class!"
    end

    unless user_class.ancestors.include? Iamswer::User::Prototype
      raise Iamswer::Error::DslError, "#{user_class} does not implements Iamswer::User::Prototype"
    end

    field_writer = "#{field_name}="
    id_field = "#{field_name}_id"
    instance_variable = :"@#{field_name}"

    # the writer
    define_method field_writer do |user|
      instance_variable_set instance_variable, user
      write_attribute id_field, user&.id
    end

    # the reader
    define_method field_name do
      instance = nil
      has_id_field_data = send(id_field).present?

      # if the field is nil, then let's not send a request to retrieve the User data
      if has_id_field_data
        instance = instance_variable_get instance_variable

        unless instance
          instance = user_class.find_by_id!(read_attribute(id_field))
          instance_variable_set instance_variable, instance
        end
      end

      instance
    end

    validates_presence_of id_field
  end
end
