LINES = IO.readlines("data.txt").map {| line | line.chomp.split.map{|e| e.delete(":")}.map(&:to_i)}

# Too long because "permutation()" doesn't ignore duplicates, which makes the complexity of "uniq()" == O(n!)
def generate_permutations(elements)
  return (0..elements).map{|i| (Array.new(i, "+") + Array.new(total - i, "*")).permutation.uniq.to_a}.flatten(1)
end

def generate_permutations_v2(elements)
  max_value = 2 ** elements
  ret = Array.new(max_value)
  (0...max_value).each do |i|
    b = i
    permutation = Array.new(elements)
    elements.times do |index|
      permutation[index-1] = ((1 & b) == 1)
      b >>= 1
    end
    ret[i] = permutation
  end
  return ret
end

generated_permutations = Array.new(20) # Lookup table of previously generated permutations
sum = 0

# Could have been done faster & simpler by using recursion, but where's the fun in that :)
# Instead I'm using bits of increasing integers to generate all possible permutations
LINES.each do |line|
  target_value = line[0]
  numbers = line[2..-1]
  generated_permutations[numbers.length] = generate_permutations_v2(numbers.length) if generated_permutations[numbers.length] == nil

  generated_permutations[numbers.length].each do |permutation|
    x = line[1]
    permutation.each_index {|i| x = permutation[i] ? x *= numbers[i] : x += numbers[i]}
    if x > target_value then
      break
    elsif target_value == x then
      sum += target_value
      break
    end
  end
end

puts sum.to_s