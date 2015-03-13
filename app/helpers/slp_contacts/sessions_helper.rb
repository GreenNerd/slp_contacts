module SlpContacts
  module SessionsHelper
    def signed_in_required
      unless signed_in?
        store_location

        redirect_to main_app.login_path
      end
    end

    def paginate(objects)
      page = params[:page] || 1
      per_page = params[:per_page] || Kaminari.config.default_per_page
      objects.page(page).per(per_page)
    end

  end
end
