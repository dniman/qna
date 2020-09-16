require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 3) }
    
    context 'when user authenticated' do
      before { sign_in(user) }
      before { get :index }
      
      it 'populates an array of all questions' do
        expect(assigns(:questions)).to match_array(questions)
      end

      it 'assigns new question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end
      
      it 'adds new link instance to @question.links' do
        expect(assigns(:question).links.first).to be_a_new(Link)
      end
      
      it 'adds new bounty instance to @question.bounty' do
        expect(assigns(:question).bounty).to be_a_new(Bounty)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end
    
    context "when user not authenticated" do
      before { get :index }
        
      it 'populates an array of all questions' do
        expect(assigns(:questions)).to match_array(questions)
      end

      it 'not assigns new question to @question' do
        expect(assigns(:question)).not_to be_a_new(Question)
      end
        
      it 'renders index view' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'when user authenticated' do
      context 'and user is author' do
        before { sign_in(question.user) }
        before { get :show, params: { id: question } }

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq(question)
        end

        it 'assigns new answer to @answer' do
          expect(assigns(:answer)).to be_a_new(Answer)
        end

        it 'assigns new comment to @comment' do
          expect(assigns(:comment)).to be_a_new(Comment)
        end

        it 'renders show view' do
          expect(response).to render_template(:show)
        end
      end

      context 'and user is not an author' do
        before { sign_in(user) }
        before { get :show, params: { id: question } }

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq(question)
        end

        it 'renders show view' do
          expect(response).to render_template(:show)
        end
      end
    end

    context 'when user not authenticated' do
      before { get :show, params: { id: question } }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq(question)
      end

      it 'renders show view' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }
    subject { post :create, params: { question: question.attributes }, format: :json }
    let(:body) { JSON.parse(response.body) }

    context 'when user authenticated' do
      before { sign_in(user) }

      context 'with valid attributes' do
        it 'saves a new question to the database' do
          expect { subject }.to change(Question, :count).by(1)
        end

        it 'renders json' do
          subject
          
          expect(body["title"]).to eq(question.title)
          expect(body["body"]).to eq(question.body)
        end

        it "transmits question" do
          expect { subject }.to have_broadcasted_to("questions_channel").with { |data|
            expect(data[:question][:title]).to eq(question.title)
            expect(data[:question][:body]).to eq(question.body)
          }
        end
      end

      context 'with invalid attributes' do
        let(:question) { build(:question, :invalid, user: user) }

        it 'does not save the question' do
          expect { subject }.to_not change(Question, :count)
        end

        it 'renders json' do
          subject
          expect(body["errors"]).to eq(["Title can't be blank"])
        end
      end
    end

    context 'when user not authenticated' do
      it '401' do
        subject
        expect(response).to have_http_status(401)
      end
        
      it 'does not save the question' do
        expect { subject }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'when user authenticated' do 
      context 'and user is author' do
        before { sign_in(question.user) }

        context 'with valid attributes' do
          it 'assigns the requested question to @question' do
            patch :update, params: { id: question, question: attributes_for(:question) }, format: :js  
            expect(assigns(:question)).to eq(question)
          end

          it 'changes question attributes' do
            patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js } 
            question.reload

            expect(question.title).to eq('new title')
            expect(question.body).to eq('new body')
          end

          it 'renders update view' do
            patch :update, params: { id: question, question: attributes_for(:question) }, format: :js 
            expect(response).to render_template(:update)
          end
        end

        context 'with invalid attributes' do
          before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

          it 'does not change question' do
            body = question.body
            title = question.title

            question.reload

            expect(question.title).to eq(title)
            expect(question.body).to eq(body)
          end

          it 'renders update view' do
            expect(response).to render_template(:update)
          end
        end
      end

      context 'and user is not an author' do
        before { sign_in(user) }

        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js } 
          expect(assigns(:question)).to eq(question)
        end

        it 'not changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js } 
          
          body = question.body
          title = question.title
          
          question.reload

          expect(question.title).to eq(title)
          expect(question.body).to eq(body)
        end
       
        it 'not renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js 
          expect(response).to_not render_template(:update)
        end
        it '403' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js } 
          expect(response).to have_http_status(403)
        end
      end
    end

    context 'when user not authenticated' do
      it '401' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js  
        expect(response).to have_http_status(401)
      end

      it 'does not changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js } 
        
        body = question.body
        title = question.title
        
        question.reload

        expect(question.title).to eq(title)
        expect(question.body).to eq(body)
      end
    end
  end
  
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    context 'when user authenticated' do
      context 'and user is author' do
        before { sign_in(question.user) }

        it 'deletes the question' do
          expect { delete :destroy, params: { id: question }, format: :js }.to change(Question, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: question }, format: :js
          expect(response).to render_template(:destroy)
        end
      end

      context 'and user is not and author' do
        before { sign_in(user) }
        
        it 'not deletes the question' do
          expect { delete :destroy, params: { id: question }, format: :js }.to_not change(Question, :count)
        end
        
        it 'does not render destroy view' do
          delete :destroy, params: { id: question }, format: :js
          expect(response).to_not render_template(:destroy)
        end
        
        it '403' do
          delete :destroy, params: { id: question }, format: :js
          expect(response).to have_http_status(403)
        end
      end
    end

    context 'when user is not authenticated' do
      it '401' do
        delete :destroy, params: { id: question }, format: :js 
        expect(response).to have_http_status(401)
      end
      
      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question }, format: :js }.to_not change(Question, :count)
      end
    end
  end

  include_examples 'voted'
end
