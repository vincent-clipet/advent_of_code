lines = IO.readlines("data.txt").map { |line| line.chomp.split(" ").map(&:to_i) }

def check_consecutive_values(ascending, levels)
  levels.each_cons(2) do |cons|
    return 0 if (ascending && !(cons[1] - cons[0]).between?(1, 3))
    return 0 if !ascending && !(cons[0] - cons[1]).between?(1, 3)
  end
  1
end

puts lines.reduce(0) { |sum, levels| sum += check_consecutive_values(levels[0] < levels[1], levels) }