@all_chars = IO.readlines("data.txt").map {|s| s.chomp.chars}

def is_machine_part?(x_start, x_end, y_start)
  ((y_start - 1)..(y_start + 1)).each do |y|
    next if (y < 0 || y >= @all_chars.length)
    ((x_start)..(x_end)).each do |x|
      next if (x < 0 || x >= @all_chars[0].length)
      return true if @all_chars[y][x] !~ /[0-9\.]/
    end
  end
  return false
end

sum = 0
@all_chars.each_index do |y|
  x = 0
  while (x < @all_chars[y].length) do
    c = @all_chars[y][x]
    if c =~ /[0-9]/ then
      number = c
      if @all_chars[y][x + 1] =~ /[0-9]/
        number += @all_chars[y][x + 1]
        if @all_chars[y][x + 2] =~ /[0-9]/
          number += @all_chars[y][x + 2]
        end
      end
      sum += number.to_i if is_machine_part?(x - 1, x + number.length, y)
      x += number.length - 1
    end
    x += 1
  end
end
puts sum.to_s