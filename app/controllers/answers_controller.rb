class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :find_question, only: %i[ new create ]
  before_action :find_answer, only: %i[ edit update destroy mark_best ]  

  def new
    @answer = @question.answers.new
    @answer.links.new
  end

  def show
    
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user.is_author_of?(@answer)
      @answer.destroy
    else
      redirect_to question_path(@answer.question)
    end
    @question = @answer.question
  end

  def mark_best
    @answer.mark_as_best
    @question = @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
