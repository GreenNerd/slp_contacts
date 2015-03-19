module SlpContacts
  class CustomValue < ActiveRecord::Base
    belongs_to :user, class_name: SlpContacts.contact_class.to_s
    belongs_to :custom_field

    validates :user_id, presence: true
    validates :custom_field_id, presence: true
    validates :custom_field_id, uniqueness: { scope: :user_id }

    validate :must_be_present
    validate :must_be_unique


    def must_be_present
      if custom_field.is_required
        errors.add(:value, "custom field's value must be present") unless self.value
      end
    end

    def must_be_unique
      if custom_field.is_unique
        errors.add(:value, "custom field's value must_be_unique") if CustomValue.find_by(value: self.value)
      end
    end

  end
end
