require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe '#github' do
    let(:oauth_data) { { 'provider' => 'github', 'uid' => 123 } }

    it 'find users from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }
      
      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end
      
      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
      
      it 'does not login user' do
        expect(subject.current_user).not_to be
      end
    end
  end
  
  describe '#vkontakte' do
    let(:oauth_data) { { 'provider' => 'vkontakte', 'uid' => 123 } }

    it 'find users from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :vkontakte
    end

    context 'user exists' do
      let!(:user) { create(:user) }
      let!(:unconfirmed_user) { create(:unconfirmed_user) } 
      
      context 'and confirmed' do
        before do
          allow(User).to receive(:find_for_oauth).and_return(user)
          get :vkontakte
        end

        it 'login user' do
          expect(subject.current_user).to eq user
        end

        it 'redirects to root_path' do
          expect(response).to redirect_to(root_path)
        end
      end

      context 'and unconfirmed' do
        before do
          allow(User).to receive(:find_for_oauth).and_return(unconfirmed_user)
          get :vkontakte
        end
        
        it 'redirects to new_user_confirmation_path' do
          expect(response).to redirect_to(new_user_confirmation_path)
        end
      end
    end

    context 'user does not exist' do
      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        allow(session).to receive(:[]).and_call_original
        allow(User).to receive(:find_for_oauth)
      end

      it 'adds oauth_data to session' do
        get :vkontakte
        expect(session['devise.omniauth_data']).to eq oauth_data
      end

      it 'instantiates EnterEmail model' do
        enter_email = double('EnterEmail') 
       
        expect(EnterEmail).to receive(:new).and_return(enter_email)
        get :vkontakte
      end

      it 'renders vkontakte template' do
        allow(subject).to receive(:render).and_call_original
        expect(subject).to receive(:render).with('vkontakte')
        get :vkontakte
      end
    end
  end
end
