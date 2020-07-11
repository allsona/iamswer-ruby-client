# Equip to a User-like model to gain access to underlying
# Iamswer::User, so that the User-like model does not need to
# directly inherit Iamswer::User
module Iamswer::User::Prototype
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Validations
    include Iamswer::User::Updater

    attr_accessor :iamswer_user

    iamswer_fields :created_at, :updated_at

    def ==(other_user)
      fields == other_user.fields
    end

    def reload
      self.class.find_by_id! id
    end
  end

  class_methods do
    # these should be treated as private, should only be used
    # internally by iamswer itself
    attr_accessor :iamswer_defined_fields
    attr_accessor :iamswer_defined_extra_fields

    # not all `Iamswer::User` fields might be exposed, we can be
    # selective of what fields we want to expose from the prototype
    def iamswer_fields *fields
      @iamswer_defined_fields ||= []

      fields.each do |field|
        delegate field, to: :iamswer_user
        delegate "#{field}=", to: :iamswer_user

        if field == :created_at || field == :updated_at
          # created_at and updated_at are statistical data. they
          # are not considered as user-defined fields
          next
        else
          @iamswer_defined_fields << field
        end
      end
    end

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

    def construct_record_from iamswer_user
      user = new
      user.iamswer_user = iamswer_user
      iamswer_assign_extra_fields! user

      user
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
