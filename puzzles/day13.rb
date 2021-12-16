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
  print_board(all_spots)
end

def print_board(all_spots)
  length = all_spots.keys.map {|key| key.to_s.split("_")[0].to_i}.max
  width = all_spots.keys.map {|key| key.to_s.split("_")[1].to_i}.max
  board = {}
  (0..length).each do |length|
    (0..width).each do |width|
      if all_spots[:"#{length}_#{width}"]
        board[:"#{length}_#{width}"] = "#"
      else
        board[:"#{length}_#{width}"] = "."
      end
    end
  end
  current_width = 0
  (width+1).times do
    layer = board.select do |key, value|
      key.to_s.split("_")[1].to_i == current_width
    end
    p layer.values.join(", ").gsub(",", "")
    current_width += 1
  end
  puts
end

puts plot_paper
