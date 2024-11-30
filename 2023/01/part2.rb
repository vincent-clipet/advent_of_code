lines = IO.readlines("data.txt")

digitize = {
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9,
}
(0..9).each { |n| digitize[n.to_s] = n }

stringified_regex = (digitize.keys + ("1".."9").to_a).join("|")
regex_forward = Regexp.new(stringified_regex)
regex_backward = Regexp.new(stringified_regex.reverse)

sum = lines.reduce(0) do | counter, value |
  first = digitize[value.scan(regex_forward)[0]]
  last = digitize[value.reverse.scan(regex_backward)[0].reverse]
  counter + (first.to_s + last.to_s).to_i
end

puts sum.to_s
