Robot = Struct.new(:x, :start_x, :mov_x, :y, :start_y, :mov_y)

@WIDTH = 101
@HEIGHT = 103
@ROBOTS = IO.readlines("data.txt").map do | line |
  position, movement = line.chomp.split.map {|e| e.split("=")[1].split(",").map(&:to_i) }
  Robot.new(position[0], position[0], movement[0], position[1], position[1], movement[1],)
end

def generate_grid()
  grid = Array.new(@HEIGHT).map {|e| Array.new(@WIDTH, 0)}
  @ROBOTS.each {|r| grid[r.y][r.x] += 1 }
  return grid
end

def print_grid(grid)
  puts "-" * @WIDTH
  grid.each {|line| puts line.map {|e| if e == 0 then " " else "X" end}.join("")}
end

def is_potential_tree?(grid)
  grid.each_with_index do |line, i|
    pixel = line.index {|e| e > 0 }
    next if pixel.nil? || pixel+5 >= @WIDTH
    return true if @WIDTH && grid[i][pixel+1] > 0 && grid[i][pixel+2] > 0 && grid[i][pixel+3] > 0 && grid[i][pixel+4] > 0 && grid[i][pixel+5] > 0
  end
  return false
end

def update()
  @ROBOTS.each do |r|
    r.x = (r.x + r.mov_x) % @WIDTH
    r.y = (r.y + r.mov_y) % @HEIGHT
  end
end

counter = 0
while true do
  counter += 1
  update()
  grid = generate_grid()
  if (is_potential_tree?(grid)) then
    print_grid(grid)
    puts "counter = #{counter}"
    gets
  end
end