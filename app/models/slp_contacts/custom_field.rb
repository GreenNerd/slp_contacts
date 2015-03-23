module SlpContacts
  class CustomField < ActiveRecord::Base
    belongs_to :namespace, class_name: SlpContacts.namespace_class.to_s
    has_many :custom_values, dependent: :destroy

    enum field_type: ["input", "radio", "checkbox"]

    validates :name, presence: true
    validates :name, uniqueness: true
    validates :namespace_id, presence: true

  end
end
