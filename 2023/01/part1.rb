lines = IO.readlines("data.txt")

sum = lines.reduce(0) do | counter, value |
  only_numbers = value.delete('^0-9')
  counter + (only_numbers[0] + only_numbers[-1]).to_i
end

puts sum.to_s
