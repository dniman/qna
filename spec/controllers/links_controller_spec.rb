require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, :with_links) }
    let!(:answer) { create(:answer, :with_links) }

    context 'when user authenticated' do
      context 'and user is author of question' do
        before { sign_in(question.user) }

        it 'assigns the requested link to @link' do
          link = question.links.first
          delete :destroy, params: { id: link.id }, format: :js  
          expect(assigns(:link)).to eq(link)
        end
        
        it 'deletes the question link' do
          expect { delete :destroy, params: { id: question.links.first.id }, format: :js }.to change { question.links.count }.by(-1)
        end
        
        it 'renders destroy view' do
          delete :destroy, params: { id: question.links.first.id }, format: :js 
          expect(response).to render_template(:destroy)
        end
      end

      context 'and user is author of answer' do
        before { sign_in(answer.user) }

        it 'assigns the requested link to @link' do
          link = answer.links.first
          delete :destroy, params: { id: link.id }, format: :js  
          expect(assigns(:link)).to eq(link)
        end
        
        it 'deletes the answer link' do
          expect { delete :destroy, params: { id: answer.links.first.id }, format: :js }.to change { answer.links.count }.by(-1)
        end
        
        it 'renders destroy view' do
          delete :destroy, params: { id: answer.links.first.id }, format: :js 
          expect(response).to render_template(:destroy)
        end
      end

      context 'and user is not an author of question' do
        before { sign_in(user) }

        it 'not assigns the requested link to @link' do
          link = question.links.first
          delete :destroy, params: { id: link.id }, format: :js  
          expect(assigns(:link)).to eq(link)
        end
        
        it 'not deletes the question link' do
          expect { delete :destroy, params: { id: question.links.first.id }, format: :js }.not_to change { question.links.count }
        end
        
        it 'renders destroy view' do
          delete :destroy, params: { id: question.links.first.id }, format: :js 
          expect(response).to render_template(:destroy)
        end
      end
      
      context 'and user is not an author of answer' do
        before { sign_in(user) }

        it 'not assigns the requested link to @link' do
          link = answer.links.first
          delete :destroy, params: { id: link.id }, format: :js  
          expect(assigns(:link)).to eq(link)
        end
        
        it 'not deletes the answer link' do
          expect { delete :destroy, params: { id: answer.links.first.id }, format: :js }.not_to change { answer.links.count }
        end
        
        it 'renders destroy view' do
          delete :destroy, params: { id: answer.links.first.id }, format: :js 
          expect(response).to render_template(:destroy)
        end
      end
    end

    context 'when user not authenticated' do
      it 'not assigns the requested link to @link' do
        link = question.links.first
        delete :destroy, params: { id: link.id }, format: :js  
        expect(assigns(:link)).to_not eq(link)
      end

      it '401' do
        delete :destroy, params: { id: question.links.first.id }, format: :js 
        expect(response).to have_http_status(401)
      end
      
      it 'does not delete the question link' do
        expect { delete :destroy, params: { id: question.links.first.id }, format: :js }.not_to change { question.links.count }
      end
    end
  end
end
