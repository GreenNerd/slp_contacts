require_dependency "slp_contacts/application_controller"

module SlpContacts
  class UserController < ApplicationController
    def show
    end

    def organizations
      @organizations = current_user.organizations.order(:name)
    end
  end
end
