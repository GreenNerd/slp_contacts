require 'rails_helper'

module SlpContacts
  RSpec.describe UserController, type: :controller do
    let(:namespace) { Fabricate :namespace }
    let(:user) { Fabricate :user, namespace: namespace }
    let(:valid_session) { { current_user_id: user.id } }

    describe "GET #show" do
      it "returns http success" do
        get :show, {}, valid_session
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #organizations" do
      let!(:first_organization) { Fabricate(:organization, namespace: namespace).tap { |org| org.members << user } }
      let!(:second_organization) { Fabricate(:organization, namespace: namespace).tap { |org| org.members << user } }

      it "returns organizations that current_user belongs_to" do
        get :organizations, {}, valid_session
        expect(assigns(:organizations)).to match_array([first_organization, second_organization])
      end
    end
  end
end
