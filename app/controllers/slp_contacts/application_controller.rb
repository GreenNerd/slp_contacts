require_dependency "slp_contacts/exception"

module SlpContacts
  class ApplicationController < ::ApplicationController
    include SlpContacts::SessionsHelper

    before_action :signed_in_required

    rescue_from UserNotFound do
      render js: "alert('没有找到该联系人!');", status: 404
    end

    rescue_from OrganizationNotFound do
      render js: "alert('没有找到该组织!');", status: 404
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
