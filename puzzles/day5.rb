def get_entries
  all_entries = []
  File.open(ARGV[0]).each do |line|
    array = line.gsub("\n", "").gsub("->", "").gsub("  ",",").split(",")
    array.map! {|entry| entry.to_i}
    all_entries << Entry.new(array)
  end
  return all_entries
end

def get_board(number)
  board = {}
  row = 0
  column = 0

  number.times do
    until column == number
      board[:"r#{row}_c#{column}"] = 0
      column += 1
    end
    row += 1
    column = 0
  end
  return board
end

class Entry
  attr_reader :points

  def initialize(data)
    @points = get_all_points(data)
  end

  def get_all_points(data)
    points = []
    x = [data[0], data[1]]
    y = [data[2], data[3]]
    if x[0] - y[0] != 0 && x[1] - y[1] == 0
      array = get_points(x[0], y[0])
      array.each do |point|
        points << [point, x[1]]
      end
    elsif x[1] - y[1] != 0 && x[0] - y[0] == 0
      array = get_points(x[1], y[1])
      array.each do |point|
        points << [x[0], point]
      end
    elsif (x[0] - y[0]).abs - (x[1] - y[1]).abs == 0
      sorted = [[x[0], x[1]], [y[0], y[1]]].sort
      diff = (sorted[1][0] - sorted[0][0]).abs + 1
      count = 0
      if sorted[0][1] < sorted[1][1]
        diff.times do
          points << [sorted[0][0] + count, sorted[0][1] + count]
          count += 1
        end
      else
        diff.times do
          points << [sorted[0][0] + count, sorted[0][1] - count]
          count += 1
        end
      end
    end

    return points
  end

  def get_points(p1, p2)
    sorted = [p1, p2].sort
    diff = (sorted[1] - sorted[0]) + 1
    count = 0
    points = []
    diff.times do
      points << sorted[0] + count
      count += 1
    end
    return points
  end

end

def plot_points
  entries = get_entries
  if entries.count <= 20
    board = get_board(10)
  else
    board = get_board(1000)
  end
  entries.each do |entry|
    entry.points.each do |point|
      board[:"r#{point[0]}_c#{point[1]}"] += 1
    end
  end

  overlap = 0
  board.each do |key, value|
    if value >= 2
      overlap += 1
    end
  end
  puts "Total Points: #{overlap}"
end

puts plot_points
