require_dependency "slp_contacts/application_controller"

module SlpContacts
  class UsersController < ApplicationController
    before_action :find_user
    before_action :check_user, only: [:favorite, :unfavorite]
    def show
    end

    def favorite
      Favorite.create(user_id: current_user.id, contact_id: @user.id)
      respond_to do |f|
        f.js { render layout: false }
      end
    end

    def unfavorite
      favorite = Favorite.find_by(user_id: current_user.id, contact_id: @user.id)
      if favorite
        favorite.destroy
      else
        render js: "alert('没有收藏该联系人！');"
        return
      end
      respond_to do |f|
        f.js { render layout: false }
      end
    end

    private

    def find_user
      @user = User.find_by(id: params[:id])
      raise UserNotFound unless @user
    end

    def check_user
      if current_user == @user
        render js: "alert('不能收藏自己！');"
      end
    end

  end
end
