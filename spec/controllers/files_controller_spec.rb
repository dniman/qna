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
        delete :destroy, params: { id: file.signed_id }, format: :js  
        expect(assigns(:attachment)).to eq(file)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question.files.first.signed_id }, format: :js
        expect(response).to render_template(:destroy)
      end
      
      context 'and user is author of @attachment record' do
        context 'when record is question' do
          before { sign_in(question.user) }
          
          it 'deletes the question attachment' do
            count = question.files.size
            
            delete :destroy, params: { id: question.files.first.signed_id }, format: :js  
            question.reload 

            expect(question.files.size).to eq(count - 1)
          end
        end
        
        context 'when record is answer' do
          before { sign_in(answer.user) }

          it 'deletes the question attachment' do
            count = answer.files.size
            
            delete :destroy, params: { id: answer.files.first.signed_id }, format: :js  
            answer.reload
            
            expect(answer.files.size).to eq(count - 1)
          end
        end
      end
    
      context 'and user is not and author of @attachment record' do
        before { sign_in(user) }
        
        context 'when record is question' do
          it 'not deletes the question attachment' do
            count = question.files.size
            
            delete :destroy, params: { id: question.files.first.signed_id }, format: :js  
            question.reload 

            expect(question.files.size).to eq(count)
          end
        end
        
        context 'when record is answer' do
          it 'not deletes the question attachment' do
            count = answer.files.size
            
            delete :destroy, params: { id: answer.files.first.signed_id }, format: :js  
            answer.reload
            
            expect(answer.files.size).to eq(count)
          end
        end
      end 
    end
    
    context 'when user is not authenticated' do
      it 'not assigns the requested file to @attachment' do
        file = answer.files.first
        delete :destroy, params: { id: file.signed_id }, format: :js  
        expect(assigns(:attachment)).to_not eq(file)
      end

      it '401' do
        delete :destroy, params: { id: answer.files.first.signed_id }, format: :js 
        expect(response).to have_http_status(401)
      end
      
      it 'does not delete the answer attachment' do
        count = answer.files.size
            
        delete :destroy, params: { id: answer.files.first.signed_id }, format: :js  
        answer.reload
            
        expect(answer.files.size).to eq(count)
      end
    end
  end
end
