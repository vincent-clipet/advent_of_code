# "Why waste time do lot maths, when bruteforce do trick"
def get_tokens(a, b, prize)
  (0...100).each do |mult_a|
    (0...100).each do |mult_b|
      return mult_a * 3 + mult_b if (a[0] * mult_a + b[0] * mult_b) == prize[0] && (a[1] * mult_a + b[1] * mult_b) == prize[1]
    end
  end
  return 0
end

LINES = IO.readlines("data.txt").map {| line | line.chomp}
sum = 0
(0...LINES.size).step(4).each do |i|
  a = LINES[i].split(": ")[1].split(", ").map{|e| e.split("+")[1]}.map(&:to_i)
  b = LINES[i+1].split(": ")[1].split(", ").map{|e| e.split("+")[1]}.map(&:to_i)
  prize = LINES[i+2].split(": ")[1].split(", ").map{|e| e.split("=")[1]}.map(&:to_i)
  sum += get_tokens(a,b,prize)
end
puts sum.to_s