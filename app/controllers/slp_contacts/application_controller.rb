module SlpContacts
  class ApplicationController < ::ApplicationController
    include SlpContacts::SessionsHelper

    before_action :signed_in_required
  end
end
