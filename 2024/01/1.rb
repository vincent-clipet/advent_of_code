lines = IO.readlines("data.txt")

left = lines.map { |line| line.split[0].to_i }.sort!
right = lines.map { |line| line.split[1].to_i }.sort!

distance = 0
left.each_index do |i|
  distance += (left[i] - right[i]).abs
end
puts distance.to_s