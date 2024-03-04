class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github yandex]

  has_many :questions
  has_many :answers
  has_many :reward_achievements, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def is_author_of?(obj)
    self.id == obj.user_id
  end
end
