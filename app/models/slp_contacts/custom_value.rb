module SlpContacts
  class CustomValue < ActiveRecord::Base
    belongs_to :user, class_name: SlpContacts.contact_class.to_s
    belongs_to :custom_field

    validates :user_id, presence: true
    validates :custom_field_id, presence: true
    validates :custom_field_id, uniqueness: { scope: :user_id }

    validates :value, presence: true, if: 'custom_field.is_required'
    validates :value, uniqueness: { scope: :custom_field_id }, if: 'custom_field.is_unique'

    validate :must_be_in_possible_values

    def must_be_in_possible_values
      if %w(radio checkbox).include? custom_field.field_type
        errors.add(:value, 'must be in possible values') unless custom_field.possible_values.split(',').include?(self.value)
      end
    end
  end
end
