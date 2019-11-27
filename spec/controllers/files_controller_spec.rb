require 'rails_helper'

RSpec.describe FilesController, type: :controller do

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, :with_files) }
    let!(:answer) { create(:answer, :with_files) }

    context 'when user authenticated' do
      before { sign_in(question.user) }

      it 'assigns the requested file to @attachment' do
        file = question.files.first
        delete :destroy, params: { id: file.id }, format: :js  
        expect(assigns(:attachment)).to eq(file)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question.files.first.id }, format: :js
        expect(response).to render_template(:destroy)
      end
      
      context 'and user is author of @attachment record' do
        context 'when record is question' do
          before { sign_in(question.user) }
          
          it 'deletes the question attachment' do
            expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.to change { question.files.count }.by(-1)
          end
        end
        
        context 'when record is answer' do
          before { sign_in(answer.user) }

          it 'deletes the question attachment' do
            expect { delete :destroy, params: { id: answer.files.first.id }, format: :js }.to change { answer.files.count }.by(-1)
          end
        end
      end
    
      context 'and user is not and author of @attachment record' do
        before { sign_in(user) }
        
        it 'renders destroy vies' do
          delete :destroy, params: { id: question.files.first.id }, format: :js 
          expect(response).to render_template(:destroy)
        end

        context 'when record is question' do
          it 'not deletes the question attachment' do
            expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.not_to change { question.files.count }
          end
        end
        
        context 'when record is answer' do
          it 'not deletes the question attachment' do
            expect { delete :destroy, params: { id: answer.files.first.id }, format: :js }.not_to change { answer.files.count }
          end
        end
      end 
    end
    
    context 'when user is not authenticated' do
      it 'not assigns the requested file to @attachment' do
        file = answer.files.first
        delete :destroy, params: { id: file.id }, format: :js  
        expect(assigns(:attachment)).to_not eq(file)
      end

      it '401' do
        delete :destroy, params: { id: answer.files.first.id }, format: :js 
        expect(response).to have_http_status(401)
      end
      
      it 'does not delete the answer attachment' do
        expect { delete :destroy, params: { id: answer.files.first.id }, format: :js }.not_to change { answer.files.count }
      end
    end
  end
end
