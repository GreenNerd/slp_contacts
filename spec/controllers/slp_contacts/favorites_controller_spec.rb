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
      it "returns a json when contact exists " do
        contact1 = Fabricate(:user, name: 'xx1')
        Favorite.create(user: user, contact: contact1)
        get :query, { name: "xx1", format: :json }, valid_session
        json = JSON.parse(response.body)
        expect(json['results'][0]['name']).to eq contact1.name
      end
    end

  end
end
