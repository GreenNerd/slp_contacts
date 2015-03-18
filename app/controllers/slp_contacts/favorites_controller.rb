require_dependency "slp_contacts/application_controller"

module SlpContacts
  class FavoritesController < ApplicationController
    def index
      respond_to do |format|
        format.html

        format.json do
          @favorited_contacts = paginate current_user.favorited_contacts.order(:name)
          render layout: false
        end
      end
    end

    def query
      @contacts = paginate current_user.favorited_contacts.where("name LIKE ?", "%#{params[:name]}%").order(:name)
      render layout: false
    end
  end
end
