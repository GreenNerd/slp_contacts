require_dependency "slp_contacts/application_controller"

module SlpContacts
  class CustomValuesController < ApplicationController

    def new
    end

    def create
      if CustomValue.save_collection(current_user, params)
        render text: 'success'
      else
        render text: 'failure', status: 422
      end
    end

    def edit
    end

    def update
      if CustomValue.update_collection(current_user, params)
        render text: 'success'
      else
        render text: 'failure', status: 422
      end
    end

  end
end
