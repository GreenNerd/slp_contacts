module SlpContacts
  module ModelHooks
    extend ActiveSupport::Concern

    included do
      has_many :favorites, class_name: 'SlpContacts::Favorite', dependent: :destroy
      has_many :favorited_contacts, through: :favorites, source: :contact
    end

    module ClassMethods
    end

    module InstanceMethods
      def favorite(contact)
        if (self == contact) || (favorited_contacts.include? contact)
          false
        else
          favorited_contacts << contact
          contact
        end
      end

      def unfavorite(contact)
        if favorited_contacts.include? contact
          favorited_contacts.delete contact
          contact
        else
          false
        end
      end

      def favorited?(contact)
        favorited_contacts.include? contact
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
