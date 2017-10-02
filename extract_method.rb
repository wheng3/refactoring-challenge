#extract_method.rb
#use this as tips for the first one : http://refactoring.com/catalog/extractMethod.html
def valid_length_and_start_with?(username, *args)
	return ( username.length > 3 && username.length <= 10 ) || ( username.downcase.start_with?(*args) )
end

username = "Alice"

if valid_length_and_start_with?(username, ["a", "e", "i", "o", "u"])
	puts "Congratulations #{username}! You won 10 dollars!"
else
	puts "Thanks for joining!"
end

username = "Bobby"

if (valid_length_and_start_with?(username, ["b", "g", "l", "p"]))
	puts "Congratulations #{username}! You won 50 dollars!"
else
	puts "Thanks for joining!"
end

username = "Xena"

if (valid_length_and_start_with?(username, ["q", "u", "x", "y", "z"]))
	puts "Congratulations #{username}! You won 100 dollars!"
else
	puts "Thanks for joining!"
end