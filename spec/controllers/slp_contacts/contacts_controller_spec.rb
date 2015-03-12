require 'rails_helper'

module SlpContacts
  RSpec.describe ContactsController, type: :controller do

    let(:user) { Fabricate(:user) }
    let(:valid_session) { { current_user_id: user.id } }

    describe "GET #index" do
      it "returns a json when format is json" do
        contact1 = Fabricate(:user, name: 'xx1')
        contact2 = Fabricate(:user, name: 'xx2')
        Favorite.create(user: user, contact: contact1)
        Favorite.create(user: user, contact: contact2)
        get :index, { format: :json }, valid_session
        json = JSON.parse(response.body)
        expect(json['contacts'][0]['name']).to eq contact1.name
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
