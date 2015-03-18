require 'rails_helper'

module SlpContacts
  RSpec.describe FavoritesController, type: :controller do
    let(:namespace) { Fabricate :namespace }
    let(:user) { Fabricate :user, namespace: namespace }
    let(:valid_session) { { current_user_id: user.id } }

    describe "GET #index" do
      let!(:contacts) do
        [
          Fabricate(:user, namespace: namespace).tap { |contact| user.favorite contact },
          Fabricate(:user, namespace: namespace).tap { |contact| user.favorite contact },
          Fabricate(:user, namespace: namespace).tap { |contact| user.favorite contact }
        ]
      end

      it "returns favorited_contacts" do
        get :index, { format: :json }, valid_session
        expect(assigns(:favorited_contacts)).to match_array(contacts)
      end
    end

    describe "GET #query" do
      let(:name) { 'abcdefg' }
      let(:favorited_contact) { Fabricate(:user, name: name, namespace: namespace).tap { |contact| user.favorite contact } }
      let!(:contacts) do
        [
          favorited_contact,
          Fabricate(:user, namespace: namespace).tap { |contact| user.favorite contact },
          Fabricate(:user, namespace: namespace).tap { |contact| user.favorite contact }
        ]
      end

      it "returns the contact that matches " do
        get :query, { name: name, format: :json }, valid_session
        expect(assigns(:contacts)).to match_array [favorited_contact]
      end
    end

  end
end
