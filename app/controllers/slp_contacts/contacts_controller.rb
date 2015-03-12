require_dependency "slp_contacts/application_controller"

module SlpContacts
  class ContactsController < ApplicationController
    def index
      if params[:page]
        @contacts = User.find(Favorite.where(user: current_user).page(params[:page]).pluck(:contact_id))
      else
        @contacts = User.find(Favorite.where(user: current_user).page(1).pluck(:contact_id))        
      end
      respond_to do |f|
        f.html
        f.json { render layout: false }
      end
    end

    def query
      @contacts = User.find(Favorite.where(user: current_user).pluck(:contact_id))      
      @result = @contacts.select { |contact| contact.name == params[:name] }
      respond_to do |f|
        f.json { render layout: false}
      end
    end

  end
end
