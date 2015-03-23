require_dependency "slp_contacts/application_controller"

module SlpContacts
  class CustomValuesController < ApplicationController

    def new
    end

    def create
      if CustomValue.save_collection(current_user, params)
        render text: 'success'
      else
        render text: 'failure', status: 422
      end
    end

    def edit
    end

    def update
      values_collection = []
      current_user.namespace.custom_fields.each do |field|
        if params[field.name].class == Array
          @custom_value = current_user.custom_values.find_by(custom_field: field)
          @custom_value.value = params[field.name].join(',')
        else
          @custom_value = current_user.custom_values.find_by(custom_field: field)
          @custom_value.value = params[field.name]
        end
        if @custom_value.valid?
          values_collection << @custom_value
        else
          render text: @custom_value.errors.full_messages, status: 422
          return
        end
      end
      values_collection.each do |value|
        value.save
      end
      render text: 'success'
    end

  end
end
