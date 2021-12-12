def get_data
  array = []
  File.open(ARGV[0]).each do |line|
    pos = 0
    new_line = {}
    line.gsub("\n", "").split("").each do |num|
      new_line[:"#{pos}"] = [num.to_i, false, 0]
      pos += 1
    end
    array << new_line
  end
  return array
end

def intial_setup
  data = get_data
  low_points = []
  iterations = 0
  fill_ticker = 1

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

        nearest_spots = []
        if data[iterations][position][0] != 9
          nearest_spots << data[iterations][:"#{position.to_s.to_i - 1}"]
          nearest_spots << data[iterations+1][:"#{position.to_s.to_i - 1}"]
          nearest_spots << data[iterations][:"#{position}"]
          nearest_spots << data[iterations+1][:"#{position.to_s.to_i + 1}"]
          nearest_spots << data[iterations][:"#{position.to_s.to_i + 1}"]

          nearest_spots.map! do |spot|
            if spot == nil
              spot = [nil, nil, nil]
            elsif spot[0] == 9
              spot = [nil, nil, nil]
            else
              spot
            end
          end

          if value[0] < for_min.min
            value[1] = true
            low_points << value[0]
          end

          if nearest_spots[0][0] == nil && nearest_spots[2][0] == nil
            nearest_spots[1] = [nil, nil, nil]
          end

          if nearest_spots[2][0] == nil && nearest_spots[4][0] == nil
            nearest_spots[3] = [nil, nil, nil]
          end

          nearest_spots.map! do |spot|
            if spot == [nil, nil, nil]
            else
              spot[2]
            end
          end

          if nearest_spots.compact.any?{|ticker| ticker > 0}
            value[2] = nearest_spots.compact[0]
          else
            value[2] = fill_ticker
            fill_ticker += 1
          end
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

        nearest_spots = []
        if data[iterations][position][0] != 9
          nearest_spots << data[iterations-1][:"#{position.to_s.to_i - 1}"]
          nearest_spots << data[iterations][:"#{position.to_s.to_i - 1}"]
          nearest_spots << data[iterations-1][:"#{position}"]
          nearest_spots << data[iterations-1][:"#{position.to_s.to_i + 1}"]
          nearest_spots << data[iterations][:"#{position.to_s.to_i + 1}"]

          nearest_spots.map! do |spot|
            if spot == nil
              spot = [nil, nil, nil]
            elsif spot[0] == 9
              spot = [nil, nil, nil]
            else
              spot
            end
          end

          if nearest_spots[1][0] == nil && nearest_spots[2][0] == nil
            nearest_spots[0] = [nil, nil, nil]
          end

          if nearest_spots[2][0] == nil && nearest_spots[4][0] == nil
            nearest_spots[3] = [nil, nil, nil]
          end

          nearest_spots.map! do |spot|
            if spot == [nil, nil, nil]
            else
              spot[2]
            end
          end

          check_same_basin = nearest_spots.uniq.compact - [0]
          if check_same_basin.count > 1
            iterate = 0
            data.each do |entry|
              x = entry.select {|key, value| value[2] == check_same_basin[1]}
              x.map {|key, value| value[2] = check_same_basin[0]}
            end
          end

          if nearest_spots.compact.any?{|ticker| ticker > 0}
            value[2] = nearest_spots.compact[0]
          else
            value[2] = fill_ticker
            fill_ticker += 1
          end
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

        nearest_spots = []
        if data[iterations][position][0] != 9
          nearest_spots << data[iterations-1][:"#{position.to_s.to_i - 1}"]
          nearest_spots << data[iterations][:"#{position.to_s.to_i - 1}"]
          nearest_spots << data[iterations-1][:"#{position}"]
          nearest_spots << data[iterations-1][:"#{position.to_s.to_i + 1}"]
          nearest_spots << data[iterations][:"#{position.to_s.to_i + 1}"]

          nearest_spots.map! do |spot|
            if spot == nil
              spot = [nil, nil, nil]
            elsif spot[0] == 9
              spot = [nil, nil, nil]
            else
              spot
            end
          end

          if nearest_spots[1][0] == nil && nearest_spots[2][0] == nil
            nearest_spots[0] = [nil, nil, nil]
          end

          if nearest_spots[2][0] == nil && nearest_spots[4][0] == nil
            nearest_spots[3] = [nil, nil, nil]
          end

          nearest_spots.map! do |spot|
            if spot == [nil, nil, nil]
            else
              spot[2]
            end
          end

          ##################!!!!!!!!!!!!!!!!!
          check_same_basin = nearest_spots.uniq.compact - [0]
          if check_same_basin.count > 1
            iterate = 0
            data.each do |entry|
              x = entry.select {|key, value| value[2] == check_same_basin[1]}
              x.map {|key, value| value[2] = check_same_basin[0]}
            end
          end

          if nearest_spots.compact.any?{|ticker| ticker > 0}
            value[2] = nearest_spots.compact[0]
          else
            value[2] = fill_ticker
            fill_ticker += 1
          end
        end

      end
    end
    iterations += 1
  end

  iterations = 0
  grouped_basins = {}
  largest = []
  data.last.each {|entry| largest << entry[1][2]}
  (1..largest.max).each {|num| grouped_basins[:"#{num}"] = 0}
  data.each do |row|
    row.each do |point|
      if point[1][2] != 0
        grouped_basins[:"#{point[1][2]}"] += 1
      end
    end
    iterations += 1
  end

  largest_basins = grouped_basins.values.max(3)
  multiplied_basins = largest_basins.inject(:*)
  risk = low_points.map {|point| point+1}
  puts "the sum of all risk is #{risk.sum}"
  puts "the sum of the 3 largest basins is #{multiplied_basins}"
end



puts intial_setup
