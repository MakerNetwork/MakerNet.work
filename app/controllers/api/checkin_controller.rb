class API::CheckinController < API::ApiController
	skip_before_action :verify_authenticity_token
    
	def ischecked
		
		id = params[:id]
		puts id

		@checked = false


		begin
		   lastCheck = CheckIn.where(student_id = id).last
		rescue
			lastCheck = nil
		end
        puts lastcheck


		if not lastCheck.nil? and lastCheck.checkout
			@checked = true
		end

		render json: @checked
	end
	def check
		id = params[:id]
		puts id

		@checked = false


		begin
		   lastCheck = CheckIn.where(student_id = id).last
		rescue
			lastCheck = nil
		end
        
		
		#is checkin
		if lastCheck.nil? or lastCheck.checkout
			puts 'is checkin'
			puts Checkin.new
			newCheckin = CheckIn.new
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
end