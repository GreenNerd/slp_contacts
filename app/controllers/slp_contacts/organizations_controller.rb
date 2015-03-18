require_dependency "slp_contacts/application_controller"

module SlpContacts
  class OrganizationsController < ApplicationController
    before_action :find_organization, only: [:show, :query]

    def show
      respond_to do |format|
        format.html

        format.json do
          @members = paginate @organization.members.where.not(id: current_user.id).order(:name)
          render layout: false
        end
      end
    end

    def query
      @members = paginate @organization.members.where("name LIKE ?", "%#{params[:name]}%").order(:name)
      render layout: false
    end

    private

    def find_organization
      @organization = current_user.scoped_organizations.find_by(id: params[:id])
      raise OrganizationNotFound unless @organization
    end

  end
end
