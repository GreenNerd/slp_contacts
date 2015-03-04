require 'rails_helper'

module SlpContacts
  RSpec.describe OrganizationsController, type: :controller do

    let(:user) { Fabricate(:user) }
    let(:valid_session) { { current_user_id: user.id } }

    describe "GET #index" do
      it "populates an array of all organizations" do
        orga1 = Fabricate(:organization)
        orga2 = Fabricate(:organization)
        UserOrganization.create(user_id: user.id, organization_id: orga1.id)
        UserOrganization.create(user_id: user.id, organization_id: orga2.id)
        get :index, {}, valid_session
        expect(assigns(:organizations)).to match_array([orga1,orga2])
      end
    end

    describe "GET #show" do
      it "assigns the requested organization to @organization" do
        organization = Fabricate(:organization)
        get :show, { id: organization }, valid_session
        expect(assigns(:organization)).to eq organization
      end
    end

  end
end
