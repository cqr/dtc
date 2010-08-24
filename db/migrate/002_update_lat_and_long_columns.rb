class UpdateLatAndLongColumns < ActiveRecord::Migration
  def self.up
    change_column :cuddlers, :lat, :decimal, :scale => 14, :precision =>  17
    change_column :cuddlers, :long, :decimal, :scale => 14, :precision => 17
  end
  
  def self.down
    change_column :cuddlers, :lat, :float
    change_column :cuddlers, :long, :float
  end
end