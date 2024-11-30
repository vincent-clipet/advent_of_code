lines = IO.readlines("data.txt")

pattern = lines.shift.chomp
lines.shift

map = {}
lines.each do | line |
  map[line[0..2]] = {
    :left => line[7..9],
    :right => line[12..14]
  }
end

e = map["AAA"]
999999999.times do | i |
  direction = pattern[i % pattern.length]
  destination = direction == "L" ? e[:left] : e[:right]
  if destination == "ZZZ" then
    puts "Found after #{i+1} iterations"
    exit 0
  end
  e = map[destination]
end
