puts '0~9の数字を入力してね'
input = gets.chomp.to_i
randn = rand(10)
puts "Your choice: #{input}"
puts "My choice: #{randn}"
if input > randn
  puts 'You win!'
elsif input < randn
  puts 'I win!'
else
  puts 'Draw'
end
