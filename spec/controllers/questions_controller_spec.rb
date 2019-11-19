require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let!(:users) { create_list(:user, 2) }
  let!(:questions) { create_list(:question, 3, user: users[0]) }
  let!(:question) { questions[0] }

  describe 'GET #index' do
    context 'when user authenticated' do
      before { sign_in(users[0]) }
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
    context 'when user authenticated' do
      context 'and user is author' do
        before { sign_in(users[0]) }
        before { get :show, params: { id: questions[0] } }

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq(questions[0])
        end

        it 'renders show view' do
          expect(response).to render_template(:show)
        end
      end

      context 'and user is not an author' do
        before { sign_in(users[1]) }
        before { get :show, params: { id: questions[0] } }

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq(questions[0])
        end

        it 'renders show view' do
          expect(response).to render_template(:show)
        end
      end
    end

    context 'when user not authenticated' do
      before { get :show, params: { id: questions[0] } }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq(questions[0])
      end

      it 'renders show view' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'POST #create' do
    context 'when user authenticated' do
      before { sign_in(users[0]) }

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
        patch :update, params: { id: questions[0], question: attributes_for(:question), format: :js } 
        expect(response).to have_http_status(401)
      end
        
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question) }, format: :js }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user authenticated' do 
      context 'and user is author' do
        before { sign_in(users[0]) }

        context 'with valid attributes' do
          it 'assigns the requested question to @question' do
            patch :update, params: { id: questions[0], question: attributes_for(:question) }, format: :js  
            expect(assigns(:question)).to eq(questions[0])
          end

          it 'changes question attributes' do
            patch :update, params: { id: questions[0], question: { title: 'new title', body: 'new body' }, format: :js } 
            questions[0].reload

            expect(questions[0].title).to eq('new title')
            expect(questions[0].body).to eq('new body')
          end

          it 'renders update view' do
            patch :update, params: { id: questions[0], question: attributes_for(:question) }, format: :js 
            expect(response).to render_template(:update)
          end
        end

        context 'with invalid attributes' do
          before { patch :update, params: { id: questions[0], question: attributes_for(:question, :invalid), format: :js } }

          it 'does not change question' do
            title = questions[0].title
            questions[0].reload

            expect(questions[0].title).to eq(title)
            expect(questions[0].body).to eq('MyText')
          end

          it 'renders update view' do
            expect(response).to render_template(:update)
          end
        end
      end

      context 'and user is not an author' do
        before { sign_in(users[1]) }

        it 'assigns the requested question to @question' do
          patch :update, params: { id: questions[0], question: attributes_for(:question), format: :js } 
          expect(assigns(:question)).to eq(questions[0])
        end

        it 'not changes question attributes' do
          patch :update, params: { id: questions[0], question: { title: 'new title', body: 'new body' }, format: :js } 
          questions[0].reload

          expect(questions[0].title).not_to eq('new title')
          expect(questions[0].body).not_to eq('new body')
        end

        it 'renders update view' do
          patch :update, params: { id: questions[0], question: attributes_for(:question), format: :js } 
          expect(response).to render_template(:update)
        end
      end
    end

    context 'when user not authenticated' do
      it '401' do
        patch :update, params: { id: questions[0], question: attributes_for(:question), format: :js } 
        expect(response).to have_http_status(401)
      end

      it 'does not changes question attributes' do
        patch :update, params: { id: questions[0], question: { title: 'new title', body: 'new body' }, format: :js } 
        questions[0].reload

        expect(questions[0].title).not_to eq('new title')
        expect(questions[0].body).not_to eq('new body')
      end
    end
  end
  
  describe 'DELETE #destroy' do
    context 'when user authenticated' do
      context 'and user is author' do
        before { sign_in(users[0]) }

        it 'deletes the question' do
          expect { delete :destroy, params: { id: questions[0] }, format: :js }.to change(Question, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: questions[0] }, format: :js
          expect(response).to render_template(:destroy)
        end
      end

      context 'and user is not and author' do
        before { sign_in(users[1]) }
        
        it 'not deletes the question' do
          expect { delete :destroy, params: { id: questions[0] }, format: :js }.to_not change(Question, :count)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: questions[0] }, format: :js
          expect(response).to render_template(:destroy)
        end
      end
    end

    context 'when user is not authenticated' do
      it '401' do
        delete :destroy, params: { id: questions[0] }, format: :js 
        expect(response).to have_http_status(401)
      end
      
      it 'does not delete the question' do
        expect { delete :destroy, params: { id: questions[0] }, format: :js }.to_not change(Question, :count)
      end
    end
  end
end
