puts "this is a msg";

END{
puts "ending of app";
}#end doesn't seem to work

BEGIN{
puts "Hello!!";
}

def sayGoodnight(name)
	#result = 
	if name =="Alex"
		puts "Go to bed, #{name}"
	else
	"Goodnight, #{name}" #"goodnight, "+name --> works too
	#return result
	end
end

puts sayGoodnight("Nicky")
puts "sleep tight!\ndon't let the bed bugs bite"
puts sayGoodnight("Alex")
puts sayGoodnight("William")
puts ""

empty=[]
empty2= Array.new
empty[0]="first"
empty[2]="last"


puts "Array is #{empty}"#expressed with [ ]
puts empty #expressed with just string seperated by lines
puts "same as before, but with a iteration: "
empty.each do |i|
	puts i
end

empty2 = %w{test1 test2 33} #doesn't need "," or quotes if you put %w before
puts empty2

#[] for arrays {} for hashes

testHash={
"usa"=> "more or less",
"netherlands"=> "great",
"japan"=>"good",
"chile"=>"ok",
"costa rica"=>"good",
"russia"=>"bad",
"saudi arabia"=>"terrible",
"uk"=>"ok",
"spain"=>"ok"
}

puts " "
puts "Russia is "+testHash['russia']+" to move to"

testHash["china"]="more or less"
puts "China is "+testHash['china']+" to move to"

testHash['uk']=testHash['uk']*3
puts testHash['uk']
puts ""
testHash.each do |key, value|
	puts key, " is ", value, "\n" #if puts, it wil print by line, 
	#if print, concat sentence. \n is necesarry othwerwise all is concat
end


class Customer
	@@no_customers=0 #class variable
	def initialize(id, name, addr)
		@cust_id=id #instance variable
		@cust_name=name #instance variable
		@cust_addr=addr #instance variable
	end
	def display_details()
		puts "Customer id #@cust_id"
		puts "Customer name #@cust_name"
		puts "Customer address #@cust_addr"
	end
	def total_no_customers()
		@@no_customers+=1
		puts "Total number of customers: #@@no_customers"
	end
end

cust1= Customer.new(1, "Nick", "Victor Rae")
cust2= Customer.new(2, "Alex", "Simon Bolivar")
puts ""

cust1.display_details()
cust2.display_details()
cust1.total_no_customers()
cust2.total_no_customers()

def counter(value)
weight=value
	while weight < 10 
		weight += 1
		puts "the weight is: #{weight}"
	end
end
puts ""

counter(0)

$global_variable = 10

def printglob
puts "Global var is #$global_variable"
end


puts ""
(10..15).each do |n|
	print n, " "
end

MR_COUNT = 0         # constant defined on main Object class
#:: can be used ONLY with constants
module Foo
   MR_COUNT = 0
   ::MR_COUNT = 1    # set global count to 1
   MR_COUNT = 2      # set local count to 2
end
puts MR_COUNT        # this is the global constant
puts Foo::MR_COUNT 

