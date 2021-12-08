def get_data
  array = []
  File.open(ARGV[0]).each do |line|
    array1 = line.gsub("\n", "").split("|")[0]
    array2 = line.gsub("\n", "").split("|")[1]
    array << [array1.split(" "), array2.split(" ")]
  end
  return array
end

def find_digits
  data = get_data
  numbers_hash = {}
  (0..9).each {|num| numbers_hash[:"#{num}"] = 0}
  data.each do |set|
    set[1].each do |word|
      num = find_by_length(word.length)
      if num != nil
        numbers_hash[:"#{num}"] += 1
      end
    end
  end
  instances = numbers_hash.values.sum
  puts "#{instances} instances of 1,4,7, or 8"
end

def find_by_length(length)
  if length == 2
    return 1
  elsif length == 4
    return 4
  elsif length == 3
    return 7
  elsif length == 7
    return 8
  else
    return nil
  end
end

puts find_digits
