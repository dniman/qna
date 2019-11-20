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
    let(:question) { create(:question) }

    context 'when user authenticated' do
      before { sign_in(user) }

      context 'with valid attributes' do
        it 'saves a new question to the database' do
          expect { post :create, params: { question: attributes_for(:question) }, format: :js }.to change(Question, :count).by(1)
        end

        it 'renders create view' do
          post :create, params: { question: attributes_for(:question) }, format: :js
          expect(response).to render_template(:create) 
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) }, format: :js }.to_not change(Question, :count)
        end

        it 'renders create view' do
          post :create, params: { question: attributes_for(:question, :invalid) }, format: :js 
          expect(response).to render_template(:create) 
        end
      end
    end

    context 'when user not authenticated' do
      it '401' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js } 
        expect(response).to have_http_status(401)
      end
        
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question) }, format: :js }.to_not change(Question, :count)
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
          before { patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js } }

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

        it 'renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js } 
          expect(response).to render_template(:update)
        end
      end
    end

    context 'when user not authenticated' do
      it '401' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js } 
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

        it 'renders destroy view' do
          delete :destroy, params: { id: question }, format: :js
          expect(response).to render_template(:destroy)
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
end
