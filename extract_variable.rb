# extract_variable.rb
#https://refactoring.com/catalog/extractVariable.html

username = "Alice"

if ( username.length > 3 && username.length <= 7 ) || ( username.downcase.start_with?("a, e, i, o, u") )
	puts "Congratulations #{username}! You won 1 million dollars!"
else
	puts "Please try again!"
end

