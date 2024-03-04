class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :find_question, only: %i[ new create ]
  before_action :find_answer, only: %i[ edit update destroy mark_best ] 
  after_action :publish_answer, only: %i[ create ] 

  include Voted
  include Commented

  authorize_resource

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
    @comment = Comment.new
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
    @question = @answer.question
  end

  def mark_best
    @answer.mark_as_best
    assign_reward(@answer) if @answer.question.reward.present?
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
    @comment = Comment.new
  end

  def assign_reward(answer)
    reward = answer.question.reward
    if reward.reward_achievement.present?
      reward.reward_achievement.update(user: answer.user)
    else
      reward.reward_achievement = RewardAchievement.create(user: answer.user, reward: reward)
    end
  end

  def publish_answer
    return if @answer.errors.any?

    @response = publish_answer_json_response
    add_info_to_publish_answer
    ActionCable.server.broadcast "answers_channel_#{@question.id}", @response
  end

  def publish_answer_json_response
    @answer.as_json(
      except: %i[created_at updated_at],
      include: {
        links: { except: %i[created_at updated_at linkable_type linkable_id] },
        files: { except: %i[created_at updated_at record_type record_id blob_id] },
        user: { only: :email },
        question: { only: :user_id }
      }
    )
  end

  def add_info_to_publish_answer
    publish_answer_links
    publish_answer_files
    publish_answer_global
  end

  def publish_answer_links
    @response['links'].each do |item|
      link = Link.find_by(id: item['id'])
      if link.gist?
        item['gist?'] = link.gist?
        item['gist_id'] = link.gist_id
      end
    end
  end

  def publish_answer_files
    @response['files'].each do |item|
      attach = ActiveStorage::Attachment.find_by(id: item['id'])
      item['name'] = attach.filename.to_s
      item['url'] = Rails.application.routes.url_helpers.rails_blob_path(attach, only_path: true)
    end
  end

  def publish_answer_global
    @response['rating'] = @answer.rating
    @response['table'] = 'answers'
    @response['controller'] = 'answers_controller'
    @response['action'] = 'create'
  end
end
