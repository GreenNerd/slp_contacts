require_dependency "slp_contacts/application_controller"

module SlpContacts
  class UsersController < ApplicationController
    def show
      @user = User.find(params[:id])
    end

    def favorite
      @user = User.find(params[:id])
      redirect_to user_path(current_user) unless current_user != @user
      Favorite.create(user_id: current_user.id, contact_id: @user.id)
      respond_to do |f|
        f.js { render layout: false }
      end
    end

    def unfavorite
      @user = User.find(params[:id])
      redirect_to user_path(current_user) unless current_user != @user
      Favorite.find_by(user_id: current_user.id, contact_id: @user.id).destroy
      respond_to do |f|
        f.js { render layout: false }
      end
    end

  end
end
