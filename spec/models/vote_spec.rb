require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable).touch(true) }
  it { should belong_to(:user) }
end
