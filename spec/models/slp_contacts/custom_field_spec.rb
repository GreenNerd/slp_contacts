require 'rails_helper'

module SlpContacts
  RSpec.describe CustomField, type: :model do
    describe 'Associations' do
      it { should belong_to(:namespace) }
      it { should have_many(:custom_values) }
    end
  end
end
