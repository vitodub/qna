class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  after_action :publish_question, only: [:create]

  include Voted
  include Commented

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers.sort_by_best
    @answer = @question.answers.new
    @answer.links.new
    gon.question_id = @question.id
  end

  def new
    @question = Question.new
    @question.links.new # .build
    @question.reward = Reward.new
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
      @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
    @comment = Comment.new
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: [:name, :url],
      reward_attributes: [:name, :file]
      )
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions_channel',
                                  ApplicationController.render(
                                    partial: 'questions/question_header',
                                    locals: { question: @question }
                                  )
  end
end
