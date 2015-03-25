module SlpContacts
  class CustomField < ActiveRecord::Base
    belongs_to :namespace, class_name: SlpContacts.namespace_class.to_s
    has_many :custom_values, dependent: :destroy

    enum field_type: ["input", "radio", "checkbox", "option"]

    validates :name, presence: true
    validates :name, uniqueness: true
    validates :namespace_id, presence: true

    validate :possible_values_must_be_present

    private

    def possible_values_must_be_present
      if %w(radio checkbox option).include?(field_type) && possible_values.blank?
        errors.add(:value, 'possible values must be present')
      end
    end

  end
end
