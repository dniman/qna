require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #enter_email' do
    context 'with valid attributes' do
      let(:oauth_data) { { 'provider' => 'vkontakte', 'uid' => 123 } }

      before do
        allow(session).to receive(:[]).and_call_original
        allow(session).to receive(:[]).with('devise.omniauth_data').and_return(oauth_data)
      end
      
      context 'when user does not exist' do
        let(:user) { build(:user) }
        subject { post :enter_email, params: { enter_email: { email: user.email } } }

        it 'creates new user' do
          expect { subject }.to change(User, :count).by(1)
        end

        it 'creates new oauth provider' do
          expect { subject }.to change(OauthProvider, :count).by(1)
        end
      end
      
      context 'when user exists' do
        let(:user) { create(:user) }
        subject { post :enter_email, params: { enter_email: { email: user.email } } }
       
        it 'does not create new user' do
          user.reload
          expect { subject }.not_to change(User, :count)
        end

        context 'and user authorized' do
          before do
            user.oauth_providers.create!(provider: oauth_data['provider'], uid: oauth_data['uid'])
          end

          it 'does not create oauth provider' do
            expect { subject }.not_to change(OauthProvider, :count)
          end
        end

        context 'and user not authorized' do
          it 'creates new oauth provider' do
            expect { subject }.to change(OauthProvider, :count).by(1)
          end
        end
      end

      context 'when user persisted' do
        let(:confirmed_user) { create(:user) }
        let(:unconfirmed_user) { create(:unconfirmed_user) }

        context 'and user confirmed' do
          subject { post :enter_email, params: { enter_email: { email: confirmed_user.email } } }

          it 'redirects to root_path' do
            subject
            expect(response).to redirect_to(root_path)
          end
        end

        context 'and user not confirmed' do
          subject { post :enter_email, params: { enter_email: { email: unconfirmed_user.email } } }

          it 'redirects to confirmation path' do
            subject
            expect(response).to redirect_to(new_user_confirmation_path)
          end
        end
      end

      context 'when user not persisted' do
        let(:user) { build(:user) }

        it 'redirects to new user registration path' do
          allow(User).to receive(:find_for_oauth).and_return(nil)
          post :enter_email, params: { enter_email: { email: user.email} }

          expect(response).to redirect_to new_user_registration_path
        end
      end
    end

    context 'with invalid attributes' do
      render_views
      
      it 'renders html' do
        post :enter_email, params: { enter_email: { email: ''} }

        expect(response.body).to match(/Email can&#39;t be blank/)
        expect(response.body).to match(/Email is invalid/)
      end
    end
  end
end
