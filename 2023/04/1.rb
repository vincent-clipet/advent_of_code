results = IO.readlines("data.txt").map do |s|
  s = s.chomp
  all_numbers = s.split(": ")[1]
  {
    winning_numbers: all_numbers.split("|")[0].split(" ").map(&:to_i),
    played_numbers: all_numbers.split("|")[1].split(" ").map(&:to_i)
  }
end

sum = 0
results.each do |result|
  power = ((result[:played_numbers] & result[:winning_numbers]).length - 1)
  sum += 2 ** power if power >= 0
end
puts sum.to_s


