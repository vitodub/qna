class ApplicationController < ActionController::Base
  before_action :gon_user

  private

  def gon_user
    gon.user_id = current_user.present? ? current_user.id : nil
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end
end
