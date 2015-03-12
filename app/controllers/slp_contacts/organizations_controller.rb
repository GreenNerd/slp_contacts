require_dependency "slp_contacts/application_controller"

module SlpContacts
  class OrganizationsController < ApplicationController
    before_action :find_organization, only: [:show, :query]
    def index
      @organizations = current_user.organizations
    end

    def show
      if params[:page]
        @members = @organization.members.where.not(id: current_user.id).page(params[:page])
      else
        @members = @organization.members.where.not(id: current_user.id).page(1)
      end
      respond_to do |f|
        f.html
        f.json { render layout: false }
      end
    end

    def query
      @result = @organization.members.where(name: params[:name])
      respond_to do |f|
        f.json { render layout: false }
      end
    end

    private

    def find_organization
      @organization = Organization.find_by(id: params[:id])
      raise OrganizationNotFound unless @organization
    end

  end
end
