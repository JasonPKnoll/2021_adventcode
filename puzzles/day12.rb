def get_data
  File.open(ARGV[0]).map {|line| line.gsub("\n", "").split("-")}
end


def find_total_paths
  data = get_data
  tunnels = map_caves(data)
  find_all_paths(tunnels)
end

def map_caves(data)
  tunnels = {}
  data.each do |set|
    create_tunnel(set[0], set[1], tunnels)
    create_tunnel(set[1], set[0], tunnels)
  end
  return tunnels
end

def create_tunnel(first, second, tunnels)
  if tunnels[:"#{first}"].nil?
    if first == first.upcase
      tunnels[:"#{first}"] = [[second] - ["start"]]
    else
      tunnels[:"#{first}"] = [[second] - ["start"]]
    end
  else
    tunnels[:"#{first}"][0] << second
  end
end

$solutions = []

def find_all_paths(tunnels)
  routes = ["start"]
  repeats_allowed = 2
  search(tunnels, routes, repeats_allowed)
  puts $solutions.count
end

def search(tunnels, route, repeats_allowed)

  if route.last == "end"
    $solutions << route
  else
    tunnels[:"#{route.last}"][0].each do |room|
      if route.count(room) < repeats_allowed || room != room.downcase
        if room == "start"
          next
        elsif route.count(room) == 1 && repeats_allowed == 2 && room == room.downcase
          search(tunnels, route + [room], 1)
        else
          search(tunnels, route + [room], repeats_allowed)
        end
      end
    end
  end
end

puts find_total_paths
