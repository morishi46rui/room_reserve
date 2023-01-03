class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def create
    room = Room.find(params[:room_id])

    if current_user == room.user
      flash[:alert] = "オーナーが予約することはできません。"
    elsif current_user.stripe_id.blank?
      flash[:alert] = "予約する前にクレジットカードを登録する必要があります。"
      return redirect_to settings_payment_path
    else

      start_date = Date.parse(reservation_params[:start_date])
      end_date = Date.parse(reservation_params[:end_date])
      days = (end_date - start_date).to_i + 1
      if days < 2
        flash[:alert] = "宿泊日数が１泊以上でなければ予約することはできません。"
      else
      @reservation = current_user.reservations.build(reservation_params)
      @reservation.room = room
      @reservation.price = room.price
      @reservation.total = room.price * days
      @reservation.save
      flash[:notice] = "予約が完了しました。"
      end
    end
      redirect_to room
  end

  def your_trips
    @trips = current_user.reservations.order(start_date: :asc)
  end

  def your_reservations
    @rooms = current_user.rooms
  end

  private
  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date)
  end

  def charge(room, reservation)
    host_amount = (reservation.total * 0.8).to_i 
    if !reservation.user.stripe_id.blank?
      customer = Stripe::Customer.retrieve(reservation.user.stripe_id)
      charge = Stripe::Charge.create(
        :customer => customer.id,
        :amount => reservation.total,
        :description => room.listing_name,
        :currency => "jpy",
        transfer_data: {
          amount: host_amount, 
          destination: room.user.merchant_id, 
        },
      )

      if charge
        reservation.Approved!
        flash[:notice] = "お支払い手続きが完了し、ご予約されました。お越しをお待ちしております！"
      else
        reservation.Declined!
        flash[:notice] = "お支払い手続きができません。予約ができませんでした。"
      end
    end
  rescue Stripe::CardError => e
    reservation.declined!
    flash[:alert] = e.message
  end

end