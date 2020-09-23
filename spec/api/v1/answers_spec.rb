require 'rails_helper'

RSpec.describe 'Answers api', type: :request do
  let(:access_token) { create(:access_token) }
  let(:question) { create(:question) }

  # index
  describe 'GET /api/v1/questions/:id/answers' do
    let!(:answers) { create_list(:answer, 3, question: question) }
    let(:answer) { answers.first }

    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{ answer.question.id }/answers" }
    let(:options) { { params: { access_token: access_token.token } } }
    
    let(:answer_response) { json['answers'].first }

    it_behaves_like 'API Authorizable'
    
    it_behaves_like 'API Unauthorizable' do
      let(:options) { { params: { access_token: '1234' } } }
    end
      
    it 'returns list of answers' do
      do_request(method, api_path, options) 
      expect(json['answers'].size).to eq 3 
    end

    it 'returns all public fields' do
      %w[id body created_at updated_at].each do |attr|
        do_request(method, api_path, options) 
        expect(answer_response[attr]).to eq answer.send(attr).as_json
      end
    end
      
    it 'contains user object' do
      do_request(method, api_path, options) 
      expect(answer_response['user']['id']).to eq answer.user.id
    end
  end
  
  # show 
  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let!(:files) { 
      answer.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain')
      answer.files.attach(io: File.open(Rails.root.join('spec', 'spec_helper.rb')), filename: 'spec_helper.rb', content_type: 'text/plain')
    }
    let!(:links) { create_list(:link, 4, linkable: answer) }
    let!(:comments) { create_list(:comment, 5, commentable: answer) }
    
    let(:method) { :get }
    let(:api_path) { "/api/v1/answers/#{ answer.id }" }
    let(:options) { { params: { access_token: access_token.token } } }

    let(:answer_response) { json['answer'] }

    let(:method) { :get }
    let(:api_path) { "/api/v1/answers/#{ answer.id }" }
    let(:options) { { params: { access_token: access_token.token } } }
    
    it_behaves_like 'API Authorizable'

    it_behaves_like 'API Unauthorizable' do
      let(:options) { { params: { access_token: '1234'} } }
    end

    it 'returns all public fields' do
      %w[id body created_at updated_at].each do |attr|
        do_request(method, api_path, options) 
        expect(answer_response[attr]).to eq answer.send(attr).as_json
      end
    end
    
    it 'contains user object' do
      do_request(method, api_path, options) 
      expect(answer_response['user']['id']).to eq answer.user.id
    end
    
    describe 'files' do
      it 'returns list of files' do
        do_request(method, api_path, options) 
        expect(answer_response['files'].size).to eq 2 
      end
    end
    
    describe 'links' do
      let(:link) { links.last }
      let(:link_response) { answer_response['links'].first }
      
      it 'returns list of links' do
        do_request(method, api_path, options) 
        expect(answer_response['links'].size).to eq 4 
      end
      
      it 'returns all public fields' do
        %w[id name url created_at updated_at].each do |attr|
          do_request(method, api_path, options) 
          expect(link_response[attr]).to eq link.send(attr).as_json
        end
      end
      
      it 'does not return private fields' do
        %w[linkable_type linkable_id].each do |attr|
          do_request(method, api_path, options) 
          expect(json).to_not have_key(attr)
        end
      end
    end
    
    describe 'comments' do
      let(:comment) { comments.last }
      let(:comment_response) { answer_response['comments'].first }
      
      it 'returns list of comments' do
        do_request(method, api_path, options) 
        expect(answer_response['comments'].size).to eq 5 
      end
      
      it 'returns all public fields' do
        %w[id body created_at updated_at user_id].each do |attr|
          do_request(method, api_path, options) 
          expect(comment_response[attr]).to eq comment.send(attr).as_json
        end
      end
      
      it 'does not return private fields' do
        %w[commentable_type commentable_id].each do |attr|
          do_request(method, api_path, options) 
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  # create answer
  describe 'POST /api/v1/questions/:id/answers' do
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions/#{ question.id }/answers" }
    let(:options) { { params: { access_token: access_token.token, answer: valid_attributes.attributes } } }

    let(:valid_attributes) { build(:answer, question: question) }
    let(:invalid_attributes) { question.answers.new }

    it_behaves_like 'API Authorizable'
    
    it_behaves_like 'API Unauthorizable' do
      let(:options) { { params: { access_token: '1234', answer: valid_attributes.attributes } } }
    end
    
    context 'with valid attributes' do
      let(:options) { { params: { access_token: access_token.token, answer: valid_attributes.attributes } } }
      
      it 'saves a new answer to the database' do
        do_request(method, api_path, options) 
        expect { do_request(method, api_path, options) }.to change(question.answers, :count).by(1)
      end

      it 'renders json' do
        do_request(method, api_path, options) 
        expect(json["answer"]["body"]).to eq(valid_attributes.body) 
      end
          
      it 'returns 201 status' do
        do_request(method, api_path, options) 
        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid attributes' do
      let(:options) { { params: { access_token: access_token.token, answer: invalid_attributes.attributes } } }
      
      it 'does not save a new answer to the database' do
        expect { do_request(method, api_path, options) }.to_not change(question.answers, :count)
      end

      it 'renders json' do
        do_request(method, api_path, options) 
        expect(json["message"]).to eq("Validation failed: Body can't be blank") 
      end
          
      it 'returns 422 status' do
        do_request(method, api_path, options) 
        expect(response).to have_http_status(422)
      end
    end
  end
  
  # update 
  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, user: user, body: 'AnswerBody') }
    let(:method) { :patch }
    let(:api_path) { "/api/v1/answers/#{ answer.id }" }
    let(:options) { { params: { access_token: access_token.token, answer: { body: 'new body' } } } }

    let(:answer_response) { json['answer'] }
      
    context 'when user is an author' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      
      it_behaves_like 'API Authorizable'

      it_behaves_like 'API Unauthorizable' do
        let(:options) { { params: { access_token: '1234'} } }
      end

      context 'with valid attributes' do
        it 'changes answer attributes' do
          do_request(method, api_path, options) 
          answer.reload
          expect(answer.body).to eq('new body')
        end      
          
        it 'returns status code 204' do
          do_request(method, api_path, options) 
          expect(response).to have_http_status(204)
        end
      end

      context 'with invalid attributes' do
        let(:options) { { params: { access_token: access_token.token, answer: { body: '' } } } }

        it 'does not change answer attributes' do
          answer.reload
          expect(answer.body).to eq('AnswerBody')
        end      
          
         it 'returns status code 204' do
          do_request(method, api_path, options) 
          expect(response).to have_http_status(204)
        end
      end
    end
    
    context 'when user is not an author' do
      it 'returns status code 403' do
        do_request(method, api_path, options) 
        expect(response).to have_http_status(403)
      end
      
      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq('AnswerBody')
      end      
    end
  end
  
  # destroy
  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:answers) { create_list(:answer, 3, user: user) }
      
    let(:method) { :delete }
    let(:api_path) { "/api/v1/answers/#{ answers.first.id }" }
    let(:options) { { params: { access_token: access_token.token } } }

    context 'when user is an author' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      
      it_behaves_like 'API Authorizable'
      
      it_behaves_like 'API Unauthorizable' do
        let(:options) { { params: { access_token: '1234'} } }
      end

      it 'deletes selected answer from the database' do
        expect { do_request(method, api_path, options) }.to change(Answer, :count).by(-1)
      end
      
      it 'returns status code 204' do
        do_request(method, api_path, options) 
        expect(response).to have_http_status(204)
      end
    end
    
    context 'when user does not an author' do
      it 'does not delete selected answer from the database' do
        expect { do_request(method, api_path, options) }.to_not change(Answer, :count)
      end
      
      it 'returns status code 403' do
        do_request(method, api_path, options) 
        expect(response).to have_http_status(403)
      end
    end
  end
end
