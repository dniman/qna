RSpec.shared_examples 'votable' do 
  it { should have_many(:votes).dependent(:destroy) }
  
  describe "#rating" do
    let!(:users) { create_list(:user, 3) }
    let!(:subject) { create(described_class.to_s.downcase.to_sym) }
    
    context 'when 3 votes yes' do
      it 'vote rating should be 3' do
        users.each do |user|
          user.votes.create(votable: subject, yes: true)
        end
       
        subject.votes.reload
        
        expect(subject.rating).to eq(3)
      end
    end
    
    context 'when 3 votes no' do
      it 'vote rating should be -3' do
        users.each do |user|
          user.votes.create(votable: subject)
        end

        subject.votes.reload

        expect(subject.rating).to eq(-3)
      end
    end
    
    context 'when 2 votes yes and 1 no' do
      it 'vote rating should be 1' do
        users.first.votes.create(votable: subject, yes: true)
        users[1].votes.create(votable: subject, yes: true)
        users.last.votes.create(votable: subject, yes: false)
        
        subject.votes.reload

        expect(subject.rating).to eq(1)
      end
    end
  end
end
