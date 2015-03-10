require 'rails_helper'

module SlpContacts
  RSpec.describe 'User', type: :model do
    subject { Fabricate :user }

    describe 'Associations' do
      it { should have_many(:favorites) }
      it { should have_many(:favorited_contacts) }
    end
  end
end
