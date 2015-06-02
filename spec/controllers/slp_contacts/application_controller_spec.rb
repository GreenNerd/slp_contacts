require 'rails_helper'

module SlpContacts
  RSpec.describe ApplicationController, type: :controller do
    let(:namespace) { Fabricate :namespace }
    let(:user) { Fabricate :user, namespace: namespace }
    let(:valid_session) { { current_user_id: user.id } }

    let(:not_found_text) { 'not found' }

    controller do
      include SlpContacts::SessionsHelper
      before_action :signed_in_required

      def index
        raise NotFound.new('not found')
      end

      def show
        render text: 'authorized'
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

    describe "failure_route" do
      let(:failure_route_url) { 'http://abc.com' }

      before do
        ::SessionsHelper.module_eval do
          def failure_route
            'http://abc.com'
          end
        end
      end

      it "redirect_to to the failure_route" do
        get :show, { id: :any_id }
        expect(response).to redirect_to(failure_route_url)
      end
    end
  end
end
