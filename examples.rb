use this as tips for the first one : http://refactoring.com/catalog/extractMethod.html
this for the second: http://refactoring.com/catalog/introduceParameterObject.html
class ReceiptPrinter
COST = {
meat' => 5,
milk' => 3,
candy' => 1,
}

TAX = 0.05

def initialize(output: $stdout, items:)
@output = output
@items = items
end

def print
subtotal = items.reduce(0) do |sum, item|
item_cost = COST[item]
output.puts "#{item}: #{sprintf('$%.2f', item_cost)}"

sum + item_cost.to_i
end

output.puts divider
output.puts "subtotal: #{sprintf('$%.2f', subtotal)}"
output.puts "tax: #{sprintf('$%.2f', subtotal * TAX)}"
output.puts divider
output.puts "total: #{sprintf('$%.2f', subtotal + (subtotal * TAX))}"
end

private

attr_reader :output, :items

def divider
-' * 13
end
end```

[9:59]
``` ```class ShippingCalculator
EXPRESS_CONVERSION_FACTOR = 3.33
EXPRESS_RATE = 4.25
NORMAL_CONVERSION_FACTOR = 6.67
NORMAL_RATE = 2.75

def calculate_cost(height, length, weight, width, express=nil)
volume = find_volume(height, length, width)

if express
express_shipping(volume, weight)
else
normal_shipping(volume, weight)
end
end

private

def find_volume(height, length, width)
height * length * width
end

def express_shipping(volume, weight)
cost = volume * (weight / EXPRESS_CONVERSION_FACTOR) * EXPRESS_RATE
cost.round(2)
end

def normal_shipping(volume, weight)
cost = volume * (weight / NORMAL_CONVERSION_FACTOR) * NORMAL_RATE
cost.round(2)
end
end