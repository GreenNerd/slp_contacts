require 'rails_helper'

module SlpContacts
  RSpec.describe Favorite, type: :model do
    subject { Fabricate :favorite }
    it { should be_valid }

    describe 'Associations' do
      it { should belong_to(:user) }
      it { should belong_to(:contact) }
    end

    describe 'Validations' do
      let(:favorite) { Fabricate :favorite }

      it 'requires user' do
        favorite.user_id = nil
        expect(favorite).to have(1).error_on(:user)
      end
      it 'requires contact' do
        favorite.contact_id = nil
        expect(favorite).to have(1).error_on(:contact)
      end
    end
  end
end
