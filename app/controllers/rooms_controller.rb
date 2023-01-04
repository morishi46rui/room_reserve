class RoomsController < ApplicationController

  protect_from_forgery except: [:upload_photo]
  before_action :set_room, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]


  def index
    @rooms = current_user.rooms
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.create(room_params)
    if @room.save
      redirect_to listing_room_path(@room), notice: "保存しました。"
    else
      flash[:alert] = "未入力の項目があります。"
      render :new
    end
  end


  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
  end

  def amenities
  end

  def location
  end

  def update
    new_params = room_params
    new_params = room_params.merge(active: true) if is_ready_room

    if @room.update(new_params)
      flash[:notice] = "保存しました。"
    else
      flash[:alert] = "問題が発生しました。"
    end
    redirect_back(fallback_location: request.referer)
  end

  def upload_photo
  end
  
  def delete_photo
  end

  private

    def room_params
      params.require(:room).permit(:image, :listing_name, :summary, :price, :address, :active)
    end

    def set_room
      @room = Room.find(params[:id])
    end

end
