
# Doesn't work

module Part2
  @DEBUG = false
  @lines = @DEBUG ? IO.readlines("data_test_2.txt") : IO.readlines("data.txt")
  @map = {}

  def self.main()
    @pattern = @lines.shift.chomp
    @lines.shift

    @lines.each do | line |
      @map[line[0..2]] = {
        :left => line[7..9],
        :right => line[12..14]
      }
    end

    destinations = @map.select { | key, value | key[2] == "A" }.keys
    frequencies = destinations.map { | key | frequency(key) }
    puts "frequencies = #{frequencies}"

    result = lowest_multiples(frequencies)
    puts ">>> #{result}"

  end



  def self.frequency(a_key)
    999999999.times do | i |
      direction = @pattern[i % @pattern.length]
      puts "--------" if @DEBUG
      puts "@map[a_key] = #{@map[a_key]}" if @DEBUG
      value = direction == "L" ? @map[a_key][:left] : @map[a_key][:right]
      puts value if @DEBUG
      return i if value[2] == "Z"
      a_key = value
    end
  end

  def self.lowest_multiple(a, b)
    puts "#{a} * #{b} / biggest_denominator(#{a}, #{b})" if @DEBUG
    return (a * b) / biggest_denominator(a, b);
  end

  def self.lowest_multiples(values)
    return lowest_multiple(values[0], values[1]) if values.size == 2

    first = values[0];
    values.shift();
    return lowest_multiple(first, lowest_multiples(values));
  end

  def self.biggest_denominator(a, b)
    while (b != 0) do
        tmp = b;
        b = a % b;
        a = tmp;
    end
    return a;
  end
end

Part2.main()
