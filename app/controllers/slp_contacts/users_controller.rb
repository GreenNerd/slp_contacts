require_dependency "slp_contacts/application_controller"

module SlpContacts
  class UsersController < ApplicationController
    def show
      @user = User.find(params[:id])
    end
  end
end
