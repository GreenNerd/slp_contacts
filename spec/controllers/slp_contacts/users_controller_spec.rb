require 'rails_helper'

module SlpContacts
  RSpec.describe UsersController, type: :controller do
    before :each do 
      @user = Fabricate(:user)
      sign_in @user
    end
    describe "GET #show" do
      it "assigns the requested user to @user" do
        get :show, id: @user
        expect(assigns(:user)).to eq @user
      end
    end

  end
end
