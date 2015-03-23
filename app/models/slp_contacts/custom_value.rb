module SlpContacts
  class CustomValue < ActiveRecord::Base
    belongs_to :user, class_name: SlpContacts.contact_class.to_s
    belongs_to :custom_field

    validates :user_id, presence: true
    validates :custom_field_id, presence: true
    validates :custom_field_id, uniqueness: { scope: :user_id }

    validates :value, presence: true, if: 'custom_field.is_required'
    validates :value, uniqueness: { scope: :custom_field_id }, if: 'custom_field.is_unique'

    def self.check_validation(user, params)
      values_collection = []
      user.namespace.custom_fields.each do |field|
        value = params[field.name].class == Array ? params[field.name].join(',') : params[field.name]
        @custom_value = user.custom_values.find_by(custom_field: field) || user.custom_values.new(custom_field: field)
        @custom_value.value = value
        if @custom_value.valid?
          values_collection << @custom_value
        else
          return false
        end
      end
      values_collection
    end
  end
end
