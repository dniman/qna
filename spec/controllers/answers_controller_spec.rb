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

  describe 'PATCH #update' do
    before { login(user) }

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
    before { login(user) }
    let!(:answer) { create(:answer) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'renders destroy view' do
      delete :destroy, params: { id: answer }, format: :js 
      expect(response).to render_template(:destroy) 
    end
  end

  describe 'PATCH #mark_as_the_best' do
    before { login(user) }

    it 'changes answer attribute' do
      patch :mark_as_the_best, params: { id: answer, format: :js } 
      answer.reload
      
      expect(answer.is_best).to eq(1)
    end

    it 'renders update view' do
      patch :mark_as_the_best, params: { id: answer, format: :js } 
      expect(response).to render_template(:mark_as_the_best)
    end
  end

end
