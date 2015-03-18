require_dependency "slp_contacts/application_controller"

module SlpContacts
  class UsersController < ApplicationController
    before_action :find_user, except: [:query]

    def show
      redirect_to root_path if current_user == @user
    end

    def favorite
      if current_user.favorite(@user)
        render layout: false
      else
        render_json_error('不能收藏自己')
      end
    end

    def unfavorite
      if current_user.unfavorite(@user)
        render layout: false
      else
        render_json_error
      end
    end

    def query
      @users = paginate current_user.scoped_contacts.where("name LIKE ?", "%#{params[:name]}%").order(:name)
      render layout: false
    end

    private

    def find_user
      @user = current_user.scoped_contacts.find_by(id: params[:id])
      raise UserNotFound unless @user
    end
  end
end
