require 'rails_helper'

RSpec.describe 'Profiles api', type: :request do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /api/v1/profiles/me' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles/me' }
    let(:options) { { params: { access_token: access_token.token } } }

    it_behaves_like 'API Authorizable'
      
    it_behaves_like 'API Unauthorizable' do
      let(:options) { { params: { access_token: '1234' } } }
    end
        
    it 'returns all public fields' do
      %w[id email admin created_at updated_at].each do |attr|
        do_request(method, api_path, options) 
        expect(json['user'][attr]).to eq me.send(attr).as_json
      end
    end
      
    it 'does not return private fields' do
      %w[password encrypted_password].each do |attr|
        do_request(method, api_path, options) 
        expect(json).to_not have_key(attr)
      end
    end
  end

  describe 'GET /api/v1/profiles/others' do
    let!(:others) { create_list(:user, 4) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:other) { others.first }
    let(:other_response) { json['users'].first }

    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles/others' }
    let(:options) { { params: { access_token: access_token.token } } }
    
    it_behaves_like 'API Authorizable' 
      
    it_behaves_like 'API Unauthorizable' do
      let(:options) { { params: { access_token: '1234' } } }
    end

    it 'returns all public fields' do
      %w[id email admin created_at updated_at].each do |attr|
        do_request(method, api_path, options) 
        expect(other_response[attr]).to eq other.send(attr).as_json
      end
    end
      
    it 'does not return private fields' do
      %w[password encrypted_password].each do |attr|
        do_request(method, api_path, options) 
        expect(other_response).to_not have_key(attr)
      end
    end
      
    it 'does not contain me' do
      do_request(method, api_path, options) 
      expect(json['users']).to_not include(me.as_json)
    end
  end
end

