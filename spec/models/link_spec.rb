require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  
  it { should allow_value('http://example.org').for(:url).ignoring_interference_by_writer }
  it { should_not allow_value('example.org').for(:url).ignoring_interference_by_writer }
end
