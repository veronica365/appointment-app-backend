class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:destroy]

  # GET /reservations
  def index
    @reservations = @current_user.reservations.includes(:motorcycle)
    render json: @reservations,
           include: [motorcycle: { only: %i[id model photo purchase_fee finance_fee amount_payable duration] }]
  end

  # POST /reservations
  def create
    @reservation = @current_user.reservations.build(reservation_params)

    if @reservation.save
      render json: @reservation, status: :created
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reservations/:id
  def destroy
    @reservation.destroy
    head :no_content
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:city, :date, :motorcycle_id)
  end
end
