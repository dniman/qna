require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do
  describe "#vote_rating" do
    let(:users) { create_list(:user, 3) }
    let(:answer) { create(:answer) }
    
    context 'when 3 votes yes' do
      it 'vote rating should be 3' do
        users.each do |user|
          user.votes.create(votable: answer.question, yes: true)
          user.votes.create(votable: answer, yes: true)
        end

        expect(helper.vote_rating(answer.question)).to eq(3)
        expect(helper.vote_rating(answer)).to eq(3)
      end
    end
    
    context 'when 3 votes no' do
      it 'vote rating should be -3' do
        users.each do |user|
          user.votes.create(votable: answer.question)
          user.votes.create(votable: answer)
        end

        expect(helper.vote_rating(answer.question)).to eq(-3)
        expect(helper.vote_rating(answer)).to eq(-3)
      end
    end
    
    context 'when 2 votes yes and 1 no' do
      it 'vote rating should be 1' do
        users.first.votes.create(votable: answer.question, yes: true)
        users[1].votes.create(votable: answer.question, yes: true)
        users.last.votes.create(votable: answer.question, yes: false)
        
        users.first.votes.create(votable: answer, yes: true)
        users[1].votes.create(votable: answer, yes: true)
        users.last.votes.create(votable: answer, yes: false)

        expect(helper.vote_rating(answer.question)).to eq(1)
        expect(helper.vote_rating(answer)).to eq(1)
      end
    end
  end
end
