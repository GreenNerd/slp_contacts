require 'rails_helper'

module SlpContacts
  RSpec.describe ApplicationController, type: :controller do
    let(:namespace) { Fabricate :namespace }
    let(:user) { Fabricate :user, namespace: namespace }
    let(:valid_session) { { current_user_id: user.id } }

    let(:not_found_text) { 'not found' }

    controller do
      def index
        raise NotFound.new('not found')
      end
    end

    describe "handling NotFound exceptions" do
      it "returns 404" do
        get :index, {}, valid_session
        expect(response).to have_http_status(404)
      end

      it 'contains the not_found_text' do
        get :index, {}, valid_session
        expect(response.body).to include(not_found_text)
      end
    end
  end
end
