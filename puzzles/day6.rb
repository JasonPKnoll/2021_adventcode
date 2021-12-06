def get_data
  array = nil
  File.open(ARGV[0]).each do |line|
    array = line.gsub("\n", "").split(",").map {|value| value.to_i}
  end
  return array
end

def create_fish(days)
  sorted_fish = {}
  (0..8).each {|num| sorted_fish[:"f_#{num}"] = 0}
  get_data.each {|fish| sorted_fish[:"f_#{fish}"] += 1}

  days.times do
    new_fish = {}
    (0..8).each {|num| new_fish[:"f_#{num}"] = 0}
    sorted_fish = sorted_fish.each do |type, amount|
      pod = type.to_s.gsub("f_", "").to_i
      if pod == 0
        new_fish[:f_8] += amount
        new_fish[:f_6] += amount
      else
        new_fish[:"f_#{pod-1}"] += amount
      end
    end
    sorted_fish = new_fish
  end
  puts "There would be #{sorted_fish.values.sum} fish after #{days} days."
end

create_fish(18)
create_fish(80)
create_fish(256)
