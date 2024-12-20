require 'set'

class Dir
  DIRECTIONS = [UP = 0, RIGHT = 1, DOWN = 2, LEFT = 3]
end

def oob(array, x, y)
  return (y < 0 || y >= array.length || x < 0 || x >= array[0].length)
end

# Returns true if set already contains this x/y/dir combination. Inserts the new combination and returns false otherwise
def insert_move(hash, x, y, dir)
  binary = x | (y << 8) | (dir << 16)
  if hash.has_key?(binary) then
    return true
  else
    hash[binary] = true
    return false
  end
end

# Mostly duplicate code, but for a good reason : optimization :)
def collect_walked_locations(grid, x, y)
  previous_moves = {}
  dir = Dir::UP

  until oob(grid, x, y) do
    case dir
    when Dir::UP
      break if oob(grid, x, y-1)
      destination = grid[y-1][x]
      case destination
      when ".", " "
        y = y-1
        binary = x | (y << 8)
        previous_moves[binary] = true
      when "#"
        dir = Dir::RIGHT
      end
    when Dir::DOWN
      break if oob(grid, x, y+1)
      destination = grid[y+1][x]
      case destination
      when ".", " "
        y = y+1
        binary = x | (y << 8)
        previous_moves[binary] = true
      when "#"
        dir = Dir::LEFT
      end
    when Dir::LEFT
      break if oob(grid, x-1, y)
      destination = grid[y][x-1]
      case destination
      when ".", " "
        x = x-1
        binary = x | (y << 8)
        previous_moves[binary] = true
      when "#"
        dir = Dir::UP
      end
    when Dir::RIGHT
      break if oob(grid, x+1, y)
      destination = grid[y][x+1]
      case destination
      when ".", " "
        x = x+1
        binary = x | (y << 8)
        previous_moves[binary] = true
      when "#"
        dir = Dir::DOWN
      end
    end
  end
  return previous_moves
end

# Return true if processing 'grid' while stating at 'y, x' leads to an infinite loop
def infinite_loop?(grid, x, y)
  previous_moves = {}
  stop = false
  dir = Dir::UP

  until (oob(grid, x, y) || stop) do
    case dir
    when Dir::UP
      return false if oob(grid, x, y-1)
      destination = grid[y-1][x]
      case destination
      when ".", " "
        y = y-1
        stop = insert_move(previous_moves, x, y, dir)
      when "#"
        dir = Dir::RIGHT
      end
    when Dir::DOWN
      return false if oob(grid, x, y+1)
      destination = grid[y+1][x]
      case destination
      when ".", " "
        y = y+1
        stop = insert_move(previous_moves, x, y, dir)
      when "#"
        dir = Dir::LEFT
      end
    when Dir::LEFT
      return false if oob(grid, x-1, y)
      destination = grid[y][x-1]
      case destination
      when ".", " "
        x = x-1
        stop = insert_move(previous_moves, x, y, dir)
      when "#"
        dir = Dir::UP
      end
    when Dir::RIGHT
      return false if oob(grid, x+1, y)
      destination = grid[y][x+1]
      case destination
      when ".", " "
        x = x+1
        stop = insert_move(previous_moves, x, y, dir)
      when "#"
        dir = Dir::DOWN
      end
      exit 0 if (y == 2 && x == 10 && dir == Dir::RIGHT)
    end
  end

  return stop
end



LINES = IO.readlines("data.txt").map(&:chomp)
y = LINES.index {|line| line.index("^") != nil}
x = LINES[y].index("^")
LINES[y][x] = " "
filtered_locations = collect_walked_locations(Marshal.load(Marshal.dump(LINES)), x, y)
sum = 0
progress = 0

# Bruteforcing time, dont worry about performance it will be fine (it won't)
LINES.each_index do |j|
  LINES[y].chars.each_index do |i|
    progress += 1
    next if LINES[j][i] == "#" || LINES[j][i] == " "
    next unless filtered_locations.include?(i | (j << 8)) # Big performance gain by only checking locations where the guard can walk in the default configuration (145s -> 35s)
    grid = Marshal.load(Marshal.dump(LINES))
    grid[j][i] = "#"
    stuck = infinite_loop?(grid, x, y)
    sum += 1 if stuck
    puts "sum = #{sum} | Progress : #{((progress.to_f/(LINES.length*LINES[0].length))*100).round(2)}% (#{progress}/#{LINES.length*LINES[0].length})" if stuck
  end
end