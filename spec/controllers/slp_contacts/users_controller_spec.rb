require 'rails_helper'

module SlpContacts
  RSpec.describe UsersController, type: :controller do
    let(:namespace) { Fabricate :namespace }
    let(:user) { Fabricate(:user, namespace: namespace) }
    let(:valid_session) { { current_user_id: user.id } }

    describe "GET #show" do
      let(:another_user) { Fabricate(:user, namespace: namespace) }

      it "redirect to root_path when the user is current_user" do
        get :show, { id: user.id }, valid_session
        expect(response).to redirect_to root_path
      end

      it "assigns the user" do
        get :show, { id: another_user.id }, valid_session
        expect(assigns(:user)).to eq another_user
      end

      it "returns 404 when the user isnt in the same namespace" do
        another_contact = Fabricate :user

        get :show, { id: another_contact.id }, valid_session
        expect(response).to have_http_status(404)
      end
    end

    describe "GET #edit" do
      let(:another_user) { Fabricate(:user, namespace: namespace) }

      it "renders a edit template" do
        get :edit, { id: user.id }, valid_session
        expect(response).to render_template :edit
      end

      it "redirects when the edited user isnot current_user" do
        get :edit, { id: another_user.id }, valid_session
        expect(response).to redirect_to root_path
      end
    end

    describe "PUT #update" do
      let(:custom_field) { Fabricate :custom_field, namespace: user.namespace }
      let(:custom_field1) { Fabricate :custom_field, namespace: user.namespace }
      let(:valid_params) { {
                              id: user.id,
                              name: 'name',
                              phone: 12345,
                              custom_field.name => 'value1',
                              custom_field1.name => 'value2'
                            } }
      let(:invalid_params) { {
                              id: user.id,
                              name: 'name',
                              phone: 12345,
                              custom_field.name => 'value1',
                              custom_field1.name => nil
                            } }

      context 'when custom_value doesnot exist' do
        it 'adds CustomValue count by 2 when valid' do
          expect{
            put :update, valid_params, valid_session
          }.to change { CustomValue.count }.by(2)
        end

        it 'doesnot add CustomValue count when one is invalid' do
          expect{
            put :update, invalid_params, valid_session
          }.to change { CustomValue.count }.by(0)
        end
      end

      context 'when custom_value exists' do
        let!(:custom_value) { Fabricate :custom_value, custom_field: custom_field, user: user }
        let!(:custom_value1) { Fabricate :custom_value, custom_field: custom_field1, user: user }

        it 'changes attributes when valid' do
          put :update, valid_params, valid_session
          custom_value.reload
          custom_value1.reload
          expect(custom_value.value).to eq 'value1'
          expect(custom_value1.value).to eq 'value2'
        end

        it 'doesnot change attributes when invalid' do
          put :update, invalid_params, valid_session
          custom_value.reload
          custom_value1.reload
          expect(custom_value.value).to eq custom_value.value
          expect(custom_value1.value).to eq custom_value1.value
        end

        it 'returns code 422 when invalid' do
          put :update, invalid_params, valid_session
          expect(response).to have_http_status 422
        end
      end
    end

    describe "POST #favorite" do
      let(:contact) { Fabricate :user, namespace: namespace }

      it "adds the contact to favorited_contacts" do
        expect{
          xhr :post, :favorite, { id: contact.id, format: :js }, valid_session
        }.to change { user.favorited_contacts.count }.by(1)
      end

      it "fails when the user favorites himself" do
        xhr :post, :favorite, { id: user.id, format: :js }, valid_session
        expect(response).to have_http_status(422)
      end

      it 'returns not_found when the contact not in the same namespace' do
        another_contact = Fabricate :user
        xhr :post, :favorite, { id: another_contact.id, format: :js }, valid_session
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
        xhr :delete, :unfavorite, { id: another_contact.id, format: :js }, valid_session
        expect(response).to have_http_status(404)
      end
    end

    describe "GET #query" do
      let(:name) { 'abcd' }
      let!(:contact) { Fabricate :user, name: name, namespace: namespace }

      it "returns contacts when user exists " do
        xhr :get, :query, { name: name, format: :json }, valid_session
        expect(assigns(:users)).to eq [contact]
      end

      it 'retuns contact belongs_to the same namespace' do
        Fabricate :user, name: name

        xhr :get, :query, { name: name, format: :json }, valid_session
        expect(assigns(:users)).to eq [contact]
      end
    end
  end
end
