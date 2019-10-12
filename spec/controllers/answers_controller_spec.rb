require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) do
    create(:user) do |u|
      create(:question, user: u) do |q|
        create(:answer, user: u, question: q)
      end
    end
  end
    
  let(:answer) { user.questions.first.answers.first } 

  describe "GET #show" do
    before { login(user) }
    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq(answer) 
    end
    
    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { :question_id => answer.question } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq(answer) 
    end
    
    it 'renders edit view' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    let(:user) do
      create(:user) do |u|
        create(:question, user: u)
      end
    end
    
    let(:question) { user.questions.first } 

    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer to the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) } 
        expect(response).to redirect_to answer_path(assigns(:answer))
      end
    end
    
    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
      end

      it 're-render new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) } 
        expect(assigns(:answer)).to eq(answer)
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } } 
        answer.reload

        expect(answer.body).to eq('new body')
      end

      it 'redirects to updated answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) } 
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq('MyText')
      end

      it 're-renders edit view' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:answer) { create(:answer) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: answer } 
      expect(response).to redirect_to question_path(answer.question)
    end
  end
end
