require 'rails_helper'

module SlpContacts
  RSpec.describe 'User', type: :model do
    let(:user) { Fabricate :user }
    subject { user }

    describe 'Associations' do
      it { should have_many(:favorites) }
      it { should have_many(:favorited_contacts) }
    end

    describe 'Respond to' do
      it { should respond_to(:favorite) }
      it { should respond_to(:unfavorite) }
      it { should respond_to(:favorited?) }
    end

    describe '#favorite' do
      let(:unfavorited_contact) { Fabricate :user }

      it 'add the contact to favorited_contacts' do
        expect {
          user.favorite(unfavorited_contact)
        }.to change { user.favorited_contacts.count }.by(1)
      end

      it 'returns the contact' do
        expect(user.favorite(unfavorited_contact)).to be_a SlpContacts.contact_class
      end

      it 'returns falsey when the contact is hiself' do
        expect(user.favorite(user)).to be_falsey
      end

      it 'returns the contact when the contact is already favorited' do
        user.favorite unfavorited_contact

        expect(user.favorite(unfavorited_contact)).to eq unfavorited_contact
      end
    end

    describe '#unfavorite' do
      let(:unfavorited_contact) { Fabricate :user }
      let!(:favorited_contact) { Fabricate(:user).tap { |contact| user.favorited_contacts << contact } }

      it 'removes the contact from favorited_contacts' do
        expect {
          user.unfavorite(favorited_contact)
        }.to change { user.favorited_contacts.count }.by(-1)
      end

      it 'does nothing when the contact isnt included in favorited_contacts' do
        expect {
          user.unfavorite(unfavorited_contact)
        }.to change { user.favorited_contacts.count }.by(0)
      end

      it 'removes the favorite relation after unfavorited' do
        expect {
          user.unfavorite(unfavorited_contact)
        }.to change { Favorite.count }.by(0)
      end

      it 'retuns the contact after unfavorited' do
        expect(user.unfavorite(favorited_contact)).to eq favorited_contact
      end
    end

    describe '#favorited?' do
      let(:contact) { Fabricate :user }

      it 'returns truthy when favorited' do
        user.favorite contact
        expect(user.favorited?(contact)).to be_truthy
      end
      it 'returns falsey when favorited' do
        expect(user.favorited?(contact)).to be_falsey
      end
    end

    describe '#find_value' do
      let(:custom_value) { Fabricate :custom_value }
      it 'returns the value when field name exists' do
        expect(custom_value.user.find_value(custom_value.custom_field.name)).to eq custom_value.value
      end

      it 'returns nil when field name doesnot exist' do
        expect(user.find_value(custom_value.custom_field.name)).to be_falsey
      end
    end
  end
end
