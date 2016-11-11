module SlpContacts
  class Favorite < ::ApplicationRecord
    validates :user, presence: true
    validates :contact, presence: true, uniqueness: { scope: [:user] }

    belongs_to :user, class_name: SlpContacts.contact_class.to_s, inverse_of: :favorites
    belongs_to :contact, class_name: SlpContacts.contact_class.to_s, inverse_of: :favoriteds
  end
end
