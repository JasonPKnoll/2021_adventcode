def get_data
  array = nil
  File.open(ARGV[0]).each do |line|
    array = line.gsub("\n", "").split(",").map {|value| value.to_i}
  end
  return array
end

def find_horizontal
  all_fuel = {}
  crabs = get_data
  (0..crabs.max).each do |num|
    fuel = crabs.map do |crab|
      (crab - num).abs
    end
    all_fuel[:"#{num}"] = [fuel.sum, "#{num}"]
  end
  return "The most fuel efficient position is #{all_fuel.values.min[1]}, which will cost the crabs #{all_fuel.values.min[0]} total fuel."
end

puts find_horizontal
