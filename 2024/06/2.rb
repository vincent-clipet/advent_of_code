require 'set'

class Dir
  DIRECTIONS = [UP = 0, RIGHT = 1, DOWN = 2, LEFT = 3]
end

def oob(array, x, y)
  return (y < 0 || y >= array.length || x < 0 || x >= array[0].length)
end

# Returns true if set already contains this x/y/dir combination. Inserts the new combination and returns false otherwise
def insert_move(set, x, y, dir = 0)
  binary_value = x | y << 8 | dir << 16 # Indexing values by binary number instead of string, 12s -> 5.5s performance improvement
  if set.include?(binary_value) then
    return true
  else
    set.add(binary_value)
    return false
  end
end

# Mostly duplicate code, but for a good reason : optimization :)
def collect_walked_locations(grid, x, y)
  previous_moves = Set[]
  dir = Dir::UP

  until oob(grid, x, y) do
    case dir
    when Dir::UP
      break if oob(grid, x, y-1)
      destination = grid[y-1][x]
      case destination
      when false
        y = y-1
        insert_move(previous_moves, x, y)
      when true
        dir = Dir::RIGHT
      end
    when Dir::DOWN
      break if oob(grid, x, y+1)
      destination = grid[y+1][x]
      case destination
      when false
        y = y+1
        insert_move(previous_moves, x, y)
      when true
        dir = Dir::LEFT
      end
    when Dir::LEFT
      break if oob(grid, x-1, y)
      destination = grid[y][x-1]
      case destination
      when false
        x = x-1
        insert_move(previous_moves, x, y)
      when true
        dir = Dir::UP
      end
    when Dir::RIGHT
      break if oob(grid, x+1, y)
      destination = grid[y][x+1]
      case destination
      when false
        x = x+1
        insert_move(previous_moves, x, y)
      when true
        dir = Dir::DOWN
      end
    end
  end
  return previous_moves
end

# Return true if processing 'grid' while stating at 'y, x' leads to an infinite loop
def infinite_loop?(grid, x, y)
  previous_moves = Set[]
  stop = false
  dir = Dir::UP

  until (oob(grid, x, y) || stop) do
    case dir
    when Dir::UP
      return false if oob(grid, x, y-1)
      destination = grid[y-1][x]
      case destination
      when false
        y = y-1
        stop = insert_move(previous_moves, x, y, dir)
      when true
        dir = Dir::RIGHT
      end
    when Dir::DOWN
      return false if oob(grid, x, y+1)
      destination = grid[y+1][x]
      case destination
      when false
        y = y+1
        stop = insert_move(previous_moves, x, y, dir)
      when true
        dir = Dir::LEFT
      end
    when Dir::LEFT
      return false if oob(grid, x-1, y)
      destination = grid[y][x-1]
      case destination
      when false
        x = x-1
        stop = insert_move(previous_moves, x, y, dir)
      when true
        dir = Dir::UP
      end
    when Dir::RIGHT
      return false if oob(grid, x+1, y)
      destination = grid[y][x+1]
      case destination
      when false
        x = x+1
        stop = insert_move(previous_moves, x, y, dir)
      when true
        dir = Dir::DOWN
      end
    end
  end

  return stop
end



FILE_LINES = IO.readlines("data.txt")
tmp = FILE_LINES.map {|e| e.chomp.chars.map(&:ord)}
y = tmp.index {|line| line.index('^'.ord) != nil}
x = tmp[y].index('^'.ord)
LINES = FILE_LINES.map {|e| e.chomp.chars.map{|e| e == "#"}} # Using a Boolean grid instead of chars. 5.2s -> 4.4s perf improvement
filtered_locations = collect_walked_locations(LINES, x, y)
sum = 0
progress = 0

# Bruteforcing time, dont worry about performance it will be fine (it won't)
LINES.each_index do |j|
  LINES[y].each_index do |i|
    progress += 1
    next if LINES[j][i] == true
    next unless insert_move(filtered_locations, i, j) # Big performance gain by only checking locations where the guard can walk in the default configuration (51s -> 12s)
    LINES[j][i] = true
    stuck = infinite_loop?(LINES, x, y)
    sum += 1 if stuck
    LINES[j][i] = false # Just changing the value inside the existing Array instead of cloning it for each check. 5.5s -> 5.1s improvement
    # puts "sum = #{sum} | Progress : #{((progress.to_f/(LINES.length*LINES[0].length))*100).round(2)}% (#{progress}/#{LINES.length*LINES[0].length})" if stuck
  end
end

puts sum - 1