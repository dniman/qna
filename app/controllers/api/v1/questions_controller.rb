class API::V1::QuestionsController < API::V1::BaseController
  before_action :set_question, only: %w[show update destroy]

  authorize_resource

  def index
    @questions = Question.all
    json_response(@questions, :ok, each_serializer: QuestionListSerializer)
  end

  def show
    json_response(@question) 
  end
  
  def create
    @question = current_resource_owner.questions.new(question_params)
    @question.save!

    json_response(@question, :created) 
  end
  
  def update
    @question.update(question_params)
    head :no_content
  end
  
  def destroy
    @question.destroy
    head :no_content
  end

  private
    def set_question
      @question = Question.with_attached_files.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :body)
    end
end
