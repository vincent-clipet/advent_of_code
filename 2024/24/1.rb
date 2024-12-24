LINES = IO.readlines("data.txt").map(&:chomp)
split_index = LINES.index("")

inputs = {}
LINES[0...split_index].each {|e| split = e.split(": "); inputs[split[0]] = split[1] == "1"}

Operation = Struct.new(:input_a, :input_b, :operator, :output)
operations = LINES[(split_index+1)..-1].map do |e|
  split = e.split(" -> ");
  input_a, operator, input_b = split[0].split(" ")
  Operation.new(input_a, input_b, operator, split[1])
end

until operations.empty? do
  operations.each do |op|
    input_a, input_b = inputs[op.input_a], inputs[op.input_b]
    next if input_a.nil? || input_b.nil?
    r = nil
    case op.operator
    when "XOR"
      r = input_a ^ input_b
    when "AND"
      r = input_a & input_b
    when "OR"
      r = input_a | input_b
    end
    inputs[op.output] = r
    operations.delete(op)
  end
end

puts inputs.select {|k, v| k =~ /^z(\d){2}/}.sort.map {|e| e[1] == true ? "1" : "0"}.reverse.join("").to_i(2)