def get_data
  array = []
  File.open(ARGV[0]).each do |line|
    pos = 0
    new_line = {}
    line.gsub("\n", "").split("").each do |num|
      new_line[:"#{pos}"] = [num.to_i, false]
      pos += 1
    end
    array << new_line
  end
  return array
end

def something
  data = get_data
  low_points = []
  iterations = 0
  data.each do |line|
    line.each do |position, value|
      if iterations == 0
        values = []
        values << line[:"#{position.to_s.to_i - 1}"]
        values << line[:"#{position.to_s.to_i + 1}"]
        values << data[iterations+1][position]
        for_min = values.compact.map {|value| value[0]}
        if value[0] < for_min.min
          value[1] = true
          low_points << value[0]
        end

      elsif iterations == data.count-1
        values = []
        values << data[iterations-1][position]
        values << line[:"#{position.to_s.to_i - 1}"]
        values << line[:"#{position.to_s.to_i + 1}"]
        for_min = values.compact.map {|value| value[0]}
        if value[0] < for_min.min
          value[1] = true
          low_points << value[0]
        end

      else
        values = []
        values << data[iterations-1][position]
        values << line[:"#{position.to_s.to_i - 1}"]
        values << line[:"#{position.to_s.to_i + 1}"]
        values << data[iterations+1][position]
        for_min = values.compact.map {|value| value[0]}
        if value[0] < for_min.min
          value[1] = true
          low_points << value[0]
        end
      end
    end
    iterations += 1
  end
  risk = low_points.map {|point| point+1}
  puts "the sum of all risk levels is #{risk.sum}"
end


puts something
