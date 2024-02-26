module Voted
  extend ActiveSupport::Concern

  def like
    set_votable_and_vote
    user_vote(true) unless @votable.user == current_user
  end

  def dislike
    set_votable_and_vote
    user_vote(false) unless @votable.user == current_user
  end

  private

  def set_votable_and_vote
    @votable = params[:table].classify.constantize.find(params[:id])
    @vote = @votable.votes.where(user: current_user).first
  end

  def user_vote(decision)
    if @vote.present?
      @vote.destroy
    else
      Vote.create(votable: @votable, user: current_user, liked: decision)
    end

    respond(decision)
  end

  def respond(decision)
    respond_to do |format|
      format.json do
        render json: { controller: 'voted', table: params[:table], id: @votable.id, rating: @votable.rating,
                       liked: @votable.votes.where(user: current_user).present? ? decision : nil }
      end
    end
  end
end
