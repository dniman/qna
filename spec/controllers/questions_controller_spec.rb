require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:users) { create_list(:user, 2) }
  let(:questions) { create_list(:question, 3, user: users[0]) }
  let(:question) { questions[0] }


  context "Authenticated user" do
    describe 'GET #index' do
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
 
    describe 'POST #create' do
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

    context 'as an author' do
      before { sign_in(users[0]) }
      
      describe 'GET #show' do
        before { get :show, params: { id: questions[0] } }

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq(questions[0])
        end

        it 'renders show view' do
          expect(response).to render_template(:show)
        end
      end

      describe 'PATCH #update' do
        context 'with valid attributes' do
          
          it 'assigns the requested question to @question' do
            patch :update, params: { id: questions[0], question: attributes_for(:question), format: :js } 
            expect(assigns(:question)).to eq(questions[0])
          end

          it 'changes question attributes' do
            patch :update, params: { id: questions[0], question: { title: 'new title', body: 'new body', format: :js } } 
            questions[0].reload

            expect(questions[0].title).to eq('new title')
            expect(questions[0].body).to eq('new body')
          end

          it 'renders update view' do
            patch :update, params: { id: questions[0], question: attributes_for(:question), format: :js } 
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

      describe 'DELETE #destroy' do
        it 'deletes the question' do
          questions[0]
          expect { delete :destroy, params: { id: questions[0] }, format: :js }.to change(Question, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: questions[0] }, format: :js
          expect(response).to render_template(:destroy)
        end
      end
    end

    context 'as not an author' do
      before { sign_in(users[1]) }

      describe 'GET #show' do
        before { get :show, params: { id: questions[0] } }

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq(questions[0])
        end

        it 'renders show view' do
          expect(response).to render_template(:show)
        end
      end

      describe 'PATCH #update' do
        context 'with valid attributes' do
          
          it 'not assigns the requested question to @question' do
            patch :update, params: { id: questions[0], question: attributes_for(:question), format: :js } 
            expect(assigns(:question)).not_to eq(questions[0])
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

        context 'with invalid attributes' do
          before { patch :update, params: { id: questions[0], question: attributes_for(:question, :invalid) }, format: :js }

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

      describe 'DELETE #destroy' do
        it 'deletes the question' do
          questions[0]
          expect { delete :destroy, params: { id: questions[0] }, format: :js }.not_to change(Question, :count)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: questions[0] }, format: :js
          expect(response).to render_template(:destroy)
        end
      end

    end
  end  

  context "Unauthenticated user" do
    describe 'GET #index' do
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
    
    describe 'GET #show' do
      before { get :show, params: { id: questions[0] } }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq(questions[0])
      end

      it 'renders show view' do
        expect(response).to render_template(:show)
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it '401' do
          patch :update, params: { id: questions[0], question: attributes_for(:question), format: :js } 
          expect(response).to have_http_status(401)
        end
      end

      context 'with invalid attributes' do
        it '401' do
          patch :update, params: { id: questions[0], question: attributes_for(:question, :invalid), format: :js } 
          expect(response).to have_http_status(401)
        end
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        it '401' do
          patch :update, params: { id: questions[0], question: attributes_for(:question), format: :js } 
          expect(response).to have_http_status(401)
        end
      end

      context 'with invalid attributes' do
        it '401' do
          patch :update, params: { id: questions[0], question: attributes_for(:question, :invalid), format: :js } 
          expect(response).to have_http_status(401)
        end
      end
    end

  end  


  
end
