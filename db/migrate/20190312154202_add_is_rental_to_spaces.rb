class AddIsRentalToSpaces < ActiveRecord::Migration
  def change
  	reversible do |directive|
	  	change_table :profiles do |t| 
    	    spaces = Space.all

  	      directive.up do
    			add_column :spaces, :is_rental, :boolean
    			spaces.each do |space|
    				space.is_rental = false
    				space.save
    			end
			end

			directive.down do
				remove_column :spaces, :is_rental, :boolean
			end
  		end
  	end
  end
end
