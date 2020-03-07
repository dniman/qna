RSpec.shared_examples 'voted' do 
 
  describe 'PATCH #vote_yes' do
    let!(:user) { create(:user) }
    let!(:subject) { create(controller.controller_name.classify.downcase.to_sym) }

    context 'when user is authenticated' do
      context 'and user is author' do
        before { login(subject.user) }

        it 'does not save the vote yes' do
          expect { patch :vote_yes, params: { id: subject }, format: :json }.to_not change(Vote, :count)
        end
        
        it 'renders empty json' do
          patch :vote_yes, params: { id: subject }, format: :json
          expect(response).to be_successful
        end
      end

      context 'and user is not an author' do
        before { login(user) }
        
        it 'saves the vote yes' do
          expect { patch :vote_yes, params: { id: subject }, format: :json }.to change(Vote, :count).by(1)
        end

        it 'renders json' do
          patch :vote_yes, params: { id: subject }, format: :json
          expect(response.body).to eq({ "rating": subject.rating }.to_json)
        end

      end
    end

    context 'when user is not authenticated' do
      it '401' do
        patch :vote_yes, params: { id: subject }, format: :json
        expect(response).to have_http_status(401)
      end
      
      it 'not saves the vote yes' do
        expect { patch :vote_yes, params: { id: subject }, format: :json }.to_not change(Vote, :count)
      end
    end
  end

  describe 'PATCH #vote_no' do
    let!(:user) { create(:user) }
    let!(:subject) { create(controller.controller_name.classify.downcase.to_sym) }

    context 'when user is authenticated' do
      context 'and user is author' do
        before { login(subject.user) }

        it 'does not save the vote no' do
          expect { patch :vote_no, params: { id: subject }, format: :json }.to_not change(Vote, :count)
        end
        
        it 'renders empty json' do
          patch :vote_no, params: { id: subject }, format: :json
          expect(response).to be_successful
        end
      end

      context 'and user is not an author' do
        before { login(user) }
        
        it 'saves the vote no' do
          expect { patch :vote_no, params: { id: subject }, format: :json }.to change(Vote, :count).by(1)
        end

        it 'renders json' do
          patch :vote_no, params: { id: subject }, format: :json
          expect(response.body).to eq({"rating": subject.rating}.to_json)
        end

      end
    end

    context 'when user is not authenticated' do
      it '401' do
        patch :vote_no, params: { id: subject }, format: :json
        expect(response).to have_http_status(401)
      end
      
      it 'not saves the vote no' do
        expect { patch :vote_no, params: { id: subject }, format: :json }.to_not change(Vote, :count)
      end
    end
  end
  
  describe 'PATCH #cancel_vote' do
    let!(:user) { create(:user) }
    let!(:subject) { create(controller.controller_name.classify.downcase.to_sym) }
    before(:each) { user.votes.create(votable: subject) }

    context 'when user is authenticated' do
      context 'and user is author' do
        before { login(subject.user) }

        it 'does not cancel vote' do
          expect { patch :cancel_vote, params: { id: subject }, format: :json }.to_not change(Vote, :count)
        end
        
        it 'renders empty json' do
          patch :cancel_vote, params: { id: subject }, format: :json
          expect(response).to be_successful
        end
      end

      context 'and user is not an author' do
        before { login(user) }
        
        it 'cancel vote' do
          expect { patch :cancel_vote, params: { id: subject }, format: :json }.to change(Vote, :count).by(-1)
        end

        it 'renders json' do
          patch :cancel_vote, params: { id: subject }, format: :json
          expect(response.body).to eq({"rating": subject.rating}.to_json)
        end

      end
    end

    context 'when user is not authenticated' do
      it '401' do
        patch :cancel_vote, params: { id: subject }, format: :json
        expect(response).to have_http_status(401)
      end
      
      it 'not cancel vote' do
        expect { patch :cancel_vote, params: { id: subject }, format: :json }.to_not change(Vote, :count)
      end
    end
  end
end
