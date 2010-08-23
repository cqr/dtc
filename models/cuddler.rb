class Cuddler < ActiveRecord::Base
  
  
  def self.with_distance(lat, lng)
    select("cuddlers.*, @a := SQRT(pow(SIN((cuddlers.lat - #{lat})/2), 2) + COS(cuddlers.lat) * COS(#{lat}) * pow(SIN((cuddlers.long - #{lng})/2), 2)), 7912 * ATAN2(SQRT(@a), SQRT(1-@a)) as distance")
  end
  
  def self.within(distance, options = {})
    with_distance(options[:of][:lat], options[:of][:lng]).having('distance <= ?', distance)
  end
    
end