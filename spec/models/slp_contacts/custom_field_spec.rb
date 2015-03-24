require 'rails_helper'

module SlpContacts
  RSpec.describe CustomField, type: :model do
    describe 'Associations' do
      it { should belong_to(:namespace) }
      it { should have_many(:custom_values) }
    end

    describe 'Validations' do
      let(:namespace) { Fabricate :namespace }

      context 'when field_type is radio' do
        it 'is valid with possible_values' do
          custom_field = Fabricate.build :custom_field, field_type: 'radio', namespace: namespace
          expect(custom_field).to be_valid
        end

        it 'is invalid without possible_values' do
          custom_field = Fabricate.build :custom_field, field_type: 'radio', possible_values: nil, namespace: namespace
          custom_field.valid?
          p custom_field.errors
          expect(custom_field).to have(1).error_on(:value)
        end

        it 'is invalid when possible_values is empty string' do
          custom_field = Fabricate.build :custom_field, field_type: 'radio', possible_values: '  ', namespace: namespace
          expect(custom_field).to have(1).error_on(:value)
        end
      end

      context 'when field_type is checkbox' do
        it 'is valid with possible_values' do
          custom_field = Fabricate.build :custom_field, field_type: 'checkbox', namespace: namespace
          expect(custom_field).to be_valid
        end

        it 'is invalid without possible_values' do
          custom_field = Fabricate.build :custom_field, field_type: 'checkbox', possible_values: nil, namespace: namespace
          expect(custom_field).to have(1).error_on(:value)
        end

        it 'is invalid when possible_values is empty string' do
          custom_field = Fabricate.build :custom_field, field_type: 'checkbox', possible_values: '  ', namespace: namespace
          expect(custom_field).to have(1).error_on(:value)
        end
      end
    end
  end
end
