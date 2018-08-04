class AddTimesController < ApplicationController
  def edit
  	@issue = Issue.find_by id: params[:id]
  end
end
