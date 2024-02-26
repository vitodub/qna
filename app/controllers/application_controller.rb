class ApplicationController < ActionController::Base
  before_action :gon_user

  private

  def gon_user
    gon.user_id = current_user.present? ? current_user.id : nil
  end
end
