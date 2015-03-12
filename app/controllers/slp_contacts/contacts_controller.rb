require_dependency "slp_contacts/application_controller"

module SlpContacts
  class ContactsController < ApplicationController
    def index
      if params[:page]
        @contacts = current_user.favorited_contacts.page(params[:page])
      else
        @contacts = current_user.favorited_contacts.page(1)
      end
      respond_to do |f|
        f.html
        f.json { render layout: false }
      end
    end

    def query
      @result = current_user.favorited_contacts.where(name: params[:name])      
      respond_to do |f|
        f.json { render layout: false}
      end
    end

  end
end
