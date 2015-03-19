require 'rails_helper'

module SlpContacts
  RSpec.describe OrganizationsController, type: :controller do
    let(:namespace) { Fabricate :namespace }
    let(:organization) { Fabricate :organization, namespace: namespace }
    let(:user) { Fabricate(:user, namespace: namespace) }
    let(:name) { 'abcdefg' }
    let!(:contact) { Fabricate(:user, name: name, namespace: namespace).tap { |u| organization.members << u } }
    let(:valid_session) { { current_user_id: user.id } }

    describe "GET #show" do

      it "assigns the requested organization to @organization" do
        get :show, { id: organization.id }, valid_session
        expect(assigns(:organization)).to eq organization
      end

      it "returns members" do
        xhr :get, :show, { id: organization.id, format: :json }, valid_session
        expect(assigns(:members)).to match_array([contact])
      end
    end

    describe "GET #query" do
      it "returns the members that matches" do
        xhr :get, :query, { id: organization.id, name: name, format: :json }, valid_session
        expect(assigns(:members)).to match_array([contact])
      end

      it "returns the members belongs_to the organization" do
        Fabricate :user, name: name, namespace: namespace

        xhr :get, :query, { id: organization.id, name: name, format: :json }, valid_session
        expect(assigns(:members)).to match_array([contact])
      end
    end
  end
end
