module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.where(liked: true).count - votes.where(liked: false).count
  end
end
