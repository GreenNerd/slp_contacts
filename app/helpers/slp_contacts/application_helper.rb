module SlpContacts
  module ApplicationHelper
    def favorite?(user, contact)
      Favorite.find_by(user_id: user.id, contact_id: contact.id)
    end
  end
end
