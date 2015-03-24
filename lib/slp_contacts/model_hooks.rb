module SlpContacts
  module ModelHooks
    extend ActiveSupport::Concern

    included do
      has_many :favorites, class_name: 'SlpContacts::Favorite', foreign_key: :user_id, dependent: :destroy
      has_many :favoriteds, class_name: 'SlpContacts::Favorite', foreign_key: :contact_id, dependent: :destroy
      has_many :favorited_contacts, through: :favorites, source: :contact
      has_many :custom_values, class_name: 'SlpContacts::CustomValue', foreign_key: :user_id, dependent: :destroy

      accepts_nested_attributes_for :custom_values
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

      def scoped_contacts
        namespace.users
      end

      def scoped_organizations
        namespace.organizations
      end

      def refactor_params(params)
        result = {}
        result[:name] = params[:name]
        result[:phone] = params[:phone]
        custom_values_attributes = []
        namespace.custom_fields.each do |field|
          value = params[field.name].class == Array ? params[field.name].join(',') : params[field.name]
          @custom_value = custom_values.find_by(custom_field: field)
          if @custom_value
            custom_values_attributes << { id: @custom_value.id, value: value, custom_field_id: field.id }
          else
            custom_values_attributes << { value: value, custom_field_id: field.id }
          end
        end
        result[:custom_values_attributes] = custom_values_attributes
        result
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
