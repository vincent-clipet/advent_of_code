
def compact(disk, empty_blocks_list, data_blocks_list)
  max_id = data_blocks_list[0].id
  max_id.downto(0).each do |id|
    data_block = data_blocks_list.find {|e| e.id == id}
    valid_empty_block = empty_blocks_list.find {|e| e.length >= data_block.length}
    next if valid_empty_block.nil? # No valid EmptyBlock found
    next if valid_empty_block.index > data_block.index # DataBlock already in best possible location

     # Data block & empty block have the same size, we just swap their indexes
    if (data_block.length == valid_empty_block.length) then
      data_block.index, valid_empty_block.index = valid_empty_block.index, data_block.index
      (data_block.index...(data_block.index+data_block.length)).each {|i| disk[i] = data_block}
      (valid_empty_block.index...(valid_empty_block.index+valid_empty_block.length)).each {|i| disk[i] = nil}
    # Data block is smaller than the empty block, we need to create a new empty block
    else
      delta = valid_empty_block.length - data_block.length
      data_block.index, valid_empty_block.index = valid_empty_block.index, data_block.index
      valid_empty_block.length -= delta
      new_empty_block = EmptyBlock.new(data_block.index + data_block.length, delta)
      empty_blocks_list << new_empty_block
      (data_block.index...(data_block.index+data_block.length)).each {|i| disk[i] = data_block}
      (valid_empty_block.index...(valid_empty_block.index+valid_empty_block.length)).each {|i| disk[i] = nil}
      (new_empty_block.index...(new_empty_block.index+new_empty_block.length)).each {|i| disk[i] = nil}
    end

    data_blocks_list.sort! {|a,b| a.index <=> b.index} # Very slow, would be much faster by manually inserting the modified DataBlock at a spcific index
    empty_blocks_list.sort! {|a,b| a.index <=> b.index} # Very slow too
    merge_empty_blocks(empty_blocks_list)
  end
end

# Merges 2 adjacent empty blocks into 1
def merge_empty_blocks(empty_blocks_list)
  index = 0
  while index+1 < empty_blocks_list.size do 
    a = empty_blocks_list[index]
    b = empty_blocks_list[index+1]
    if (a.index + a.length == b.index) then
      a.length += b.length
      empty_blocks_list.delete(b)
    else
      index += 1
    end
  end
end



LINE = IO.readlines("data.txt")[0].chomp.chars.map(&:to_i)
DataBlock = Struct.new(:id, :index, :length)
EmptyBlock = Struct.new(:index, :length)
id_generator = 0                # Used to give each data block a unique ID
index = 0                       # Current block index being written
is_empty = false                # Flag switching on/off constantly to parse a data block or an empty block
disk = Array.new(LINE.sum, " ") # Disk state. " " => untouched. nil => empty block. Object => data block
data_blocks_list = []           # List of DataBlocks
empty_blocks_list = []          # List of EmptyBlocks

# Building the lists of available & empty blocks
LINE.each_with_index do |v|
  if is_empty then
    b = EmptyBlock.new(index, v)
    empty_blocks_list << b
    (index...(index+v)).each {|i| disk[i] = nil}
    is_empty = false
  else
    b = DataBlock.new(id_generator, index, v)
    data_blocks_list << b
    id_generator += 1
    (index...(index+v)).each {|i| disk[i] = b}
    is_empty = true
  end
  index += v
end

data_blocks_list.reverse!
compact(disk, empty_blocks_list, data_blocks_list)

puts disk.each_with_index.sum {|e, i| e.nil? ? 0 : e.id * i}  