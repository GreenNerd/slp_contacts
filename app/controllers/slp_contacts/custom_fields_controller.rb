require_dependency "slp_contacts/application_controller"

module SlpContacts
  class CustomFieldsController < ApplicationController
    def new
      @namespace = SlpContacts.namespace_class.first
      @custom_field = CustomField.new
    end
  end
end
