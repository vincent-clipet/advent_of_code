lines = IO.readlines("data.txt").map { |line| line.chomp.split(" ").map(&:to_i) }

def check_consecutive_values(levels)
  ascending = levels[1] > levels[0]
  levels.each_cons(2) do |cons|
    return 0 if (ascending && !(cons[1] - cons[0]).between?(1, 3))
    return 0 if !ascending && !(cons[0] - cons[1]).between?(1, 3)
  end
  1
end

sum = 0
lines.each do |levels|
  safe = 0
  levels.length.times.each do |index|
    levels_copy = levels.dup
    levels_copy.delete_at(index)
    safe += check_consecutive_values(levels_copy)
  end
  sum += 1 if safe >= 1
end
puts sum.to_s