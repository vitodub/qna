class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers.sort_by_best
    @answer = @question.answers.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new # .build
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
      @question.update(question_params) if current_user.is_author_of?(@question)
  end

  def destroy
    if current_user.is_author_of?(@question)
      @question.destroy

      redirect_to questions_path, notice: 'Your question was successfully deleted.'
    else
      redirect_to questions_path
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      :reward_name,
      files: [],
      links_attributes: [:name, :url]
      )
  end
end
