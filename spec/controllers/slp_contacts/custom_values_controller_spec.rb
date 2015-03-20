require 'rails_helper'

module SlpContacts
  RSpec.describe CustomValuesController, type: :controller do
    let(:user) { Fabricate :user }
    let(:valid_session) { { current_user_id: user.id } }

    describe 'GET #new' do
      it 'render the :new template' do
        get :new, {}, valid_session
        expect(response).to render_template :new
      end
    end
  end
end
