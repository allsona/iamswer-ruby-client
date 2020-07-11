module Iamswer::User::Updater
  extend ActiveSupport::Concern

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

    def update!
      body = Iamswer::Client.post "/api/v1/users/update", fields
      self.iamswer_user = Iamswer::User.new_from_json body
    end

    def save!
      update!
    end
  end
end
