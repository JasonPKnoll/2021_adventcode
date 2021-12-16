def get_data
  pair_insertions = []
  polymer_template = 0
  File.open(ARGV[0]).each do |line|
    if line.include?("->")
      line = line.gsub("\n", "").split(" -> ")
      pair_insertions << line
    elsif line != "\n"
      line = line.gsub(/\n/, "").split("")
      polymer_template = line
    end
  end
  return [pair_insertions, polymer_template]
end

def grow_polymer(steps)
  data = get_data
  pair_insertions = data[0]
  polymer_template = data[1]
  new_polymer_template = []

  new_polymer = polymer_template
  
  steps.times do
    new_polymer = run_polymer(new_polymer, pair_insertions)
  end

  polymer_template = new_polymer

  quantity = find_quantity(polymer_template)
  puts "After #{steps} steps the polymer grew to a length of #{polymer_template.count}."
  puts "The most common polymer was #{quantity[0][0]} with a quantity of #{quantity[0][1]}"
  puts "The least common polymer was #{quantity[1][0]} with a quantity of #{quantity[1][1]}"
  puts "The difference between the two is #{quantity[2]}"
end

def run_polymer(polymer_template, pair_insertions)
  iteration = 0
  new_polymer_template = []
  x = polymer_template
  x.each do |polymer|
    if iteration == 0
      check = ([polymer] + [polymer_template[iteration+1]]).join(",").gsub(",", "")
      possible_pair = pair_insertions.select {|pair| pair[0] == check}
      if !possible_pair.empty?
        insert = possible_pair[0][1]
        check.split("").insert(1, insert).each {|value| new_polymer_template << value}
      else
        new_polymer_template << polymer
      end
      iteration += 1
    elsif iteration-1 != polymer_template.count
      check = ([polymer] + [polymer_template[iteration+1]]).join(",").gsub(",", "")
      possible_pair = pair_insertions.select {|pair| pair[0] == check}
      if !possible_pair.empty?
        insert = possible_pair[0][1]
        check.split("").insert(1, insert)[1..2].each {|value| new_polymer_template << value}
      else
        # new_polymer_template << polymer
      end
      iteration += 1
    else
    end
  end
  new_polymer_template
end

def find_quantity(polymer_template)
  organize_template = {}
  polymer_template.each do |polymer|
    if organize_template[:"#{polymer}"].nil?
      organize_template[:"#{polymer}"] = 1
    else
      organize_template[:"#{polymer}"] += 1
    end
  end
  max = organize_template.sort_by {|key, value| value}.last
  min = organize_template.sort_by {|key, value| value}.first
  diff = max[1] - min[1]
  return [max, min, diff]
end

grow_polymer(10)
