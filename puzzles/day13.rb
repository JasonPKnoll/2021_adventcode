def get_data
  paper = {}
  folds = []
  File.open(ARGV[0]).each do |line|
    if line.include?(",")
      line = line.gsub("\n", "").split(",")
      paper[:"#{line[0]}_#{line[1]}"] = true
    elsif line.include?("fold")
      line = line.gsub(/fold along /, "").gsub(/\n/, "").split("=")
      folds << line
    end
  end
  return [paper, folds]
end

def plot_paper
  data = get_data
  paper = data[0]
  folds = data[1]
  fold_count = 0
  first_pass = 0
  folds.each do |fold|
    if fold[0] == "y"
      foldable_keys = paper.keys.select {|key| key.to_s.split("_")[1].to_i >= fold[1].to_i}
      foldable_keys.each do |coordinates|
        diff = coordinates.to_s.split("_")[1].to_i-fold[1].to_i
        paper[:"#{coordinates.to_s.split("_")[0]}_#{fold[1].to_i-diff}"] = true
        paper.delete(coordinates)
        # paper[coordinates] = false
      end
    else
      foldable_keys = paper.keys.select {|key| key.to_s.split("_")[0].to_i >= fold[1].to_i}
      foldable_keys.each do |coordinates|
        diff = coordinates.to_s.split("_")[0].to_i-fold[1].to_i
        paper[:"#{fold[1].to_i-diff}_#{coordinates.to_s.split("_")[1]}"] = true
        paper.delete(coordinates)
      end
    end
    fold_count += 1
    if fold_count == 1
      all_spots = paper.select {|key, value| value == true}
      first_pass = all_spots.count
    end
  end
  all_spots = paper.select {|key, value| value == true}
  puts "After one fold there are #{first_pass} visible dots."
  puts "After all #{fold_count} folds, there are #{all_spots.count} visible dots."
end

puts plot_paper
