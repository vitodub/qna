class CommentsController < ApplicationController
  before_action :find_comment, only: %i[destroy]

  authorize_resource

  def destroy
    perform_destroy(@comment)
  end

  private

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def perform_destroy(comment)
    comment.destroy
    respond = comment.as_json(only: %i[id commentable_id])
    respond['controller'] = 'comments_controller'
    respond['action'] = 'destroy'
    channel_id = @comment.commentable_type == 'Question' ? @comment.commentable.id : @comment.commentable.question.id
    ActionCable.server.broadcast "answers_channel_#{channel_id}", respond
  end
end
