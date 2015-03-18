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

    rescue_from CustomFieldNotFound do
      render json: { error: '没有找到该联系人!' }, status: 404
    end

  end
end
