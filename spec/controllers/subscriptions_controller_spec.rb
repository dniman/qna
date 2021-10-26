require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:questions) { [create(:question, user: user), create(:question)] }
  
  describe 'POST #create' do
    context 'when user is authenticated' do
      context 'and user is author' do
        before { login(questions.first.user) }
        before { questions.first.user.unsubscribe!(questions.first) }

        it 'subscribes author to question' do
          expect { post :create, params: { id: questions.first }, format: :json }.to change(Subscription, :count).by(1)
        end
        
        it 'renders json' do
          post :create, params: { id: questions.first }, format: :json
          expect(response.body).to eq({ "question": questions.first, "subscribed": true}.to_json)
        end
      end

      context 'and user is not an author' do
        before { login(user) }
        
        it 'subscribes user to question' do
          expect { post :create, params: { id: questions.last }, format: :json }.to change(Subscription, :count).by(1)
        end

        it 'renders json' do
          post :create, params: { id: questions.last }, format: :json
          expect(response.body).to eq({ "question": questions.last, "subscribed": true}.to_json)
        end

      end
    end

    context 'when user is not authenticated' do
      it '401' do
        post :create, params: { id: questions.first }, format: :json
        expect(response).to have_http_status(401)
      end
      
      it 'not saves the subscription' do
        expect { post :create, params: { id: questions.first }, format: :json }.to_not change(Subscription, :count)
      end
    end
  end

  describe 'DELETE #unsubscribe' do
    context 'when user is authenticated' do
      context 'and user is author' do
        before { login(questions.first.user) }

        it 'deletes the subscription' do
          expect { delete :destroy, params: { id: questions.first }, format: :json }.to change(Subscription, :count).by(-1)
        end
        
        it 'renders json' do
          delete :destroy, params: { id: questions.first }, format: :json
          expect(response.body).to eq({ "question": questions.first, "subscribed": false}.to_json)
        end
      end

      context 'and user is not an author' do
        before { login(user) }
        before { user.subscribe!(questions.last) }
        
        it 'deletes the subscription' do
          expect { delete :destroy, params: { id: questions.last }, format: :json }.to change(Subscription, :count).by(-1)
        end

        it 'renders json' do
          delete :destroy, params: { id: questions.last }, format: :json
          expect(response.body).to eq({ "question": questions.last, "subscribed": false}.to_json)
        end

      end
    end

    context 'when user is not authenticated' do
      it '401' do
        delete :destroy, params: { id: questions.last }, format: :json
        expect(response).to have_http_status(401)
      end
      
      it 'does not delete the subscription' do
        expect { delete :destroy, params: { id: questions.last }, format: :json }.to_not change(Subscription, :count)
      end
    end
  end
end
