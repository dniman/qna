require 'rails_helper'

RSpec.describe User::BountiesController, type: :controller do

  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 2, user: user) } 
    let(:bounties) { [ create(:bounty, user: user, question: questions.first),
                       create(:bounty, user: user, question: questions.last) ] }
    
    context 'when user authenticated' do
      before { sign_in(user) }
      before { get :index }
      
      it 'populates an array of bounties' do
        expect(user.bounties).to match_array(bounties)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end
    
    context "when user not authenticated" do
      before { get :index }
        
      it '302' do
        expect(response).to have_http_status(302)
      end
    end
  end
end
