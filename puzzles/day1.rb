def depths
  depths = []
  File.open(ARGV[0]).each do |line|
    depths << line.gsub("\n","").to_i
  end
  return depths
end

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

def group_depths
  grouped = []
  rolling_sum = []
  passes = 0
  depths.each do |depth|

    if rolling_sum.count == 2 && passes == 0
      rolling_sum << depth
      total = rolling_sum.sum
      grouped << total
      passes += 1

    elsif rolling_sum.count < 3
      rolling_sum << depth

    else
      rolling_sum << depth
      rolling_sum.shift(1)
      total = rolling_sum.sum
      grouped << total

    end
  end

  find_increases(grouped)
end

puts "Total increases for standard depths: #{find_increases(depths)}"
puts "Total increases for sliding window depths: #{group_depths}"
