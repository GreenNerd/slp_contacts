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

      context 'when is_required is true' do
        it 'is invaild without value' do
          custom_value = Fabricate.build(:custom_value, value: nil, custom_field: custom_field, user: user)
          custom_value.valid?
          expect(custom_value.errors[:value]).to include("can't be blank")
        end

        it 'is valid with value' do
          custom_value = Fabricate.build :custom_value, user: user, custom_field: custom_field
          expect(custom_value).to be_valid
        end
      end

      context 'when is_required is false' do
        let(:custom_field) { Fabricate :custom_field, is_required: false }
        it 'is valid without value' do
          custom_value = Fabricate.build :custom_value, user: user, custom_field: custom_field
          expect(custom_value).to be_valid
        end
      end

      context 'when is_unique is true' do
        let(:custom_value1) { Fabricate :custom_value, custom_field: custom_field, user: user }

        it 'is invaild with repeated value' do
          custom_value = Fabricate.build(:custom_value, value: custom_value1.value, custom_field: custom_field, user: user)
          custom_value.valid?
          expect(custom_value.errors[:value]).to include("has already been taken")
        end

        it 'is valid with a new value' do
          custom_value = Fabricate.build(:custom_value, custom_field: custom_field, user: user)
          expect(custom_value).to be_valid
        end
      end

      context 'when is_unique is false' do
        let(:user1) { Fabricate :user }
        let(:custom_field) { Fabricate :custom_field, is_unique: false }
        let(:custom_value1) { Fabricate :custom_value, custom_field: custom_field, user: user1 }

        it 'is valid with repeated value' do
          custom_value = Fabricate.build :custom_value, value: custom_value1.value, user: user, custom_field: custom_field
          expect(custom_value).to be_valid
        end
      end

      it 'is invaild to create value that has been created' do
        exist_custom_value = Fabricate :custom_value, custom_field: custom_field, user: user
        custom_value = Fabricate.build :custom_value, value: 'test', custom_field: custom_field, user: user
        custom_value.valid?
        expect(custom_value).to be_invalid
      end
    end
  end
end
