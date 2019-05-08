class CheckInsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_check_in, only: [:show, :edit, :update, :destroy]

  # GET /check_in
  # GET /check_in.json
  def index
    @check_in = CheckIn.all
  end

  # GET /check_in/1
  # GET /check_in/1.json
  def show
  end

  # GET /check_in/new
  def new
    @check_in = CheckIn.new
  end

  # GET /check_in/1/edit
  def edit
  end

  # POST /check_in
  # POST /check_in.json
  def create
    @check_in = CheckIn.new(check_in_params)

    respond_to do |format|
      if @check_in.save
        format.html { redirect_to @check_in, notice: 'Check in was successfully created.' }
        format.json { render :show, status: :created, location: @check_in }
      else
        format.html { render :new }
        format.json { render json: @check_in.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /check_in/1
  # PATCH/PUT /check_in/1.json
  def update
    respond_to do |format|
      if @check_in.update(check_in_params)
        format.html { redirect_to @check_in, notice: 'Check in was successfully updated.' }
        format.json { render :show, status: :ok, location: @check_in }
      else
        format.html { render :edit }
        format.json { render json: @check_in.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_in/1
  # DELETE /check_in/1.json
  def destroy
    @check_in.destroy
    respond_to do |format|
      format.html { redirect_to check_in_index_url, notice: 'Check in was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
def ischecked
    
    id = params[:id]
    puts id

    @checked = false


    begin
       lastCheck = CheckIn.where(student_id = id).last
    rescue
      lastCheck = nil
    end
        puts lastCheck


    if not lastCheck.nil? and lastCheck.checkout
      @checked = true
    end

    render json: @checked
  end
  def check
    id = params[:id]
    puts "EN EL CHEKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK"

    @checked = false


    begin
       lastCheck = CheckIn.where(student_id = id).last
    rescue
      lastCheck = nil
    end
        
    
    #is checkin
    if lastCheck.nil? or lastCheck.checkout
      puts 'is checkin'
      puts CheckIn.new
      newCheckin = CheckIn.new(student_id: id, check_in: Time.new , check_out: nil)
      puts newCheckin
      newCheckin.save
    #is checkout
    else 
      puts 'is checkout'
      lastCheck.check_out= Date.now
      puts 'was checkout'
      lastCheck.save
      puts 'was checkout'
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check_in
      @check_in = CheckIn.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def check_in_params
      params.require(:check_in).permit(:student_id, :check_in, :check_out)
    end
end
