test_file = File.open(ARGV[0]).each_line.to_a.map(&:strip)

File.open(ARGV[0]).each_line.to_a.map(&:strip).each_with_index do |line, index|
  next if line == test_file[index]
  raise "Discrepancy found on line #{index}"
end

p 'Test successful !'
