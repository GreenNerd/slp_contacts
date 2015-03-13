require_dependency "slp_contacts/application_controller"

module SlpContacts
  class ContactsController < ApplicationController
    def index
      if params[:page]
        @contacts = current_user.favorited_contacts.order(:name).page(params[:page])
      else
        @contacts = current_user.favorited_contacts.order(:name).page(1)
      end
      respond_to do |f|
        f.html
        f.json { render layout: false }
      end
    end

    def query
      @result = current_user.favorited_contacts.where("name LIKE ?", "%#{params[:name]}%").order(:name)
      respond_to do |f|
        f.json { render layout: false}
      end
    end

  end
end
