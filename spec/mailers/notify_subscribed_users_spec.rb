require "rails_helper"

RSpec.describe NotifySubscribedUsersMailer, type: :mailer do
  describe ".send_email" do
    let(:answer) { create(:answer) }
    let(:user) { answer.question.user }
    let(:mail) { described_class.send_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("You got a new answer to subscribed question")
      expect(mail.to).to include(user.email)
      expect(mail.from).to include("from@example.org")
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("You got a new answer to subscribed question")
    end
  end
end
