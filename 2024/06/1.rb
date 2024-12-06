@lines = IO.readlines("data.txt").map(&:chomp)

class Dir
  DIRECTIONS = [UP = 0, RIGHT = 1, DOWN = 2, LEFT = 3]
end

y = @lines.index {|line| line.index("^") != nil}
x = @lines[y].index("^")
@lines[y][x] = " "
dir = Dir::UP

def oob(x, y)
  return (y < 0 || y >= @lines.length || x < 0 || x >= @lines[0].length)
end

until oob(x, y) do
  case dir
  when Dir::UP
    break if oob(x, y-1)
    destination = @lines[y-1][x]
    case destination
    when ".", " "
      y = y-1
      @lines[y][x] = " "
    when "#"
      dir = Dir::RIGHT
    end
  when Dir::DOWN
    break if oob(x, y+1)
    destination = @lines[y+1][x]
    case destination
    when ".", " "
      y = y+1
      @lines[y][x] = " "
    when "#"
      dir = Dir::LEFT
    end
  when Dir::LEFT
    break if oob(x-1, y)
    destination = @lines[y][x-1]
    case destination
    when ".", " "
      x = x-1
      @lines[y][x] = " "
    when "#"
      dir = Dir::UP
    end
  when Dir::RIGHT
    break if oob(x+1, y)
    destination = @lines[y][x+1]
    case destination
    when ".", " "
      x = x+1
      @lines[y][x] = " "
    when "#"
      dir = Dir::DOWN
    end
  end
end

puts @lines.sum {|line| line.count(" ")}