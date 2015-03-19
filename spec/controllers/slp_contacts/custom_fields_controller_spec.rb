require 'rails_helper'

module SlpContacts
  RSpec.describe CustomFieldsController, type: :controller do

    let(:namespace) { Fabricate(:namespace) }
    let(:user) { Fabricate(:user, namespace: namespace) }
    let(:valid_session) { { current_user_id: user.id } }
    let!(:custom_field) { Fabricate(:custom_field, namespace: namespace) }
    let!(:custom_field1) { Fabricate(:custom_field, namespace: namespace) }

    describe "GET #new" do
      it "assigns a new CustomField to @custom_field" do
        get :new, {}, valid_session
        expect(assigns(:custom_field)).to be_a_new(CustomField)
      end
    end

    describe "POST #create" do
      it "saves the new custom_field in database" do
        expect{
          post :create, { custom_field: Fabricate.attributes_for(:custom_field, namespace: namespace) }, valid_session
        }.to change(CustomField, :count).by(1)
      end

      it "fails to save when it is invaild" do
        expect{
          post :create, { custom_field: Fabricate.attributes_for(:custom_field, name: "", namespace: namespace) }, valid_session
        }.to change(CustomField, :count).by(0)
      end
    end

    describe "GET #index" do
      it "assigns the request custom_fields to @custom_fields" do
        get :index, {}, valid_session
        expect(assigns(:custom_fields)).to match_array([custom_field, custom_field1])
      end
    end

    describe "PUT #update" do
      it "returns code 200 when succeeding" do
        put :update, { id: custom_field, custom_field: Fabricate.attributes_for(:custom_field) }, valid_session
        expect(response).to have_http_status(200)
      end

      it "returns code 422 when failing to validate" do
        put :update, { id: custom_field, custom_field: Fabricate.attributes_for(:custom_field, name: "") }, valid_session
        expect(response).to have_http_status(422)
      end
    end

    describe "DELETE #destroy" do
      it "returns code 200 and a json" do
        delete :destroy, { id: custom_field }, valid_session
        expect(response).to have_http_status(200)
      end

      it "returns code 404 when id isnot found" do
        delete :destroy, { id: -1 }, valid_session
        expect(response).to have_http_status(404)
      end
    end

  end
end
