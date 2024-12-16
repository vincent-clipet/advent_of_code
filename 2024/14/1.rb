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

def print_grid()
  puts "-" * @WIDTH + "\n" + generate_grid().map{|line| line.join("")}.join("\n")
end

def print_solution()
  grid = generate_grid()
  q1 = grid[0...(@HEIGHT/2)].sum   {|line| line[0...(@WIDTH/2)].sum}
  q2 = grid[0...(@HEIGHT/2)].sum   {|line| line[(1+@WIDTH/2)..-1].sum}
  q3 = grid[(1+@HEIGHT/2)..-1].sum {|line| line[0...(@WIDTH/2)].sum}
  q4 = grid[(1+@HEIGHT/2)..-1].sum {|line| line[(1+@WIDTH/2)..-1].sum}
  puts "#{q1} * #{q2} * #{q3} * #{q4} = #{q1*q2*q3*q4}"
end

def update()
  @ROBOTS.each do |r|
    r.x = (r.x + r.mov_x) % @WIDTH
    r.y = (r.y + r.mov_y) % @HEIGHT
  end
end

100.times {update()}
print_grid()
print_solution()