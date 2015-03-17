module SlpContacts
  module ModelHooks
    extend ActiveSupport::Concern

    included do
      has_many :favorites, class_name: 'SlpContacts::Favorite', foreign_key: :user_id, dependent: :destroy
      has_many :favoriteds, class_name: 'SlpContacts::Favorite', foreign_key: :contact_id, dependent: :destroy
      has_many :favorited_contacts, through: :favorites, source: :contact
    end

    module ClassMethods
    end

    module InstanceMethods
      def favorite(contact)
        if self == contact
          false
        else
          favorited_contacts << contact unless favorited_contacts.include?(contact)
          contact
        end
      end

      def unfavorite(contact)
        if favorited_contacts.delete contact
          contact
        else
          false
        end
      end

      def favorited?(contact)
        favorited_contacts.include? contact
      end

      def scoped_contacts
        namespace.users
      end
      def scoped_organizations
        namespace.organizations
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
