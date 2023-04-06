class AnswersController < ApplicationController
  def new
    
  end

  def create
    @answer = question.answers.new(answer_params)
    
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question
end
