class UpdateLatAndLongColumns < ActiveRecord::Migration
  def self.up
    change_column :cuddlers, :lat, :decimal, :scale => 7, :precision => 10
    change_column :cuddlers, :long, :decimal, :scale => 7, :precision =>10
  end
  
  def self.down
    change_column :cuddlers, :lat, :float
    change_column :cuddlers, :long, :float
  end
end