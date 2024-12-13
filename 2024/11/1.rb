line = IO.readlines("data.txt")[0].chomp.split.map(&:to_i)

def blink(a)
  ret = []
  a.each do |i|
    if i == 0 then
      ret << 1
    elsif i.digits.size % 2 == 0 then
      center = 10**(i.digits.size / 2)
      ret << i / center
      ret << i % center
    else
      ret << i * 2024
    end
  end
  return ret
end

25.times {|i| line = blink(line)}
puts line.size.to_s