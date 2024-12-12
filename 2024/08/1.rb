require 'set'

LINES = IO.readlines("data.txt").map {| line | line.chomp.chars}

def get_antinode(antinodes, antenna_a, antenna_b)
  delta_x = antenna_a[1] - antenna_b[1]
  delta_y = antenna_a[0] - antenna_b[0]
  return nil if oob(antinodes, antenna_a[1]+delta_x, antenna_a[0]+delta_y)
  return [antenna_a[1]+delta_x, antenna_a[0]+delta_y]
end

def oob(grid, x, y)
  return (y < 0 || y >= grid.length || x < 0 || x >= grid[0].length)
end

antennas = {}
antinodes = Set[]

LINES.each_index do |y|
  LINES[0].each_index do |x|
    char = LINES[y][x]
    next if char == "."
    antennas[char] = [] if antennas[char].nil?
    antennas[char] << [y, x]
  end
end

antennas.each do |type, list|
  list.permutation(2).each do |coordinates|
    antinode = get_antinode(LINES, coordinates[0], coordinates[1])
    antinodes.add(antinode) unless antinode.nil?
  end
end

puts antinodes.size