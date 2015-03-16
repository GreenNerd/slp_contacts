require 'rails_helper'

module SlpContacts
  RSpec.describe UserController, type: :controller do

    let(:user) { Fabricate(:user) }
    let(:valid_session) { { current_user_id: user.id } }

    describe "GET #show" do
      it "returns http success" do
        get :show, {}, valid_session
        expect(response).to have_http_status(:success)
      end
    end

  end
end
