require 'rails_helper'

module SlpContacts
  RSpec.describe CustomValue, type: :model do
    describe 'Associations' do
      it { should belong_to(:user) }
      it { should belong_to(:custom_field) }
    end

    describe 'Validation' do
      let(:user) { Fabricate :user }
      let(:custom_field) { Fabricate :custom_field }
      let!(:custom_value1) { custom_value1 = Fabricate :custom_value, custom_field: custom_field, user: user }

      context 'when is_required is true' do
        it 'is invaild without value' do
          custom_value = Fabricate.build(:custom_value, value: nil, custom_field: custom_field, user: user)
          custom_value.valid?
          expect(custom_value.errors[:value]).to include("can't be blank")
        end
      end

      context 'when is_unique is true' do
        it 'is invaild with repeated value' do
          custom_value = Fabricate.build(:custom_value, value: custom_value1.value, custom_field: custom_field, user: user)
          custom_value.valid?
          expect(custom_value.errors[:value]).to include("has already been taken")
        end
      end

      it 'is invaild to create value that has been created' do
        custom_value = Fabricate.build :custom_value, value: 'test', custom_field: custom_field, user: user
        custom_value.valid?
        expect(custom_value).to be_invalid
      end
    end
  end
end
