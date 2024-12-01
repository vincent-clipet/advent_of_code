cards = []
IO.readlines("data.txt").each do |s|
  s = s.chomp
  all_numbers = s.split(": ")[1]
  cards << {
    winning_numbers: all_numbers.split("|")[0].split(" ").map(&:to_i),
    played_numbers: all_numbers.split("|")[1].split(" ").map(&:to_i)
  }
end
cards_number = Array.new(cards.length, 1)

cards.each_with_index do |card_quantity, card_id|
  card = cards[card_id]
  multiplier = cards_number[card_id]
  new_cards_quantity = (card[:winning_numbers] & card[:played_numbers]).length
  (1..new_cards_quantity).each do |delta|
    cards_number[card_id + delta] += multiplier
  end
end

puts cards_number.sum


