module SlpContacts
  module SessionsHelper
    def signed_in_required
      unless signed_in?
        store_location

        redirect_to main_app.login_path
      end
    end
  end
end
