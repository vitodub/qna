class Question < ApplicationRecord
  MINIMUM_REWARD_NAME_LENGTH = 3

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :user

  has_many_attached :files
  has_one_attached :reward

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true
  validate :reward_name_length
  validate :reward_content_type

  def reward_name_length
    if (reward.present? && reward_name.length < MINIMUM_REWARD_NAME_LENGTH)
      errors.add(:base, "Reward name is too short (minimum - #{MINIMUM_REWARD_NAME_LENGTH})")
    end
    errors.add(:base, "No reward selected") if reward_name.present? && reward.filename.nil?  
  end

  def reward_content_type
     errors.add(:base, "Only images are allowed") if reward.present? && reward.content_type !~ /\Aimage/
  end
end
