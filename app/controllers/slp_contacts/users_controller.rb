require_dependency "slp_contacts/application_controller"

module SlpContacts
  class UsersController < ApplicationController
    before_action :find_user, except: [:query]

    def show
      redirect_to root_path if current_user == @user
    end

    def favorite
      respond_to do |format|
        if current_user.favorite(@user)
          format.json { render :show, layout: false  }
          format.js { render layout: false  }
        else
          format.json { render_json_error('不能收藏自己') }
          format.js { render js: "alert('不能收藏自己');", status: 422 }
        end
      end
    end

    def unfavorite
      respond_to do |format|
        if current_user.unfavorite(@user)
          format.json { render :show, layout: false  }
          format.js { render layout: false  }
        else
          format.json { render_json_error }
          format.js { render js: "alert('取消失败');", status: 422 }
        end
      end
    end

    def query
      @users = paginate current_user.scoped_contacts.where("name LIKE ?", "%#{params[:name]}%").order(:name)
      render layout: false
    end

    private

    def find_user
      @user = current_user.scoped_contacts.find_by(id: params[:id])
      raise NotFound.new('用户不存在') unless @user
    end
  end
end
