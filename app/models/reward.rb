class Reward < ApplicationRecord
  MINIMUM_REWARD_NAME_LENGTH = 5

  belongs_to :rewardable, polymorphic: true
  has_one :reward_achievement, dependent: :destroy

  has_one_attached :file

  validates :name, :file, presence: true
  validate :reward_name, :reward_content_type

  private

  def reward_name
    errors.add(:name, "Reward name is too short") if name && name.length < MINIMUM_REWARD_NAME_LENGTH
  end

  def reward_content_type
    errors.add(:base, "Only images are allowed") if file && file.content_type !~ /\Aimage/
  end
end
