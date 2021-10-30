require 'sphinx_helper'

RSpec.describe SearchController, type: :controller, sphinx: true do

  describe 'GET #index' do
    let!(:questions) { create_list(:question, 3) }

    before do
      ThinkingSphinx::Test.index
      sleep 0.25 until Dir[Rails.root.join(ThinkingSphinx::Test.config.indices_location, '*.{new,tmp}*')].empty?
    end

    context "when search is not empty" do
      let(:search_params){ {search: 'MyText', resource: 'Questions'} }

      it 'assigns the searched data to @results' do
        get :index, params: search_params  
        expect(assigns(:results)).to match_array(questions)
      end

      it 'renders index view' do
        get :index, params: search_params  
        expect(response).to render_template :index
      end

      it 'creates new search' do
        get :index, params: search_params  
        expect(assigns(:search)).to be_a Search
      end
    end

    context "when search is empty" do
      let(:search_params){ {search: '', resource: 'Questions'} }

      it 'assigns the searched data to @result' do
        get :index, params: search_params, format: :js  
        expect(assigns(:result)).to be_nil
      end

      it 'renders index view' do
        get :index, params: search_params, format: :js  
        expect(response).to render_template :index
      end
    end

  end
end
