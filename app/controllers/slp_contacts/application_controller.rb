require_dependency "slp_contacts/exception"

module SlpContacts
  class ApplicationController < ::ApplicationController
    include SlpContacts::SessionsHelper

    before_action :signed_in_required

    rescue_from NotFound do |ex|
      respond_to do |format|
        format.html { render html: ex.message, status: :not_found }
        format.js { render plain: ex.message, status: :not_found }
        format.json { render json: MultiJson.dump(errors: ex.message), status: :not_found }
      end
    end

    def render_json_error(obj = nil)
      if obj.present?
        if obj.respond_to? :errors
          render json: obj.errors, status: :unprocessable_entity
        else
          render json: MultiJson.dump(errors: obj.to_s), status: :unprocessable_entity
        end
      else
        render json: MultiJson.dump(errors: ['参数错误']), status: :unprocessable_entity
      end
    end
  end
end
