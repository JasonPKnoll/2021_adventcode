
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
  puts "Depth * Horizontal Position: #{multiply}"
end

move_submarine
