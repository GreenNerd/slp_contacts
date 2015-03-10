module SlpContacts
  class Favorite < ActiveRecord::Base
    validates :user, presence: true
    validates :contact, presence: true

    belongs_to :user, class_name: SlpContacts.contact_class.to_s
    belongs_to :contact, class_name: SlpContacts.contact_class.to_s
  end
end
