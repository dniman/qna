require 'rails_helper'

RSpec.describe Services::Search do
  context "Search for all" do
    it 'all resources' do
      expect(ThinkingSphinx).to receive(:search).with('test')
      described_class.new('test', 'All').call
    end
  end

  context "Search for resource" do
    %w[Question Answer Comment User].each do |resource|
      it "#{resource}" do
        expect(resource.constantize).to receive(:search).with('test')
        described_class.new('test', resource).call
      end
    end
  end
end
