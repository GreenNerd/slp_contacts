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
      result = objects.page(page).per(per_page)
      response.headers['X-SLP-Contacts-Current-Page'] = page
      response.headers['X-SLP-Total-Current-Page'] = result.num_pages
      result
    end

  end
end
