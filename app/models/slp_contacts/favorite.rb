module SlpContacts
  class Favorite < ActiveRecord::Base
    validates :user, presence: true
    validates :contact, presence: true

    belongs_to :user
    belongs_to :contact, class_name: 'User'
  end
end
