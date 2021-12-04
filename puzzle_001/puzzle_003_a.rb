require_relative './data/depths'
require_relative './data/positions'
require_relative './data/binary'

def organize_binary
  results = {}

  total_positions = binary.first.length

  total_positions.times do
    results[:"pos_#{total_positions}_0"] = 0
    results[:"pos_#{total_positions}_1"] = 0
    total_positions -= 1
  end

  binary.each do |number|
    total = number.length

    total.times do

      if number[total-1] == '0'
        results[:"pos_#{total}_0"] += 1
        total -= 1
      else
        results[:"pos_#{total}_1"] += 1
        total -= 1
      end

    end
  end

  return results
end

def find_power_consumption
  gamma = ''
  epsilon = ''

  total_length = organize_binary.length/2
  times = 1

  total_length.times do
    total_0 = organize_binary[:"pos_#{times}_0"]
    total_1 = organize_binary[:"pos_#{times}_1"]
    times += 1

    if total_0 > total_1
      gamma << '0'
      epsilon << '1'
    else
      gamma << '1'
      epsilon << '0'
    end

  end
  power = gamma.to_i(2)*epsilon.to_i(2)

  puts "gamma: #{gamma} || #{gamma.to_i(2)}"
  puts "epsilon: #{epsilon} || #{epsilon.to_i(2)}"
  puts "Submarine Power Consumption = #{power}"
end

def count_binary(binary, results, bit_position)
  total = binary.count
  results[:"pos_#{bit_position}_0"] = 0
  results[:"pos_#{bit_position}_1"] = 0

  binary.each do |number|
    if number[bit_position-1] == '0'
      results[:"pos_#{bit_position}_0"] += 1
    else
      results[:"pos_#{bit_position}_1"] += 1
    end

  end
  return results
end

def oxygen_generator_rating
  oxygen_hash = {}
  oxygen = binary
  bit_position = 1

  until oxygen.count == 1 do
    count_binary(oxygen, oxygen_hash, bit_position)
    pos_0 = oxygen_hash[:"pos_#{bit_position}_0"]
    pos_1 = oxygen_hash[:"pos_#{bit_position}_1"]
    if pos_1 >= pos_0
      oxygen.select! do |value|
        value[bit_position-1] == '1'
      end
    elsif pos_0 > pos_1
      oxygen.select! do |value|
        value[bit_position-1] == '0'
      end
    end

    bit_position += 1
  end # end of UNTIL LOOP
  puts "oxygen = #{oxygen.first} || #{oxygen.first.to_i(2)}"
  return oxygen.first
end

def co2_scrubber_rating
  co2_hash = {}
  co2 = binary
  bit_position = 1

  until co2.count == 1 do
    count_binary(co2, co2_hash, bit_position)
    pos_0 = co2_hash[:"pos_#{bit_position}_0"]
    pos_1 = co2_hash[:"pos_#{bit_position}_1"]

    if pos_1 < pos_0
      co2.select! do |value|
        value[bit_position-1] == '1'
      end
    elsif pos_0 <= pos_1
      co2.select! do |value|
        value[bit_position-1] == '0'
      end
    end

    bit_position += 1
  end # end of UNTIL LOOP

  puts "co2 = #{co2.first} || #{co2.first.to_i(2)}"
  return co2.first
end

def get_life_support_rating
  co2 = co2_scrubber_rating
  oxygen = oxygen_generator_rating
  puts "Life Support Rating = #{co2.to_i(2)*oxygen.to_i(2)}"
end


def find_direction
  horizontal_position = positions[:forward]
  depth = positions[:down] - positions[:up]
  multiply = horizontal_position * depth

  puts "horizontal_position: #{horizontal_position}"
  puts "depth: #{depth}"
  puts "multiply: #{multiply}"
end

def move_submarine

  horizontal_position = 0
  depth = 0
  aim = 0

  File.open(ARGV[0]).each do |line|
    direction = line.split[0]
    amount = line.split[1].to_i
    if direction == 'forward'
      horizontal_position += amount
      depth += (amount * aim)
    elsif direction == 'down'
      aim += amount
    else
      aim -= amount
    end
  end

  multiply = horizontal_position * depth

  puts "horizontal_position: #{horizontal_position}"
  puts "depth: #{depth}"
  puts "aim: #{aim}"
  puts "multiply: #{multiply}"
end

puts move_submarine

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

def group_depths(depths)
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

  return grouped
end

puts oxygen_generator_rating
puts co2_scrubber_rating
puts get_life_support_rating
