RSpec.shared_examples 'subscriptionable' do 
  it { should have_many(:subscriptions).dependent(:destroy) }
end
