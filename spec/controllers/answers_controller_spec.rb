require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, :with_bounty) }
  let!(:answer) { create(:answer, question: question) } 

  describe 'POST #create' do

    context 'when user is authenticated' do
      before { login(user) }

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

    context 'when user is not authenticated' do
      it '401' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } 
        expect(response).to have_http_status(401)
      end
    
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to_not change(question.answers, :count)
      end
    end
  end

  describe 'PATCH #update' do
    
    context 'when user is authenticated' do
      context 'and user is an author' do
        before { login(answer.user) }

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

        context 'and user is not an author' do
          before { login(user) }

          it 'assigns the requested answer to @answer' do
            patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
            expect(assigns(:answer)).to eq(answer)
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
      end
    end

    context 'when user is not authenticated' do
      it '401' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js } 
        expect(response).to have_http_status(401)
      end

      it 'does not changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js } 
        answer.reload

        expect(answer.body).not_to eq('new body')
      end
    end
  end
 
  describe 'DELETE #destroy' do
    context 'when user is authenticated' do
      context 'and user is author' do
        before { login(answer.user) }
        
        it 'deletes the answer' do
          expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: answer }, format: :js 
          expect(response).to render_template(:destroy) 
        end
      end

      context 'and user is not an author' do
        before { login(user) }

        it 'not deletes the answer' do
          expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: answer }, format: :js 
          expect(response).to render_template(:destroy) 
        end
      end
    end

    context 'when user is not authenticated' do
      it '401' do
        delete :destroy, params: { id: answer }, format: :js 
        expect(response).to have_http_status(401)
      end
      
      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end
  end
 
  describe 'PATCH #mark_as_the_best' do
    context 'when user is authenticated' do
      context 'and user is author' do
        before { login(question.user) }

        it 'changes answer attribute' do
          patch :mark_as_the_best, params: { id: answer }, format: :js 
          answer.reload
          
          expect(answer).to be_best_answer 
        end

        it 'renders update view' do
          patch :mark_as_the_best, params: { id: answer }, format: :js  
          expect(response).to render_template(:mark_as_the_best)
        end
        
        it 'adds bounty to user' do
          expect { patch :mark_as_the_best, params: { id: answer }, format: :js }.to change(answer.user.bounties, :count).by(1)
        end
      end

      context 'and user is not an author' do
        before { login(user) }
        
        it 'not changes answer attribute' do
          patch :mark_as_the_best, params: { id: answer }, format: :js  
          answer.reload
          
          expect(answer).not_to be_best_answer
        end

        it 'renders update view' do
          patch :mark_as_the_best, params: { id: answer }, format: :js 
          expect(response).to render_template(:mark_as_the_best)
        end

        it 'not add bounty to user' do

        end
      end
    end

    context 'when user is not authenticated' do
      it '401' do
        patch :mark_as_the_best, params: { id: answer }, format: :js  
        expect(response).to have_http_status(401)
      end
      
      it 'not changes answer attribute' do
        patch :mark_as_the_best, params: { id: answer }, format: :js  
        answer.reload
        
        expect(answer).not_to be_best_answer
      end
    end
  end

end
