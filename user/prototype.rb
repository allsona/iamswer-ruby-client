# Equip to a User-like model to gain access to underlying
# Zenta::User, so that the User-like model does not need to
# directly inherit Zenta::User
module Zenta::User::Prototype
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Validations
    include Zenta::User::Updater

    attr_accessor :zenta_user

    zenta_fields :created_at, :updated_at

    def ==(other_user)
      fields == other_user.fields
    end

    def reload
      self.class.find_by_id! id
    end
  end

  class_methods do
    # these should be treated as private, should only be used
    # internally by zenta itself
    attr_accessor :zenta_defined_fields
    attr_accessor :zenta_defined_extra_fields

    # not all `Zenta::User` fields might be exposed, we can be
    # selective of what fields we want to expose from the prototype
    def zenta_fields *fields
      @zenta_defined_fields ||= []

      fields.each do |field|
        delegate field, to: :zenta_user
        delegate "#{field}=", to: :zenta_user

        if field == :created_at || field == :updated_at
          # created_at and updated_at are statistical data. they
          # are not considered as user-defined fields
          next
        else
          @zenta_defined_fields << field
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
    def zenta_extra_fields *extra_fields
      @zenta_defined_extra_fields ||= []

      extra_fields.each do |extra_field|
        @zenta_defined_extra_fields << extra_field.to_sym
        define_extra_field extra_field
      end
    end

    def construct_record_from zenta_user
      user = new
      user.zenta_user = zenta_user
      zenta_assign_extra_fields! user

      user
    end

    def zenta_assign_extra_fields! user
      zenta_user = user.zenta_user
      extra_fields = zenta_user.extra_fields

      user.class.zenta_defined_extra_fields.each do |extra_field|
        camelized_field_name = extra_field.to_s.camelize(:lower)

        if extra_fields.include? camelized_field_name
          user.send "#{extra_field}=", extra_fields[camelized_field_name]
        end
      end
    end

    def find_by_id! id
      zenta_user = Zenta::User.find_by_id! id
      construct_record_from zenta_user
    end

    def find_by_email! email
      zenta_user = Zenta::User.find_by_email! email
      construct_record_from zenta_user
    end

    def find_by_username! username
      zenta_user = Zenta::User.find_by_username! username
      construct_record_from zenta_user
    end
  end
end
