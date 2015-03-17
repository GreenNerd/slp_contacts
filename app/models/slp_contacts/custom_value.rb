module SlpContacts
  class CustomValue < ActiveRecord::Base
    belongs_to :user, class_name: SlpContacts.contact_class.to_s
    belongs_to :custom_field

    enum field_type: ["input", "radio", "check_box"]
  end
end
