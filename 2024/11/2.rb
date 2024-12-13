line = IO.readlines("data.txt")[0].chomp.split.map(&:to_i)
counters = line.tally

75.times do
  counters_new = Hash.new(0)
  counters.each do |number, count|
    if number == 0 then
      counters_new[1] += count
    elsif number.digits.size % 2 == 0 then
      center = 10**(number.digits.size / 2)
      counters_new[number / center] += count
      counters_new[number % center] += count
    else
      counters_new[number * 2024] += count
    end
  end
  counters = counters_new
end

puts counters.values.sum.to_s