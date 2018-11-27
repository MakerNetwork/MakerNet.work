class AddFablabTypeToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :fablab_type, :string, null: true
  end
end
