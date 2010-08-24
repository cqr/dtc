class Cuddler < ActiveRecord::Base
  
  validates :lat, :long, :presence => true
  
  attr_accessible :lat, :long
  
  def self.with_distance(lat, lng)
    select("ACOS(COS(RADIANS(lat)) * COS(RADIANS(long)) * COS(RADIANS(#{lat})) * COS(RADIANS(#{lng})) + COS(RADIANS(lat)) * SIN(RADIANS(long)) * COS(RADIANS(#{lat})) * SIN(RADIANS(#{lng})) + SIN(RADIANS(#{lat}))*SIN(RADIANS(lat))) * 3963.1 as distance")
  end
  
  def self.within(distance, options = {})
    where("ACOS(COS(RADIANS(lat)) * COS(RADIANS(long)) * COS(RADIANS(#{options[:of][:lat]})) * COS(RADIANS(#{options[:of][:lng]})) + COS(RADIANS(lat)) * SIN(RADIANS(long)) * COS(RADIANS(#{options[:of][:lat]})) * SIN(RADIANS(#{options[:of][:lng]})) + SIN(RADIANS(#{options[:of][:lat]}))*SIN(RADIANS(lat))) * 3963.1 < ?", distance)
  end
    
end