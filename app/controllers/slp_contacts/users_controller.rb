require_dependency "slp_contacts/application_controller"

module SlpContacts
  class UsersController < ApplicationController
    before_action :find_user, except: [:query]
    before_action :check_user, only: [:favorite, :unfavorite]
    def show
    end

    def favorite
      current_user.favorite(@user)
      respond_to do |f|
        f.js { render layout: false }
      end
    end

    def unfavorite
      unless current_user.unfavorite(@user)
        render js: "alert('没有收藏该联系人！');"
        return
      end
      respond_to do |f|
        f.js { render layout: false }
      end
    end

    def query
      @result = SlpContacts.contact_class.where("name LIKE ?", "%#{params[:name]}%")
      respond_to do |f|
        f.json { render layout: false}
      end
    end

    private

    def find_user
      if params[:id]
        @user = SlpContacts.contact_class.find_by(id: params[:id])
        raise UserNotFound unless @user
      else
        @user = current_user
      end
    end

    def check_user
      if current_user == @user
        render js: "alert('不能收藏自己！');", status: 403
      end
    end

  end
end
