module SlpContacts
  class CustomField < ActiveRecord::Base
    belongs_to :namespace, class_name: SlpContacts.namespace_class.to_s
    has_many :custom_values

    enum field_type: ["输入框", "单选框", "复选框"]

    validates :name, presence: true
    validates :name, uniqueness: true
  end
end
