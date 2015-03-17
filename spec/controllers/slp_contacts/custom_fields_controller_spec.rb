require 'rails_helper'

module SlpContacts
  RSpec.describe CustomFieldsController, type: :controller do

    let(:user) { Fabricate(:user) }
    let(:valid_session) { { current_user_id: user.id } }

    before :each do
      namespace = Fabricate(:namespace)
    end

    describe "GET #new" do
      it "assigns a new CustomField to @custom_field" do
        get :new, {}, valid_session
        expect(assigns(:custom_field)).to be_a_new(CustomField)
      end
    end

    describe "POST #create" do
      it "saves the new custom_field in database" do
        expect{
          post :create, { custom_field: Fabricate.attributes_for(:custom_field) }, valid_session
        }.to change(CustomField, :count).by(1)
      end

      it "fails to save when it is invaild" do
        expect{
          post :create, { custom_field: Fabricate.attributes_for(:custom_field, name: "") }, valid_session
        }.to change(CustomField, :count).by(0)
      end
    end

  end
end
