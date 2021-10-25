require 'rails_helper'

RSpec.describe NotifySubscribedUsersJob, type: :job do
  let(:answer) { create(:answer) }

  it "calls Services::NotifySubscribedUsers#notify" do
    expect(Services::NotifySubscribedUsers).to receive(:notify).with(answer)
    NotifySubscribedUsersJob.perform_now(answer)
  end
end
