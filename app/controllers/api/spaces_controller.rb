class API::SpacesController < API::ApiController
  before_action :authenticate_user!, except: [:index, :show]
  respond_to :json

  def index
    @spaces = Space.includes(:space_image).friendly.where(:is_rental => params[:is_rental])
  end

  def show
    @space = Space.includes(:space_files, :projects).friendly.find(params[:id])
  end

  def create
    authorize Space
    @space = Space.new(space_params)
    if @space.save
      render :show, status: :created, location: @space
    else
      render json: @space.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize Space
    @space = get_space
    if @space.update(space_params)
      render :show, status: :ok, location: @space
    else
      render json: @space.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @space = get_space
    authorize @space
    @space.destroy
    head :no_content
  end
  def to_rental
    @space = get_space
    authorize @space
    if @space.update(is_rental: true)
        render :show, status: :ok, location: @space
    else
      render json: @space.errors, status: :unprocessable_entity
    end
  end

  private
    def get_space
      Space.friendly.find(params[:id])
    end

    def space_params
      params.require(:space).permit(:name, :description, :characteristics, :default_places, :disabled, :is_rental, space_image_attributes: [:attachment],
                                      space_files_attributes: [:id, :attachment, :_destroy])
    end
end
