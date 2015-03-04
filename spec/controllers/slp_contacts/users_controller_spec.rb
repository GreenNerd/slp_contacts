require 'rails_helper'

module SlpContacts
  RSpec.describe UsersController, type: :controller do
    describe "GET #show" do
      it "assigns the requested user to @user" do
        user = Fabricate(:user)
        get :show, id: user
        expect(assigns(:user)).to eq user
      end
    end

  end
end
