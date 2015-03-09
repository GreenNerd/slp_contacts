module SlpContacts
  module ApplicationHelper
    def favorite?(user, contact)
      Favorite.find_by(user_id: user.id, contact_id: contact.id)
    end

    def favorite_count(user)
      Favorite.where(user: user).count
    end
  end
end
