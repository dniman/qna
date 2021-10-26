require 'rails_helper'

RSpec.describe Services::NotifySubscribedUsers do
  let(:users) { create_list(:user, 3) }
  let(:answer) { create(:answer) }

  before do
    answer.question.subscriptions.create(user: answer.question.user)
    users.each do |user|
      answer.question.subscriptions.create(user: user)
    end
  end

  it 'notifies author of question' do
    expect(NotifyAuthorOfQuestionMailer).to receive(:send_email).with(answer.question.user).and_call_original  
    described_class.notify(answer)
  end
  
  it 'notifies subscribed users' do
    users.each do |user|
      expect(NotifySubscribedUsersMailer).to receive(:send_email).with(user).and_call_original  
    end
    described_class.notify(answer)
  end
end
