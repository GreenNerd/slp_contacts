require_dependency "slp_contacts/application_controller"

module SlpContacts
  class CustomFieldsController < ApplicationController
    before_action :find_namespace
    before_action :find_custom_field, only: [:update, :destroy]

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

    def update
      @result = {}
      if @custom_field.update(custom_field_params)
        @result[:status] = 'success'
        render json: @result
      else
        @result[:status] = 'failure'
        @result[:error] = 'fail to validate'
        render json: @result, status: 422
      end
    end

    def destroy
      @custom_field.destroy
      render json: { status: "success" }
    end

    private

    def find_custom_field
      @custom_field = CustomField.find_by(id: params[:id])
      raise CustomFieldNotFound unless @custom_field
    end

    def find_namespace
      @namespace = SlpContacts.namespace_class.first
    end

    def custom_field_params
      params.require(:custom_field).permit(:name, :field_type, :is_required, :is_unique)
    end
  end
end
