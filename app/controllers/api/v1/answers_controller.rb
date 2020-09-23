class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %w[index create]
  before_action :set_answer, only: %w[show update destroy]
  
  authorize_resource

  def index
    @answers = Answer.where(question: @question)
    json_response(@answers, :ok, serializer: AnswerListSerializer)
  end

  def show
    json_response(@answer)
  end

  def create
    @answer = current_resource_owner.answers.new(answer_params)
    @answer.question = @question
    @answer.save!

    json_response(@answer, :created) 
  end

  def update
    @answer.update(answer_params) if current_resource_owner.author_of?(@answer)
    head :no_content
  end

  def destroy
    @answer.destroy if current_resource_owner.author_of?(@answer)
    head :no_content
  end

  private
    def find_question
      @question = Question.find(params[:question_id])
    end

    def set_answer
      @answer = Answer.find(params[:id])
    end
    
    def answer_params
      params.require(:answer).permit(:body)
    end
end
