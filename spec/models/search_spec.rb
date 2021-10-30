require 'rails_helper'

RSpec.describe Search, type: :model do
  it { should validate_presence_of :resource }
  
  describe '#run' do
    let(:service) { double('Services::Search') }

    it 'calls Services::Search' do
      expect(Services::Search).to receive(:new).with(subject.search, subject.resource).and_return(service)
      expect(service).to receive(:call)
      subject.run
    end
  end
end
