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
  all_numbers = []

  data.each do |set|
    ones = []
    fours = []
    sevens = []

    set[1].each do |word|
      if word.length == 2
        word.split("").each do |letter|
          ones << letter
        end
      elsif word.length == 4
        word.split("").each do |letter|
          fours << letter
        end
      elsif word.length == 3
        word.split("").each do |letter|
          sevens << letter
        end
      else
      end

      set[0].each do |word|
        if word.length == 2
          word.split("").each do |letter|
            ones << letter
          end
        elsif word.length == 4
          word.split("").each do |letter|
            fours << letter
          end
        elsif word.length == 3
          word.split("").each do |letter|
            sevens << letter
          end
        else
        end
      end
    end

    number = []
    set[1].each do |word|

      if word.length == 2
          number << 1
      elsif word.length == 3
          number << 7
      elsif word.length == 4
        number << 4
      elsif word.length == 5
        if (word.split("") - sevens.uniq).length == 2
          number << 3
        elsif (word.split("") - fours.uniq).length == 2
          number << 5
        else
          number << 2
        end
      elsif word.length == 6
        if (word.split("") - fours.uniq).length == 2
          number << 9
        elsif (word.split("") - sevens.uniq).length == 4
          number << 6
        else
          number << 0
        end
      else
        number << 8
      end
    end
    all_numbers << number.join(',').gsub(",", "").to_i
  end
  instances = all_numbers.sum
  puts "#{instances} "
end

puts find_digits
