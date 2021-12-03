
require_relative 'depths'

def find_increases(depths)
  count = 0
  last_depth = nil
  depths.each do |depth|
    if last_depth == nil
      last_depth = depth
    elsif depth > last_depth
      count += 1
      last_depth = depth
    else
      last_depth = depth
    end
  end
  return count
end

p find_increases(depths)
