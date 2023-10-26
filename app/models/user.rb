class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions
  has_many :answers
  has_many :reward_achievements, dependent: :destroy
  has_many :votes, dependent: :destroy

  def is_author_of?(obj)
    self.id == obj.user_id
  end
end
