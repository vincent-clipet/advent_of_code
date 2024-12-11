LINES = IO.readlines("data.txt").map {| line | line.chomp.split.map{|e| e.delete(":")}.map(&:to_i)}

def generate_permutation(binary_value, elements)
  permutation = []
  elements.times do
    result = 3 & binary_value
    return nil if result == 3
    permutation << result
    binary_value >>= 2
  end
  return permutation
end

def generate_all_permutations(elements)
  bits_of_interest = elements * 2
  max_value = 2 ** bits_of_interest
  ret = []
  (0...max_value).each do |i|
    tmp = generate_permutation(i, elements)
    ret << tmp unless tmp.nil?
  end
  return ret
end

generated_permutations = Array.new(20) # Lookup table of previously generated permutations
sum = 0

LINES.each do |line|
  target_value = line[0]
  numbers = line[2..-1]
  generated_permutations[numbers.length] = generate_all_permutations(numbers.length) if generated_permutations[numbers.length] == nil
  generated_permutations[numbers.length].each do |permutation|
    x = line[1]
    permutation.each_index do |i|
      case permutation[i]
      when 0 # *
        x *= numbers[i]
      when 1 # +
        x += numbers[i]
      when 2 # ||
        x = x * (10 ** numbers[i].digits.size) + numbers[i]
      end
    end
    if target_value == x then
      sum += target_value
      puts "OK : #{target_value}"
      break
    end
  end
end

puts "==================\nSomme = #{sum}"