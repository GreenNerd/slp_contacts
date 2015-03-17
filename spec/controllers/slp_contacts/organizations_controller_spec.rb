require 'rails_helper'

module SlpContacts
  RSpec.describe OrganizationsController, type: :controller do
    let(:namespace) { Fabricate :namespace }
    let(:organization) { Fabricate :organization, namespace: namespace }
    let(:user) { Fabricate(:user, namespace: namespace) }
    let!(:contact) { Fabricate(:user, name: 'xx1', namespace: namespace).tap { |u| organization.members << u } }
    let(:valid_session) { { current_user_id: user.id } }

    describe "GET #show" do

      it "assigns the requested organization to @organization" do
        get :show, { id: organization }, valid_session
        expect(assigns(:organization)).to eq organization
      end

      it "returns a json when format is json" do
        xhr :get, :show, { id: organization, format: :json }, valid_session
        parsed_body = JSON.parse(response.body)
        expect(parsed_body[0]['name']).to eq contact.name
      end
    end

    describe "GET #query" do
      it "returns a json when user exists " do
        xhr :get, :query, { id: organization.id, name: "xx1", format: :json }, valid_session
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['results'][0]['name']).to eq contact.name
      end
    end

  end
end
