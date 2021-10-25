RSpec.shared_examples 'subscripted' do 
 
  describe 'PATCH #subscribe' do
    let!(:user) { create(:user) }
    let!(:subject) { create(controller.controller_name.classify.downcase.to_sym) }

    context 'when user is authenticated' do
      context 'and user is author' do
        before { login(subject.user) }
        before { subject.user.unsubscribe!(subject) }

        it 'subscribes author to question' do
          expect { patch :subscribe, params: { id: subject }, format: :json }.to change(Subscription, :count).by(1)
        end
        
        it 'renders json' do
          patch :subscribe, params: { id: subject }, format: :json
          expect(response.body).to eq({ "subscriptionable": subject, "subscribed": true}.to_json)
        end
      end

      context 'and user is not an author' do
        before { login(user) }
        
        it 'subscribes user to question' do
          expect { patch :subscribe, params: { id: subject }, format: :json }.to change(Subscription, :count).by(1)
        end

        it 'renders json' do
          patch :subscribe, params: { id: subject }, format: :json
          expect(response.body).to eq({ "subscriptionable": subject, "subscribed": true}.to_json)
        end

      end
    end

    context 'when user is not authenticated' do
      it '401' do
        patch :subscribe, params: { id: subject }, format: :json
        expect(response).to have_http_status(401)
      end
      
      it 'not saves the subscription' do
        expect { patch :subscribe, params: { id: subject }, format: :json }.to_not change(Subscription, :count)
      end
    end
  end

  describe 'PATCH #unsubscribe' do
    let!(:user) { create(:user) }
    let!(:subject) { create(controller.controller_name.classify.downcase.to_sym) }

    context 'when user is authenticated' do
      context 'and user is author' do
        before { login(subject.user) }

        it 'deletes the subscription' do
          expect { patch :unsubscribe, params: { id: subject }, format: :json }.to change(Subscription, :count).by(-1)
        end
        
        it 'renders json' do
          patch :unsubscribe, params: { id: subject }, format: :json
          expect(response.body).to eq({ "subscriptionable": subject, "subscribed": false}.to_json)
        end
      end

      context 'and user is not an author' do
        before { login(user) }
        let!(:subscription) { create(:subscription, user: user, subscriptionable: subject) }
        
        it 'deletes the subscription' do
          expect { patch :unsubscribe, params: { id: subject }, format: :json }.to change(Subscription, :count).by(-1)
        end

        it 'renders json' do
          patch :unsubscribe, params: { id: subject }, format: :json
          expect(response.body).to eq({ "subscriptionable": subject, "subscribed": false}.to_json)
        end

      end
    end

    context 'when user is not authenticated' do
      it '401' do
        patch :unsubscribe, params: { id: subject }, format: :json
        expect(response).to have_http_status(401)
      end
      
      it 'does not delete the subscription' do
        expect { patch :unsubscribe, params: { id: subject }, format: :json }.to_not change(Subscription, :count)
      end
    end
  end
end
