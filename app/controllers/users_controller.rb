class UsersController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def rewards
    @reward_achievements = current_user.reward_achievements
  end
end
