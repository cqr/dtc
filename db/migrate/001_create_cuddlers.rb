class CreateCuddlers < ActiveRecord::Migration
  def self.up
    create_table :cuddlers do |t|
      t.timestamps
      t.float :lat
      t.float :long
    end
  end
  
  def self.down
    drop_table :cuddlers
  end
end