require_dependency "slp_contacts/application_controller"

module SlpContacts
  class OrganizationsController < ApplicationController
    def index
      @organizations = current_user.organizations
    end

    def show
      @organization = Organization.find(params[:id])
      @members = @organization.members.page(params[:page]).per(8)
      respond_to do |f|
        f.html
        f.js { render layout: false }
      end
    end

  end
end
