RSpec.shared_examples 'API Unauthorizable' do
  it 'returns 401 status if there is no access token' do
    do_request(method, api_path, options)
    expect(response.status).to eq 401
  end

  it 'returns 401 status if access token is invalid' do
    do_request(method, api_path, options)
    expect(response.status).to eq 401
  end
end
