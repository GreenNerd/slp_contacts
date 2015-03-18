require_dependency "slp_contacts/application_controller"

module SlpContacts
  class UsersController < ApplicationController
    before_action :find_user, except: [:query]
    before_action :check_user, only: [:unfavorite]

    def show
      redirect_to root_path if current_user == @user
    end

    def favorite
      if current_user.favorite(@user)
        render :show, layout: false
      else
        render_json_error('不能收藏自己')
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
      @result = paginate current_user.scoped_contacts.where("name LIKE ?", "%#{params[:name]}%").order(:name)
      respond_to do |f|
        f.json { render layout: false}
      end
    end

    private

    def find_user
      if params[:id]
        @user = current_user.scoped_contacts.find_by(id: params[:id])
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
