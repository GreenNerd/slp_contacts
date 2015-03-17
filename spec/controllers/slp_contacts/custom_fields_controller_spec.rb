require 'rails_helper'

module SlpContacts
  RSpec.describe CustomFieldsController, type: :controller do

    let(:user) { Fabricate(:user) }
    let(:valid_session) { { current_user_id: user.id } }

    describe "GET #new" do
      it "assigns a new CustomField to @custom_field" do
        namespace = Fabricate(:namespace)
        get :new, {}, valid_session
        expect(assigns(:custom_field)).to be_a_new(CustomField)
      end
    end

  end
end
