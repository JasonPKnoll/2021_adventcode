require 'colorize'

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
      bingo_collumn = 1
      line.each do |digit|
        bingo_card[:"r#{bingo_row}_c#{bingo_collumn}"] = digit.to_i
        bingo_card[:"r#{bingo_row}_c#{bingo_collumn}_s"] = false
        if bingo_collumn == 5
          bingo_collumn = 1
        else
          bingo_collumn += 1
        end

        if bingo_collumn == 1 && bingo_row == 5
           bingo_row = 1
           bingo_cards << bingo_card
           bingo_card = {}
        elsif bingo_collumn == 1
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
    end
  end
end

# p "#{bingo_cards[0][:r1_c1]} #{bingo_cards[0][:r1_c2]}"

puts find_best_bingo_card
