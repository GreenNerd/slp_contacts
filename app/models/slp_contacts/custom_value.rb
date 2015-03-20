module SlpContacts
  class CustomValue < ActiveRecord::Base
    belongs_to :user, class_name: SlpContacts.contact_class.to_s
    belongs_to :custom_field

    validates :user_id, presence: true
    validates :custom_field_id, presence: true
    validates :custom_field_id, uniqueness: { scope: :user_id }

    validates :value, presence: true, if: 'custom_field.is_required'
    validates :value, uniqueness: true, if: 'custom_field.is_unique'

  end
end
