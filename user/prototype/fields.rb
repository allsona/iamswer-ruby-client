# Module to help define fields on
module Iamswer::User::Prototype::Fields
  extend ActiveSupport::Concern

  class_methods do
    # these should be treated as private, should only be used
    # internally by iamswer itself
    attr_accessor :iamswer_defined_fields
    attr_accessor :iamswer_defined_extra_fields

    # selective what fields are exposed
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
  end

  included do
    # fields attributes understood by API requests
    # especially for updating data
    def fields
      fields = self.class.iamswer_defined_fields

      if fields.blank?
        fields = [
          :email,
          :first_name,
          :last_name,
          :name,
          :roles,
          :username,
          :extra_fields,
        ]
      end

      fields = fields
        .map { |field| [field, send(field)] }
        .to_h

      if self.class.iamswer_defined_extra_fields.any?
        fields[:extra_fields] = {}
        self.class.iamswer_defined_extra_fields.each do |field|
          fields[:extra_fields][field] = send(field)
        end
      end

      fields
    end
  end
end
