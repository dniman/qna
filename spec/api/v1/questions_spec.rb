require 'rails_helper'

RSpec.describe 'Questions api', type: :request do
  let(:access_token) { create(:access_token) }
  
  # index
  describe 'GET /api/v1/questions' do
    let!(:questions) { create_list(:question, 2) }
    let(:question) { questions.first }
    let(:question_response) { json['questions'].first }
    
    it_behaves_like 'API Accessibility checks' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
      let(:options) { { params: { access_token: access_token.token } } }

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        expect(json).to match_json_schema("v1/questions/index")
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end
    end
  end
  
  # show
  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:question_response) { json['question'] }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let!(:files) { 
      question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain')
      question.files.attach(io: File.open(Rails.root.join('spec', 'spec_helper.rb')), filename: 'spec_helper.rb', content_type: 'text/plain')
    }
    let!(:links) { create_list(:link, 4, linkable: question) }
    let!(:comments) { create_list(:comment, 5, commentable: question) }
        
    it_behaves_like 'API Accessibility checks' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{ question.id }" }
      let(:options) { { params: { access_token: access_token.token } } }
        
      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
        
      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end
        
      describe 'files' do
        it 'returns list of files' do
          expect(question_response['files'].size).to eq 2 
        end
      end
      
      describe 'links' do
        let(:link) { links.last }
        let(:link_response) { question_response['links'].last }
        
        it 'returns list of links' do
          expect(question_response['links'].size).to eq 4 
        end
          
        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
          
        it 'does not return private fields' do
          %w[linkable_type linkable_id].each do |attr|
            expect(json).to_not have_key(attr)
          end
        end
      end
      
      describe 'comments' do
        let(:comment) { comments.last }
        let(:comment_response) { question_response['comments'].first }
          
        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 5 
        end
          
        it 'returns all public fields' do
          %w[id body created_at updated_at user_id].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
          
        it 'does not return private fields' do
          %w[commentable_type commentable_id].each do |attr|
            expect(json).to_not have_key(attr)
          end
        end
      end
    end
  end

  # create question
  describe 'POST /api/v1/questions' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token) }
    let(:valid_attributes) { build(:question, user: user) }
    let(:invalid_attributes) { user.questions.new }
    
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions" }
    let(:options) { { params: { access_token: access_token.token, question: valid_attributes.attributes } } }

    context 'with valid attributes' do
      let(:options) { { params: { access_token: access_token.token, question: valid_attributes.attributes } } }
      
      it 'saves a new question to the database' do
        expect { do_request(method, api_path, options) }.to change(Question, :count).by(1)
      end

      it_behaves_like 'API Accessibility checks' do
        it 'renders json' do
          expect(json["question"]["body"]).to eq(valid_attributes.body) 
          expect(json["question"]["title"]).to eq(valid_attributes.title) 
        end
            
        it 'returns 201 status' do
          expect(response).to have_http_status(201)
        end
      end
    end

    context 'with invalid attributes' do
      let(:options) { { params: { access_token: access_token.token, question: invalid_attributes.attributes } } }
      
      it 'does not save a new question to the database' do
        expect { do_request(method, api_path, options) }.to_not change(Question, :count)
      end

      it 'renders json' do
        do_request(method, api_path, options) 
        expect(json["message"]).to eq("Validation failed: Title can't be blank, Body can't be blank") 
      end
          
      it 'returns 422 status' do
        do_request(method, api_path, options) 
        expect(response).to have_http_status(422)
      end
    end
  end
  
  # update 
  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user, title: 'QuestionTitle', body: 'QuestionBody') }
    let(:method) { :patch }
    let(:api_path) { "/api/v1/questions/#{ question.id }" }
    let(:options) { { params: { access_token: access_token.token, question: { title: 'new title', body: 'new body' } } } }

    let(:question_response) { json['question'] }
      
    context 'when user is an author' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      
      it_behaves_like 'API Accessibility checks' do
        context 'with valid attributes' do
          it 'changes question attributes' do
            question.reload
            expect(question.body).to eq('new body')
            expect(question.title).to eq('new title')
          end      
            
          it 'returns status code 204' do
            expect(response).to have_http_status(204)
          end
        end

        context 'with invalid attributes' do
          let(:options) { { params: { access_token: access_token.token, question: { title: '', body: '' } } } }

          it 'does not change question attributes' do
            question.reload
            expect(question.body).to eq('QuestionBody')
            expect(question.title).to eq('QuestionTitle')
          end      
            
          it 'returns status code 204' do
            expect(response).to have_http_status(204)
          end
        end
      end
    end

    context 'when user is not an author' do
      before { do_request(method, api_path, options) }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
      
      it 'does not change question attributes' do
        question.reload
        expect(question.body).to eq('QuestionBody')
        expect(question.title).to eq('QuestionTitle')
      end      
    end
  end

  # destroy
  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question, 3, user: user) }
      
    let(:method) { :delete }
    let(:api_path) { "/api/v1/questions/#{ questions.first.id }" }
    let(:options) { { params: { access_token: access_token.token } } }

    context 'when user is an author' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      
      it 'deletes selected question from the database' do
        expect { do_request(method, api_path, options) }.to change(Question, :count).by(-1)
      end
      
      it_behaves_like 'API Accessibility checks' do
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end
    
    context 'when user is not an author' do
      it 'does not delete selected question from the database' do
        expect { do_request(method, api_path, options) }.to_not change(Question, :count)
      end
      
      it 'returns status code 403' do
        do_request(method, api_path, options) 
        expect(response).to have_http_status(403)
      end
    end
  end
end
