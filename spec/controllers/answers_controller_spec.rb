require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe "GET #show" do
    let(:answer) { create :answer }
    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq(answer) 
    end
    
    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end
end
