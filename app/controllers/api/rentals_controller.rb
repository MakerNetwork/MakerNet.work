  class API::RentalsController < API::ApiController
  before_action :authenticate_user!, except: [:index]

  def index
    puts "1"
    @rentals = Rental.includes(:plan_file)
    @rentals = @rentals.where(group_id: params[:group_id]) if params[:group_id]
    render :index
  end

  def new 
    @rentals = Rental.new

  end

  def show
     puts "RENTALS SHOW METHOD CONTROLLER"
    @rental = Rental.find(params[:id])
  end

  def create
       puts "RENTALS CREATE METHOD CONTROLLER"
    authorize :admin
 
    begin
      if rental_params[:type] and rental_params[:type] == 'PartnerRental'

        partner = User.find(params[:rental][:partner_id])

        if rental_params[:group_id] == 'all'
          rentals = PartnerRental.create_for_all_groups(rental_params)
          if rentals
            rentals.each { |rental| partner.add_role :partner, rental }
            render json: { rental_ids: rentals.map(&:id) }, status: :created
          else
            render status: :unprocessable_entity
          end

        else
          @rental = PartnerRental.new(rental_params)
          if @rental.save
            partner.add_role :partner, @rental
            render :show, status: :created
          else
            render json: @rental.errors, status: :unprocessable_entity
          end
        end
      else
        if rental_params[:group_id] == 'all'
          rentals = Rental.create_for_all_groups(rental_params)
          if rentals
            render json: { rental_ids: rentals.map(&:id) }, status: :created
          else
            render status: :unprocessable_entity
          end
        else
          @rental = Rental.new(rental_params)
          if @rental.save
            render :show, status: :created, location: @rental
          else
            render json: @rental.errors, status: :unprocessable_entity
          end
        end
      end
    rescue Stripe::InvalidRequestError => e
      render json: {error: e.message}, status: :unprocessable_entity
    end
  end

  def update
    puts "UPDATE RENTAL MERTHOD CONTROLLER"
    @rental = Rental.find(params[:id])
    authorize @rental
    if @rental.update(rental_params)
      render :show, status: :ok
    else
      render json: @rental.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @rental = Rental.find(params[:id])
    authorize @rental
    @rental.destroy
    head :no_content
  end

  private
    def rental_params
      puts "2"
      if @parameters
        @parameters
      else
        @parameters = params
        @parameters[:rental][:amount] = @parameters[:rental][:amount].to_f * 100.0 if @parameters[:rental][:amount]
        @parameters[:rental][:prices_attributes] = @parameters[:rental][:prices_attributes].map do |price|
          { amount: price[:amount].to_f * 100.0, id: price[:id] }
        end if @parameters[:rental][:prices_attributes]

        @parameters = @parameters.require(:rental).permit(:base_name, :type, :group_id, :amount, :interval, :interval_count, :is_rolling,
            :training_credit_nb, :ui_weight, :disabled,
            rental_file_attributes: [:id, :attachment, :_destroy],
            prices_attributes: [:id, :amount]
        )
      end
    end
end
