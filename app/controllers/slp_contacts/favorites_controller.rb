require_dependency "slp_contacts/application_controller"

module SlpContacts
  class FavoritesController < ApplicationController
    def index
      @contacts = paginate current_user.favorited_contacts.order(:name)
      respond_to do |f|
        f.html
        f.json { render layout: false }
      end
    end

    def query
      @result = paginate current_user.favorited_contacts.where("name LIKE ?", "%#{params[:name]}%").order(:name)
      respond_to do |f|
        f.json { render layout: false}
      end
    end

  end
end
