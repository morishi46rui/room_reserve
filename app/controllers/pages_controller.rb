class PagesController < ApplicationController

  before_action :search

  def home
    @rooms = Room.where(active: true).limit(3)
  end



  def search
    @q = Room.ransack(params[:q])
    @rooms = @q.result(distinct: true)
  end

end
