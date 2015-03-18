require 'rails_helper'

module SlpContacts
  RSpec.describe 'Namespace', type: :model do
    let(:namespace) { Fabricate :namespace }
    subject { namespace }

    describe 'Associations' do
      it { should have_many(:custom_fields) }
    end

  end
end