map = {}
triple = []

lines = IO.readlines("data.txt").each do |line|
  k1, k2 = line.chomp.split("-")
  map[k1] = [] if map[k1].nil?
  map[k2] = [] if map[k2].nil?
  map[k1] << k2
  map[k2] << k1
end

map.each do |c1,v|
  v.permutation(2).each do |c2_c3|
    triple << [c1, c2_c3[0], c2_c3[1]].sort.join("-") if map[c2_c3[0]].include?(c2_c3[1])
  end
end

puts triple.uniq.sort.filter {|e| e[0] == "t" || e[3] == "t" || e[6] == "t"}.size.to_s