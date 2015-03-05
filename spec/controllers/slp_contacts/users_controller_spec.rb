require 'rails_helper'

module SlpContacts
  RSpec.describe UsersController, type: :controller do

    let(:user) { Fabricate(:user) }
    let(:valid_session) { { current_user_id: user.id } }

    describe "GET #show" do
      it "assigns the requested user to @user" do
        get :show, { id: user.id }, valid_session
        expect(assigns(:user)).to eq user
      end
    end

    describe "GET #favorite" do
      it "slp_contacts_favorite table's count adds 1" do
        contact = Fabricate(:user, name: "xx")
        expect{
          xhr :get, :favorite, { id: contact.id, format: :js }, valid_session
          }.to change(Favorite, :count).by(1)
      end
    end

  end
end
