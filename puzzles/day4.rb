
def create_bingo_cards
  bingo_calls = []
  bingo_cards = []
  bingo_card = {}

  bingo_row = 1
  File.open(ARGV[0]).each do |line|

    if line.length > 30
      line = line.gsub("\n", '').split(",")
      bingo_calls << line

    elsif line.length != 1
      line = line.gsub("\n", "").split(" ")
      bingo_columns = 1
      line.each do |digit|
        bingo_card[:"r#{bingo_row}_c#{bingo_columns}"] = digit.to_i
        bingo_card[:"r#{bingo_row}_c#{bingo_columns}_s"] = false
        if bingo_columns == 5
          bingo_columns = 1
        else
          bingo_columns += 1
        end

        if bingo_columns == 1 && bingo_row == 5
           bingo_row = 1
           bingo_cards << bingo_card
           bingo_card = {}
        elsif bingo_columns == 1
          bingo_row += 1
        end
      end
    end
  end

  return bingo_calls, bingo_cards
end

def find_best_bingo_card
  bingo_calls = create_bingo_cards[0][0].map {|value| value.to_i}
  bingo_cards = create_bingo_cards[1]

  bingo_calls.each do |callout|
    bingo_cards.each do |card|
      same_cards = card.find_all {|key, value| value == callout}
      change_values = same_cards.map {|value| (value[0].to_s << '_s').to_sym}
      change_values.each {|value| card[value] = true}
      if check_bingo_win_conditions(card) == true
        condition = 'Best Card'
        return format_win_conditions(card, callout, condition)
      end
    end
  end
end

def find_worst_bingo_card
  bingo_calls = create_bingo_cards[0][0].map {|value| value.to_i}
  bingo_cards = create_bingo_cards[1].map {|card| card.merge(win?: false)}
  total_cards = bingo_cards.count
  counter = 0
  bingo_calls.each do |callout|
    bingo_cards.each do |card|
      same_cards = card.find_all {|key, value| value == callout}
      change_values = same_cards.map {|value| (value[0].to_s << '_s').to_sym}
      change_values.each {|value| card[value] = true}
      if card[:win?] == false
        if check_bingo_win_conditions(card) == true && counter != total_cards - 1
          card[:win?] = true
          counter += 1
        elsif check_bingo_win_conditions(card) == true && counter == total_cards - 1
          condition = 'Worst Card'
          return format_win_conditions(card, callout, condition)
        end
      end
    end
  end
end

def format_win_conditions(card, callout, condition)
  false_conditions = card.select do |key, value|
    value == false
  end
  lookup = []
  false_conditions.map do |key, value|
    lookup << key.to_s.gsub("_s", "").to_sym
  end
  lookup.delete(:win?)
  all_false = []
  card.each do |key, value|
    if lookup.include?(key)
      all_false << value
    end
  end
  score = all_false.sum * callout
  puts "#{condition} Score: #{score}"
end

def organize_bingo_wins(card)
  possible_wins = []

  row = 1
  column = 1
  5.times do
    possible_wins << card.values_at(
      :"r#{row}_c1_s", :"r#{row}_c2_s", :"r#{row}_c3_s",
      :"r#{row}_c4_s", :"r#{row}_c5_s"
    )
    row +=1
  end
  5.times do
    possible_wins << card.values_at(
      :"r1_c#{column}_s", :"r2_c#{column}_s", :"r3_c#{column}_s",
      :"r4_c#{column}_s", :"r5_c#{column}_s"
    )
    column +=1
  end
  return possible_wins
end

def check_bingo_win_conditions(card)
  possible_wins = organize_bingo_wins(card)
  winning_card = false

  possible_wins.each do |set|
    if set.all? {|value| value == true} == true
      winning_card = true
    end
  end
  return winning_card
end

puts find_best_bingo_card
puts find_worst_bingo_card
