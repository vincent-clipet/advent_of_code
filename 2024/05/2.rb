lines = IO.readlines("data.txt").map(&:chomp)
lines_split_index = lines.index("")
rules = lines[0...lines_split_index].map {|line_rule| line_rule.split("|")}
books = lines[(lines_split_index+1)..-1].map {|line_page| line_page.split(",")}

# Fill hash with rules values for each page number : @previous["14"] => ["10, 12, 11"]
@previous = {}
rules.each {|rule| @previous[rule[1]] = [rule[0]] + (@previous[rule[1]] || [])}

# Returns true if the given pages are in correct order
def pages_valid?(pages)
  processed = []
  pages.each do |page|
    processed.each {|v| return false unless @previous[page].include?(v) }
    processed << page
  end
  return true
end

# Sort pages following the rules
def bubble_sort(pages)
  (0..pages.length).each do |p1|
    ((p1+1)...pages.length).each do |p2|
      if (@previous[pages[p2]].include?(pages[p1])) then
        pages[p1], pages[p2] = pages[p2], pages[p1]
      end
    end
  end
  return pages
end

puts books.sum {|pages| pages_valid?(pages) ? 0 : bubble_sort(pages)[pages.length/2].to_i}