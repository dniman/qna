require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, user: users[0]) }
  let(:answer) { create(:answer, question: question, user: users[0]) } 

  context "Authenticated user" do
    describe 'POST #create' do
      before { login(users[0]) }

      context 'with valid attributes' do
        it 'saves a new answer to the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
        end

        it 'renders create view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } 
          expect(response).to render_template :create
        end
      end
    
      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(question.answers, :count)
        end

        it 'renders create view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to render_template :create
        end
      end
    end

    context "when it is an author" do
      before { login(users[0]) }
      
      describe 'PATCH #update' do
        context 'with valid attributes' do
          it 'assigns the requested answer to @answer' do
            patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js } 
            expect(assigns(:answer)).to eq(answer)
          end

          it 'changes answer attributes' do
            patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js } 
            answer.reload

            expect(answer.body).to eq('new body')
          end

          it 'renders update view' do
            patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js } 
            expect(response).to render_template :update 
          end
        end

        context 'with invalid attributes' do
          before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js } }

          it 'does not change answer' do
            answer.reload

            expect(answer.body).to eq('MyText')
          end

          it 'renders update view' do
            expect(response).to render_template(:update)
          end
        end
      end

      describe 'DELETE #destroy' do
        it 'deletes the answer' do
          answer
          expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: answer }, format: :js 
          expect(response).to render_template(:destroy) 
        end
      end

      describe 'PATCH #mark_as_the_best' do
        it 'changes answer attribute' do
          patch :mark_as_the_best, params: { id: answer, format: :js } 
          answer.reload
          
          expect(answer).to be_best_answer 
        end

        it 'renders update view' do
          patch :mark_as_the_best, params: { id: answer, format: :js } 
          expect(response).to render_template(:mark_as_the_best)
        end
      end
    end

    context "when it is not an author" do
      before { login(users[1]) }
      
      describe 'PATCH #update' do
        context 'with valid attributes' do
          it 'not assigns the requested answer to @answer' do
            patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
            expect(assigns(:answer)).not_to eq(answer)
          end

          it 'not changes answer attributes' do
            patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js } 
            answer.reload

            expect(answer.body).to eq('MyText')
          end

          it 'not renders update view' do
            patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
            expect(response).to render_template :update 
          end
        end

        context 'with invalid attributes' do
          before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js } }

          it 'does not change answer' do
            answer.reload

            expect(answer.body).to eq('MyText')
          end

          it 'renders update view' do
            expect(response).to render_template(:update)
          end
        end
      end

      describe 'DELETE #destroy' do
        it 'not deletes the answer' do
          answer
          expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: answer }, format: :js 
          expect(response).to render_template(:destroy) 
        end
      end

      describe 'PATCH #mark_as_the_best' do
        it 'changes answer attribute' do
          patch :mark_as_the_best, params: { id: answer, format: :js } 
          answer.reload
          
          expect(answer).not_to be_best_answer
        end

        it 'renders update view' do
          patch :mark_as_the_best, params: { id: answer, format: :js } 
          expect(response).to render_template(:mark_as_the_best)
        end
      end
    end
  end

  context "Unauthenticated user" do
    describe 'POST #create' do
      context 'with valid attributes' do
        it '401' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } 
          expect(response).to have_http_status(401)
        end
      end
      
      context 'with invalid attributes' do
        it '401' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to have_http_status(401)
        end
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        it '401' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js } 
          expect(response).to have_http_status(401)
        end
      end

      context 'with invalid attributes' do
        it '401' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to have_http_status(401)
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:answer) { create(:answer) }

      it '401' do
        delete :destroy, params: { id: answer }, format: :js 
        expect(response).to have_http_status(401)
      end
    end

    describe 'PATCH #mark_as_the_best' do
      it '401' do
        patch :mark_as_the_best, params: { id: answer, format: :js } 
        expect(response).to have_http_status(401)
      end
    end
  end
end
