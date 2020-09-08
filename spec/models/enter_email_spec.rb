require 'rails_helper'

RSpec.describe EnterEmail, type: :model do
  it { should validate_presence_of :email }
end
