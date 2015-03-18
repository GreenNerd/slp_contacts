require 'rails_helper'

module SlpContacts
  RSpec.describe UsersController, type: :controller do
    let(:namespace) { Fabricate :namespace }
    let(:user) { Fabricate(:user, namespace: namespace) }
    let(:valid_session) { { current_user_id: user.id } }

    describe "GET #show" do
      let(:another_user) { Fabricate(:user, namespace: namespace) }

      it "when current_user equals @user" do
        get :show, { id: user.id }, valid_session
        expect(response).to redirect_to root_path
      end
      it "when current_user doesnot equal @user" do
        get :show, { id: another_user.id }, valid_session
        expect(assigns(:user)).to eq another_user
      end
    end

    describe "POST #favorite" do
      let(:contact) { Fabricate :user, namespace: namespace }

      it "adds the contact to favorited_contacts" do
        expect{
          xhr :post, :favorite, { id: contact.id, format: :json }, valid_session
        }.to change { user.favorited_contacts.count }.by(1)
      end

      it "fails when the user favorites himself" do
        xhr :post, :favorite, { id: user.id, format: :json }, valid_session
        expect(response).to have_http_status(422)
      end

      it 'returns not_found when the contact not in the same namespace' do
        another_contact = Fabricate :user
        xhr :post, :favorite, { id: another_contact.id, format: :json }, valid_session
        expect(response).to have_http_status(404)
      end
    end

    describe "DELETE #unfavorite" do
      let!(:contact) { Fabricate(:user, namespace: namespace).tap { |u| user.favorited_contacts << u } }

      it "removes the contact from favorited_contacts" do
        expect{
          xhr :delete, :unfavorite, { id: contact.id, format: :js }, valid_session
        }.to change { user.favorited_contacts.count }.by(-1)
      end

      it "does nothing when the user unfavorites himself" do
        expect {
          xhr :delete, :unfavorite, { id: user.id, format: :js }, valid_session
        }.not_to change { user.favorited_contacts.count }
      end

      it "does nothing when the user unfavorites a unfavorited contact" do
        unfavorited_contact = Fabricate :user, namespace: namespace

        expect {
          xhr :delete, :unfavorite, { id: unfavorited_contact.id, format: :js }, valid_session
        }.not_to change { user.favorited_contacts.count }
      end

      it 'returns not_found when the contact not in the same namespace' do
        another_contact = Fabricate :user
        xhr :delete, :unfavorite, { id: another_contact.id, format: :json }, valid_session
        expect(response).to have_http_status(404)
      end
    end

    describe "GET #query" do
      let!(:contact) { Fabricate :user, name: 'xx1', namespace: namespace }

      it "returns a json when user exists " do
        xhr :get, :query, { name: "xx1", format: :json }, valid_session
        json = JSON.parse(response.body)
        expect(json['results'][0]['name']).to eq contact.name
      end
    end
  end
end
