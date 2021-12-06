def get_data
  array = nil
  File.open(ARGV[0]).each do |line|
    array = line.gsub("\n", "").split(",").map {|value| value.to_i}
  end
  return array
end

def create_fish(days)
  all_fish = get_data

  days.times do
    all_fish = all_fish.map do |fish|
      fish -= 1
      if fish == -1
        fish = 6
        all_fish << 9
      end
      fish
    end
  end

  puts "There would be #{all_fish.count} fish after #{days}."
end

# create_fish(18)
# create_fish(80)
create_fish(256)
