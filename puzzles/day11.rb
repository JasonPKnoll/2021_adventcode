def get_data
  octopus_grid = {}
  row = "a"
  column = "1"
  File.open(ARGV[0]).each do |line|
    line.gsub("\n", "").split("").each do |num|
      octopus_grid[:"#{row}#{column}"] = [num.to_i, false]
      if column == '10'
        row = row.next
        column = "1"
      else
        column = column.next
      end
    end
  end
  return octopus_grid
end

def simulate_steps(steps)
  total_flashes = 0
  grid = get_data
  steps.times do
    increase(grid)
    flash = flashing(grid)
    grid = flash[0]
    total_flashes += flash[1]
    reset_flashing(grid)
  end
  puts "After #{steps} steps, the octopuses flashed a total of #{total_flashes} times."
end

def increase(grid)
  grid.map do |position, octopus|
    octopus[0] += 1
  end
end

def flashing(grid)
  total_flashes = 0
  new = grid.select {|position, octopus| octopus[0] >= 10 && octopus[1] == false}

  until new.count == 0
    flashing = grid.select do |position, octopus|
      octopus[0] >= 10 && octopus[1] == false
    end

    flashing.each do |position, octopus|
      octopus[1] = true
      total_flashes += 1
      nearby_keys = get_nearby_keys(position)
      grid.map do |position, octopus|
        if nearby_keys.any?(position)
          octopus[0] += 1
        end
      end
    end
    new = grid.select {|position, octopus| octopus[0] >= 10 && octopus[1] == false}
  end

  return [grid, total_flashes]
end

def reset_flashing(grid)
  grid.map do |position, octopus|
    if octopus[1] == true
      octopus[1] = false
      octopus[0] = 0
    end
  end
end

def get_nearby_keys(position)
  rows = ('a'..'j').map {|letter| letter}
  columns = ('1'..'10').map {|letter| letter}
  position = position.to_s.split("")
  if position.count > 2
    position = [position[0], position[1]+position[2]]
  end

  pos_r = rows.index(position[0])
  pos_c = columns.index(position[1])

  increment = 0
  nearby_keys = []

  3.times do
    column_assign = pos_c-1+increment
    unless rows[pos_r-1] == "j" || column_assign < 0 || column_assign > 10
      nearby_keys << "#{rows[pos_r-1]}#{columns[column_assign]}".to_sym
    end
    unless rows[pos_r+1] == "a" || column_assign < 0 || column_assign > 10
      nearby_keys << "#{rows[pos_r+1]}#{columns[column_assign]}".to_sym
    end
    increment += 1
  end

  if pos_c-1 > -1
    nearby_keys << "#{rows[pos_r]}#{columns[pos_c-1]}".to_sym
  end
  if pos_c+1 < 10
    nearby_keys << "#{rows[pos_r]}#{columns[pos_c+1]}".to_sym
  end
  return nearby_keys
end

puts simulate_steps(100)
