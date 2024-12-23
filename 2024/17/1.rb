lines = IO.readlines("data.txt").map {|line| line.chomp.split(": ")[1]}

a, b, c = lines[0...2].map(&:to_i)
operations = lines[4].split(",").map(&:to_i)
output = []
pointer = 0

while pointer < operations.size do
  combo = [0,1,2,3,a,b,c,nil]
  opcode = operations[pointer]
  literal_operand = operations[pointer+1]
  combo_operand = combo[literal_operand]
  puts "a = #{a.to_s.ljust(8)} | b = #{b.to_s.ljust(8)} | c = #{c.to_s.ljust(8)} | opcode = #{opcode} | literal_operand = #{literal_operand} | combo_operand = #{combo_operand.to_s.ljust(6)}"

  case opcode
  when 0 # ADV - Division
    a /= (2 ** combo_operand)
  when 1 # BXL - XOR
    b ^= literal_operand
  when 2 # BST - %8
    b = combo_operand % 8
  when 3 # JNZ
    pointer = literal_operand - 2 if a != 0
  when 4 # BXC - XOR B^C
    b ^= c
  when 5 # OUT
    output << combo_operand % 8
  when 6 # BDV
    b = a / (2 ** combo_operand)
  when 7 # CDV
    c = a / (2 ** combo_operand)
  end
  pointer += 2
end

puts "output = #{output.join(",")}"