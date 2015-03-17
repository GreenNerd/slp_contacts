require_dependency "slp_contacts/application_controller"

module SlpContacts
  class CustomFieldsController < ApplicationController
    before_action :find_namespace

    def index
      @custom_fields = paginate CustomField.where(namespace: @namespace)
    end

    def new
      @custom_field = CustomField.new
    end

    def create
      @custom_field = CustomField.new(custom_field_params)
      @custom_field.namespace = @namespace
      if @custom_field.save
        render text: "success"
      else
        render text: "no success"
      end
    end

    private

    def find_namespace
      @namespace = SlpContacts.namespace_class.first
    end

    def custom_field_params
      params.require(:custom_field).permit(:name, :field_type, :is_required, :is_unique)
    end
  end
end
