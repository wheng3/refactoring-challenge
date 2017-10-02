# extract_variable.rb
#https://refactoring.com/catalog/extractVariable.html
def valid_length_and_start_with?(username, *args)
	return ( username.length > 3 && username.length <= 7 ) || ( username.downcase.start_with?(*args) )
end
username = "Alice"

if valid_length_and_start_with?(username, ["a", "e", "i", "o", "u"])
	puts "Congratulations #{username}! You won 1 million dollars!"
else
	puts "Please try again!"
end

