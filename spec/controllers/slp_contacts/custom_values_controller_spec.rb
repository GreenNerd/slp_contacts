require 'rails_helper'

module SlpContacts
  RSpec.describe CustomValuesController, type: :controller do
    let(:user) { Fabricate :user }
    let(:valid_session) { { current_user_id: user.id } }
    let(:custom_field) { Fabricate :custom_field, namespace: user.namespace }
    let(:custom_field1) { Fabricate :custom_field, namespace: user.namespace }

    describe 'GET #edit' do
      it 'renders the edit template' do
        get :edit, {}, valid_session
        expect(response).to render_template :edit
      end
    end

    describe 'PUT #update' do
      context 'when custom_value doesnot exist' do
        it 'adds CustomValue count by 2 when valid' do
          expect{
            put :update, { custom_field.name => 'value1', custom_field1.name => 'value2' }, valid_session
          }.to change { CustomValue.count }.by(2)
        end

        it 'doesnot add CustomValue count when one is invalid' do
          expect{
            put :update, { custom_field.name => 'value1', custom_field1.name => nil }, valid_session
          }.to change { CustomValue.count }.by(0)
        end
      end

      context 'when custom_value exists' do
        let!(:custom_value) { Fabricate :custom_value, custom_field: custom_field, user: user }
        let!(:custom_value1) { Fabricate :custom_value, custom_field: custom_field1, user: user }

        it 'changes attributes when valid' do
          put :update, { custom_field.name => 'value3', custom_field1.name => 'value4' }, valid_session
          custom_value.reload
          custom_value1.reload
          expect(custom_value.value).to eq 'value3'
          expect(custom_value1.value).to eq 'value4'
        end

        it 'doesnot change attributes when invalid' do
          put :update, { custom_field.name => 'value3', custom_field1.name => nil }, valid_session
          custom_value.reload
          custom_value1.reload
          expect(custom_value.value).to eq custom_value.value
          expect(custom_value1.value).to eq custom_value1.value
        end

        it 'returns code 422 when invalid' do
          put :update, { custom_field.name => 'value3', custom_field1.name => nil }, valid_session
          expect(response).to have_http_status 422
        end
      end
    end

  end
end
