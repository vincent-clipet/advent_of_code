require 'set'

LINES = IO.readlines("data.txt").map {| line | line.chomp.chars}

def get_antinodes_with_resonance(antinodes, antenna_a, antenna_b)
  delta_x = antenna_a[1] - antenna_b[1]
  delta_y = antenna_a[0] - antenna_b[0]
  ret = []
  x = antenna_a[1]
  y = antenna_a[0]

  while !oob(antinodes, x, y) do
    ret << [x, y]
    x += delta_x
    y += delta_y
  end

  return ret
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
    antinodes_with_resonance = get_antinodes_with_resonance(LINES, coordinates[0], coordinates[1])
    antinodes.merge(antinodes_with_resonance)
  end
end

puts antinodes.size