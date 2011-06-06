module MapsHelper
  
  def distance_in_meters(distance)
    number_with_delimiter(number_with_precision(distance, :precision => 1)) + " meters" if distance
  end
  
  
  def human_distance(distance)
    # distance is in meters, so convert first o feet
    return unless distance
    miles = distance / 1609.344
    number_with_delimiter(number_with_precision(miles, :precision => 1)) + " miles" if distance
    
  end
  
  def heading(h)
    number_with_precision(h, :precision => 0) + "&deg;".html_safe if h
  end
  
  def heading_name(h)
    return unless h.present?
    h = h + 360 if h < -23
    i = h.to_i
    label = {
      (-23..23) => 'N',
      (23..68) => 'NE',
      (68..113) => 'E',
      (113..157) => 'SE',
      (157..203) => 'S',
      (203..248) => 'SW',
      (248..293) => 'W',
      (293..338) => 'NW',
      (338..360) => 'N'
    }.detect { |pair| pair.first.cover?(i) }
    label ? label.last : '?'
  end
  
end
