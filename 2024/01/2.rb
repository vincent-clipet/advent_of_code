lines = IO.readlines("data.txt")

left = lines.map { |line| line.split[0].to_i }.sort!
right = lines.map { |line| line.split[1].to_i }.sort!

similarity = 0
left.each_index do |i|
  similarity += left[i] * right.count(left[i])
end
puts similarity.to_s