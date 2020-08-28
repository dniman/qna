require 'rails_helper'

RSpec.describe Services::FindForOauth do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
  subject { Services::FindForOauth.new(auth) } 

  context 'user already has authorization' do
    it 'returns the user' do
      user.oauth_providers.create(provider: 'github', uid: '123456')

      expect(subject.call).to eq user
    end
  end

  context 'user has not authorization' do
    context 'user already exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email }) }
      it 'does not create new user' do
        expect { subject.call }.not_to change(User, :count)
      end

      it 'creates oauth_provider\'s record for user' do
        expect { subject.call }.to change(user.oauth_providers, :count).by(1)
      end

      it 'creates oauth_provider\'s record with provider and uid' do
        user = subject.call
        oauth_provider = user.oauth_providers.first

        expect(oauth_provider.provider).to eq auth.provider
        expect(oauth_provider.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(subject.call).to eq user
      end
    end

    context 'user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'new@user.com' }) }

      it 'creates new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(subject.call).to be_a(User)
      end

      it 'fills user email' do
        user = subject.call
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates oauth_providers record for user' do
        user = subject.call
        expect(user.oauth_providers).not_to be_empty
      end

      it 'create oauth_providers record with provider and uid' do
        oauth_provider = subject.call.oauth_providers.first 

        expect(oauth_provider.provider).to eq auth.provider
        expect(oauth_provider.uid).to eq auth.uid
      end
    end
  end
end
