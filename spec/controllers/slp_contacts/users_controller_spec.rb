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

  end
end
