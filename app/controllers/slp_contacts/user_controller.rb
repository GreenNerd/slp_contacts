require_dependency "slp_contacts/application_controller"

module SlpContacts
  class UserController < ApplicationController
    def show
    end

    def organizations
      @organizations = current_user.organizations.order(:name)
    end

    def update
      current_user.update update_params
      head :no_content
    end

    private

    def update_params
      params.permit(:contact_public)
    end
  end
end
