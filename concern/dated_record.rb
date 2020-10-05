module Iamswer::Concern::DatedRecord
  extend ActiveSupport::Concern

  class_methods do
    # Define an accessor for the field, and an alias for that field
    # but in JavaScript-style camelized name. The value can be written
    # using a String which then later be parsed into a DateTime
    def dated_field underscored_field_name
      camelized_field_name = underscored_field_name.to_s.camelize :lower
      writer_method_name = "#{underscored_field_name}="
      field_instance_variable = :"@#{underscored_field_name}"

      class_eval do
        attr_accessor underscored_field_name
        alias_attribute camelized_field_name, underscored_field_name

        define_method writer_method_name do |value|
          if value.present?
            date_time_value = value.is_a?(DateTime) ? value : DateTime.parse(value)
            instance_variable_set field_instance_variable, date_time_value
          end
        end
      end
    end
  end

  included do
    dated_field :created_at
    dated_field :updated_at
  end

end
