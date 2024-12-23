lines = IO.readlines("data.txt").map {|line| line.chomp.to_i}

def process(secret)
  mult64 = secret * 64
  secret ^= mult64
  secret %= 16777216
  div = secret / 32
  secret ^= div
  secret %= 16777216
  mult2048 = secret * 2048
  secret ^= mult2048
  secret %= 16777216
  return secret
end

to_sum = []
lines.each_with_index do |v, i|
  2000.times {v = process(v)}
  to_sum << v
end
puts to_sum.sum.to_s