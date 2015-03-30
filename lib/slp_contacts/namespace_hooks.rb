module SlpContacts
  module NamespaceHooks
    extend ActiveSupport::Concern

    included do
      has_many :custom_fields, class_name: 'SlpContacts::CustomField', foreign_key: :namespace_id, dependent: :destroy
    end

  end
end