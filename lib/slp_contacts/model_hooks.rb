module SlpContacts
  module ModelHooks
    extend ActiveSupport::Concern

    included do
      has_many :favorites, class_name: 'SlpContacts::Favorite', foreign_key: :user_id, dependent: :destroy
      has_many :favoriteds, class_name: 'SlpContacts::Favorite', foreign_key: :contact_id, dependent: :destroy
      has_many :favorited_contacts, through: :favorites, source: :contact
      has_many :custom_values, class_name: 'SlpContacts::CustomValue', foreign_key: :user_id, dependent: :destroy
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

      def find_value(field_name)
        custom_field = SlpContacts::CustomField.find_by(name: field_name)
        custom_values.find_by(custom_field_id: custom_field).try(:value)
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
