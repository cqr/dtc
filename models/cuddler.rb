class Cuddler < ActiveRecord::Base
  
  validates :lat, :long, :presence => true
  
  attr_accessible :lat, :long
  
  def self.with_distance(lat, lng)
    select("CONVERT(ACOS(COS(RADIANS(lat)) * COS(RADIANS(`long`)) * COS(RADIANS(#{lat})) * COS(RADIANS(#{lng})) + COS(RADIANS(lat)) * SIN(RADIANS(`long`)) * COS(RADIANS(#{lat})) * SIN(RADIANS(#{lng})) + SIN(RADIANS(#{lat}))*sin(RADIANS(lat))) * 3963.1, DECIMAL(10,2)) as distance")
  end
  
  def self.within(distance, options = {})
    with_distance(options[:of][:lat], options[:of][:lng]).having('distance <= ?', distance).order('distance DESC')
  end
    
end