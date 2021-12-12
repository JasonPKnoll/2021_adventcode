def get_data
  array = []
  File.open(ARGV[0]).each do |line|
    array << line.gsub("\n", "").split("")
  end
  return array
end

def find_char
  data = get_data
  bad_values = []
  incomplete = []
  back_char = [")", "]", "}", ">"]

  data.each do |line|
    pair_tracker = 1
    delete = []
    queue = []
    line_check = []
    line.each_with_index do |character, index|
      if back_char.any?(character)
        opposite = find_opposite(character)
        if line_check[index-1][0] == opposite
          line_check[index-1][2] = "delete"
          line_check << [character, index, "delete"]
        else
          line_check << [character, index, "waiting"]
        end
      else
        line_check << [character, index, "waiting"]
      end
    end

    check = 1
    until check == 0
      line_check = set_queue(line_check)
      if line_check.select{|values| values[2] == "delete"}.count != 0
        line_check = delete_values(line_check)
        line_check = check_values(line_check)
        if line_check[0].length == 1
          bad_values << line_check
          check = 0
        end
      else
        incomplete << line_check
        check = 0
      end
    end
  end
  points = tally_points(bad_values)
  puts "total points for syntax errors = #{points.sum}"
end

def tally_points(bad_values)
  bad_values.map! do |value|
    index = [")","]","}",">"].index(value[1])
    [3,57,1197,25137][index]
  end
end

def check_values(line_check)
  position = 0
  line_check.map do |value|
    if value[2] == "queue" && ["(","[","{","<"].any?(value[0])
      opposite = find_opposite(value[0])
      next_value = line_check[position+1]
      if next_value.nil?
        next_value = [nil, nil, nil]
      end

      if [")", "]", "}", ">"].any?(next_value[0])
        if next_value[0] == opposite
          value[2] = "delete"
          line_check[position+1][2] = "delete"
        else
          return  [opposite, next_value[0]]
        end
      elsif ["(","[","{","<"].any?(next_value[0])
        value[2] = "incomplete"
        line_check[position+1][2] = "incomplete"
      elsif next_value[0].nil?
        value[2] = "incomplete"
      end
    else
    end
    position += 1
  end
  return line_check
end

def set_queue(line_check)
  position = 0
  pairs = 0
  line_check.map do |value|
    last_position = line_check[position-1]
    next_position = line_check[position+1]

    if next_position.nil?
      next_position = [nil, nil, nil]
    end

    if value[2] == "waiting"
      #WORKING#
      if next_position[2] == "delete"
        forward_check_position = position+1
        next_position = line_check[forward_check_position]

        if next_position.nil?
          next_position = [nil, nil, nil]
        end

        while next_position[2] == "delete"
          next_position = line_check[forward_check_position]
          if next_position.nil?
            next_position = [nil, nil, nil]
          end
          forward_check_position += 1
        end

        if ["(","[","{","<"].any?(next_position[0]) || next_position[0].nil?
        else
          value[2] = "queue"
          pairs += 1
        end

      elsif last_position[2] == "delete"
        if ["(","[","{","<"].any?(value[0])
        elsif pairs.odd?
          value[2] = "queue"
          pairs += 1
        else
          back_check_position = position-1
          while line_check[back_check_position][2] == "delete"
            back_check_position -= 1
          end
          if line_check[back_check_position][2] == "waiting"
            line_check[back_check_position][2] = "queue"
            value[2] = "queue"
            pairs += 1
          else
            value[2] = "waiting"
          end
        end
      end

    else
    end
    position += 1
  end
  return line_check
end

def delete_values(line_check)
  line_check.select! do |value|
    value[2] != "delete"
  end
end

def find_opposite(character)
  if [")","]","}",">"].any?(character)
    index = [")","]","}",">"].index(character)
    return ["(","[","{","<"][index]
  else
    index = ["(","[","{","<"].index(character)
    return [")","]","}",">"][index]
  end
end

puts find_char
