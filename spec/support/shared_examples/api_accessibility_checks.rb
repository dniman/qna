RSpec.shared_examples 'API Accessibility checks' do
  before { do_request(method, api_path, options) }

  it 'returns 200 status' do
    expect(response).to be_successful
  end
  
  it 'returns 401 status if there is no access token' do
    do_request(method, api_path, { params: { access_token: '1234' } })
    expect(response.status).to eq 401
  end

  it 'returns 401 status if access token is invalid' do
    do_request(method, api_path, { params: { access_token: '1234' } })
    expect(response.status).to eq 401
  end
end
