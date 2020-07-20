module Iamswer::User::Prototype::ExtraFields
  extend ActiveSupport::Concern

  class_methods do
    # should not be used by the user, please define extra fields
    # using iamswer_extra_fields instead
    def define_extra_field field
      instance_var = "@#{field}"

      define_method field do
        instance_variable_get instance_var
      end

      define_method "#{field}=" do |val|
        instance_variable_set instance_var, val
      end
    end

    # define additional fields that is unique per-app
    def iamswer_extra_fields *extra_fields
      @iamswer_defined_extra_fields ||= []

      extra_fields.each do |extra_field|
        @iamswer_defined_extra_fields << extra_field.to_sym
        define_extra_field extra_field
      end
    end

    def iamswer_assign_extra_fields! user
      iamswer_user = user.iamswer_user
      extra_fields = iamswer_user.extra_fields

      user.class.iamswer_defined_extra_fields.each do |extra_field|
        camelized_field_name = extra_field.to_s.camelize(:lower)

        if extra_fields.include? camelized_field_name
          user.send "#{extra_field}=", extra_fields[camelized_field_name]
        end
      end
    end
  end
end
