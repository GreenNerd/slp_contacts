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

    describe "GET #organizations" do
      it "populates an array of all organizations" do
        orga1 = Fabricate(:organization)
        orga2 = Fabricate(:organization)
        UserOrganization.create(user_id: user.id, organization_id: orga1.id)
        UserOrganization.create(user_id: user.id, organization_id: orga2.id)
        get :organizations, {}, valid_session
        expect(assigns(:organizations)).to match_array([orga1,orga2])
      end
    end


  end
end
