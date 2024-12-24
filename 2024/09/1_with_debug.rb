
LINE = IO.readlines("data.txt")[0].chomp.chars.map(&:to_i)

def print_disk(disk)
  a = Array.new(disk.length, " ")
  disk.each_with_index do |block, i|
    if block.nil? || block == " " then
      a[i] = "."
    else
      a[i] = block.id
    end
  end
  puts a.join("")
end

def compact_disk(disk, available_blocks, used_blocks)
  first_empty_block_index = available_blocks.shift
  last_data_block_index = used_blocks.pop
  # puts "first_empty_block_index = #{first_empty_block_index} | last_data_block_index = #{last_data_block_index}"
  return true if first_empty_block_index >= last_data_block_index
  disk[first_empty_block_index] = disk[last_data_block_index]
  disk[last_data_block_index] = nil
  available_blocks.push(last_data_block_index) # Useless ?
  used_blocks.unshift(first_empty_block_index) # Useless ?
  return false
end



Block = Struct.new(:id, :length)
id_generator = 0                # Used to give each data block a unique ID
index = 0                       # Current block index being written
is_empty = false                # Flag switching on/off constantly to parse a data block or an empty block
disk = Array.new(LINE.sum, " ") # Disk state. " " => untouched. nil => empty block. Object => data block
available_blocks = []           # List of indexes of all empty blocks
used_blocks = []                # List of indexes of all data blocks

# Building the lists of available & empty blocks
LINE.each_with_index do |v|
  if is_empty then
    (index...(index+v)).each do |i|
      disk[i] = nil
      available_blocks << i
    end
    is_empty = false
  else
    b = Block.new(id_generator, v)
    id_generator += 1
    (index...(index+v)).each do |i|
      disk[i] = b
      used_blocks << i
    end
    is_empty = true
  end
  index += v
end

# Compacting data until no empty blocks left at the beginning of the disk
fully_compacted = false
until fully_compacted do 
  # print_disk(disk)
  fully_compacted = compact_disk(disk, available_blocks, used_blocks)
end

puts disk.each_with_index.sum {|e, i| e.nil? ? 0 : e.id * i}  