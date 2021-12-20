def get_data
  grid = {}
  row = 0
  column = 0
  add = 0
  add_down = 0

  5.times do
    File.open(ARGV[0]).map do |line|

      5.times do
        line.gsub("\n", "").split("").each do |number|
          if number.to_i+add+add_down >= 10
            grid[:"#{row}_#{column}"] = [(number.to_i+add+add_down+1)%10, nil]
          else
            grid[:"#{row}_#{column}"] = [number.to_i+add+add_down, nil]
          end
          column += 1
        end
        add += 1
      end
      row += 1
      column = 0
      add = 0
    end
    add_down += 1
    add = 0
  end
  grid
end

$data = get_data

def find_path
  find_lowest_risk_route($data)
  risk = $data.to_a.last[1][1] - $data.to_a.first[1][1]
  puts "Lowest total risk is #{risk}"
end

def find_lowest_risk_route(grid)
  grid.map do |position|
    nearby = get_nearest_spots(position, grid)
    nearby = nearby.select {|neighbor| neighbor[1][1] != nil}
    nearby = [[:"nil", ["0", 0]]] if nearby.empty?
    position[1][1] = position[1][0].to_i + nearby.map {|key, value| value[1]}.min
  end
end

def get_nearest_spots(spot, grid)
  paths = []
  key = spot[0].to_s.split("_").map {|number| number.to_i}
  paths << grid.assoc(:"#{key[0]}_#{key[1]-1}")
  paths << grid.assoc(:"#{key[0]-1}_#{key[1]}")
  paths.compact
end

find_path
