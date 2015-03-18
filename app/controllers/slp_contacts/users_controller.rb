require_dependency "slp_contacts/application_controller"

module SlpContacts
  class UsersController < ApplicationController
    before_action :find_user, except: [:query]

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
      if current_user.unfavorite(@user)
        render :show, layout: false
      else
        render_json_error
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
  end
end
