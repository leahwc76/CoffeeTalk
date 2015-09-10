class CreateProfilesTable < ActiveRecord::Migration
  def change
  	create_table :profiles do |t|
  		t.integer :age
  		t.string :city
  		t.string :occupation
  		t.integer :user_id
  		t.timestamps null: false
  	end
  end
end
