module SlpContacts
  class CustomValue < ActiveRecord::Base
    belongs_to :user, class_name: SlpContacts.contact_class.to_s
    belongs_to :custom_field

    validates :user_id, presence: true
    validates :custom_field_id, presence: true
    validates :custom_field_id, uniqueness: { scope: :user_id }

    validates :value, presence: true, if: 'custom_field.is_required'
    validates :value, uniqueness: { scope: :custom_field_id }, if: 'custom_field.is_unique'
    validates :value, format: { with: /(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)/, :multiline => true }, if: 'custom_field.date?'

    validate :must_be_in_possible_values

    private

    def must_be_in_possible_values
      if %w(radio option).include? custom_field.field_type
        errors.add(:value, 'must be in possible values') unless custom_field.possible_values.split(',').include?(self.value)
      end
      if %w(checkbox).include? custom_field.field_type
        errors.add(:value, 'must be in possible values') unless (custom_field.possible_values.split(',') & value.split(',')) == value.split(',')
      end
    end
  end
end
