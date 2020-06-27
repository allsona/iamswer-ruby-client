module Zenta::Concern::DatedRecord
  extend ActiveSupport::Concern

  included do
    attr_accessor :created_at, :updated_at

    alias_attribute :createdAt, :created_at
    alias_attribute :updatedAt, :updated_at

    def created_at=(value)
      @created_at = DateTime.parse value
    end

    def updated_at=(value)
      @updated_at = DateTime.parse value
    end
  end

end
