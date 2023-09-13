class LinksController < ApplicationController
  def destroy
    @link = Link.find(params[:id])
    @resource = @link.linkable
    
    if @resource.user == current_user
      @link.destroy
    else
      redirect_to questions_path, notice: "You are not be able to perform this action."
    end
  end
end
