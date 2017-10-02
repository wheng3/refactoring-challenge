# introduce_parameter_object.rb
#http://refactoring.com/catalog/introduceParameterObject.html

class GamePackageCalculator

	BASIC_PACKAGE_FACTOR = 1.0
	PREMIUM_PACKAGE_FACTOR = 2.1
	BASIC_RATE = 1
	PREMIUM_RATE = 2
	GOLD_LIFE_RATIO = 0.2
	POWERUPS_LIFE_RATIO = 0.5


	#calculates the cost of a gamer who wants to get X gold, Y powerup and number of lives derived from X gold and Y powerup. 
	def calculate_cost(gold, powerups, premium = nil)
		if premium
			premium_cost(gold, powerups) 
		else
			basic_cost(gold, powerups)
		end
	end	

	private 

	def calculate_lives(gold, powerups)
		(gold * GOLD_LIFE_RATIO ).round(0) + (powerups * POWERUPS_LIFE_RATIO).round(0) 
	end


	def premium_cost(gold, powerups)
		lives = calculate_lives(gold, powerups)
		PREMIUM_PACKAGE_FACTOR * lives + PREMIUM_RATE * (gold + powerups)
	end

	def basic_cost(gold, powerups)
		lives = calculate_lives(gold, powerups)
		BASIC_PACKAGE_FACTOR * lives + BASIC_RATE * (gold + powerups)
	end

end