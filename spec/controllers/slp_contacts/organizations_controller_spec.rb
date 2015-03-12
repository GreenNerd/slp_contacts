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

    describe "GET #query" do
      render_views
      it "returns a json when user exists " do
        contact1 = Fabricate(:user, name: 'xx1')
        orga1 = Fabricate(:organization)
        UserOrganization.create(user_id: contact1.id, organization_id: orga1.id)
        get :query, { id: orga1.id, name: "xx1", format: :json }, valid_session
        json = JSON.parse(response.body)
        expect(json['results'][0]['name']).to eq contact1.name
      end
    end

  end
end
