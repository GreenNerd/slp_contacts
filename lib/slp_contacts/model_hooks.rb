module SlpContacts
  module ModelHooks
    extend ActiveSupport::Concern

    included do
      has_many :favorites, class_name: 'SlpContacts::Favorite', dependent: :destroy
      has_many :favorited_contacts, through: :favorites, source: SlpContacts.contact_class.to_s.underscore
    end

    module ClassMethods
    end

    module InstanceMethods
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
