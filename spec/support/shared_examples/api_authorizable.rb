RSpec.shared_examples 'API Authorizable' do
  it 'returns 200 status' do
    do_request(method, api_path, options)
    expect(response).to be_successful
  end
end
