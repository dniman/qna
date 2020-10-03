require 'rails_helper'

RSpec.describe 'Profiles api', type: :request do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Accessibility checks' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
      let(:options) { { params: { access_token: access_token.token } } }

      it 'returns all public fields' do
        expect(json).to match_json_schema("v1/profiles/me")
      end
        
      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/others' do
    let!(:others) { create_list(:user, 4) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:other) { others.first }
    let(:other_response) { json['users'].first }
    
    it_behaves_like 'API Accessibility checks' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/others' }
      let(:options) { { params: { access_token: access_token.token } } }

      it 'returns all public fields' do
        expect(json).to match_json_schema("v1/profiles/others")
      end
        
      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(other_response).to_not have_key(attr)
        end
      end
        
      it 'does not contain me' do
        expect(json['users']).to_not include(me.as_json)
      end
    end
  end
end

