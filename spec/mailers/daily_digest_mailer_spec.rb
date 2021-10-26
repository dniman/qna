require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 3, :last_24_hours) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Daily Digest of questions")
      expect(mail.to).to include(user.email)
      expect(mail.from).to include("from@example.org")
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Daily Digest of questions")
    end
  end
end
