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
  polymer_template = first_polymer(data[1])
  new_polymer_template = []

  new_polymer = polymer_template
  steps.times do
    new_polymer = run_polymer(new_polymer, pair_insertions)
  end
  polymer_template = new_polymer

  quantity = find_quantity(polymer_template)
  total = (polymer_template.map {|k, v| v}).sum + 1
  puts ""
  puts "After #{steps} steps the polymer grew to a length of #{total}."
  puts "The most common polymer was #{quantity[0][0]} with a quantity of #{quantity[0][1]}"
  puts "The least common polymer was #{quantity[1][0]} with a quantity of #{quantity[1][1]}"
  puts "The difference between the two is #{quantity[2]}"
end




def run_polymer(polymer_template, pair_insertions)
  iteration = 0
  new_polymer_template = {}
  x = polymer_template
  x.each do |pair|
    count = 1
    pair_array = pair[0].to_s.split("")
    insert = pair_insertions.select {|insertion| insertion[0] == pair[0].to_s}

    if pair[1] > 0
      count = pair[1]
    end

    if new_polymer_template[pair[0]].nil?
      new_polymer_template[pair[0]] = pair[1]
    else
      new_polymer_template[pair[0]] += pair[1]
    end

    if !insert.empty?
      first = ([pair_array[0]] + [insert[0][1]]).join
      if new_polymer_template[:"#{first}"].nil?
        new_polymer_template[:"#{first}"] = count
      else
        new_polymer_template[:"#{first}"] += count
      end
      second = ([insert[0][1]] + [pair_array[1]]).join
      if new_polymer_template[:"#{second}"].nil?
        new_polymer_template[:"#{second}"] = count
      else
        new_polymer_template[:"#{second}"] += count
      end
      new_polymer_template[pair[0]] -= count
    end
  end
  new_polymer_template.select {|key, value| value > 0}
end



def find_quantity(polymer_template)
  organize_template = {}
  polymer_template.each do |polymer|
    if organize_template[:"#{polymer[0].to_s.split("")[0]}"].nil?
      organize_template[:"#{polymer[0].to_s.split("")[0]}"] = polymer[1]
    else
      organize_template[:"#{polymer[0].to_s.split("")[0]}"] += polymer[1]
    end
    if organize_template[:"#{polymer[0].to_s.split("")[1]}"].nil?
      organize_template[:"#{polymer[0].to_s.split("")[1]}"] = polymer[1]
    else
      organize_template[:"#{polymer[0].to_s.split("")[1]}"] += polymer[1]
    end
  end

  organize_template.each {|key, value| organize_template[key] = (value/2.0).ceil}
  max = organize_template.sort_by {|key, value| value}.last
  min = organize_template.sort_by {|key, value| value}.first
  diff = max[1] - min[1]
  return [max, min, diff]
end

def first_polymer(data)
  iterations = 0
  polymers = {}
  data.each do |polymer|
    if !data[iterations+1].nil?
      polymer << data[iterations+1]
      if !polymers[:"#{polymer}"].nil?
        polymers[:"#{polymer}"] += 1
      else
        polymers[:"#{polymer}"] = 1
      end
    end
    iterations += 1
  end
  polymers
end

grow_polymer(10)
grow_polymer(40)
