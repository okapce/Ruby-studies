#Test trainee Platanus - Nicholas Meyer
require "open-uri" # Allows us to send GET requests and receive the response
require "json" # Allows us to parse the reponse into a JSON object/hash

require_relative  "loadRdmPkm.rb"
require_relative  "loadType.rb"

 load_pok1 = load_pokemon()
 load_pok2 = load_pokemon()
 load_pok3 = load_pokemon()
 load_pok4 = load_pokemon()
 load_pok5 = load_pokemon()
 load_pok6 = load_pokemon()
 load_pok7 = load_pokemon()
 load_pok8 = load_pokemon()

#-------------------------------------------------------------------------------#

class Pokemon
	attr_accessor :name, :type, :hp, :atk, :def, :dmg, :spd
	
	def pokemon_details(load_pok, pok)
		begin
			json = JSON.parse(load_pok)
			pok.name = json["name"]
			puts pok.name.capitalize                             		

			pok.type = json["types"].collect { |types| types["type"]["name"] }
			puts "types: "+pok.type.at(0)+" "+ if pok.type.at(1) then pok.type.at(1).to_s  else " " end                     

			pokemonstat = json["stats"].collect { |stats| stats["base_stat"] }
			pok.hp = pokemonstat.first 				
			pok.atk = pokemonstat.at(1)		
			pok.def = pokemonstat.at(2)	
			pok.spd = pokemonstat.at(5)	

			puts "hp : "+pok.hp.to_s
		rescue TypeError
			puts "Ocurrió un error en la carga de un pokemon, intente ejecutar la aplicación nuevamente."
		end
	end

	def battle(pok1, pok2)
		#Battle damage @ https://www.math.miami.edu/~jam/azure/compendium/battdam.htm
		# ((C/D)/50)+2)*X)*Y/10)*Z)/255

		#C = attack Power
		c1 = pok1.atk
		c2 = pok2.atk
		#D = defender's Defense or Special
		d1 = pok1.def
		d2 = pok2.def
		#X = same-Type attack bonus (1 or 1.5)
		if (pok1.type.at(0) == pok2.type.at(0)) or (pok1.type.at(0) == pok2.type.at(1)) or (pok1.type.at(1) == pok2.type.at(0)) or (pok1.type.at(1) == pok2.type.at(1)) then
			x1 = 0.5
			x2 = 0.5
		else
			x1=1
			x2=1
		end

		#Y = Type modifiers (40, 20, 10, 5, 2.5, or 0)
		
		json_load_types = JSON.parse(load_types(pok1.type.at(0).to_s))
		pok1mult20 = json_load_types["damage_relations"]["double_damage_to"].collect { |double_damage_to| double_damage_to["name"]}
		
		intersection = pok1mult20 & pok2.type

		if intersection.length() == 2
			y1=40 
		elsif intersection.length() == 1
			y1=20
		else
			y1=10
		end
		
		pok1mult5 = json_load_types["damage_relations"]["half_damage_to"].collect { |half_damage_to| half_damage_to["name"]}
				
		intersection = pok1mult5 & pok2.type

		if intersection.length() == 2
			y1=2.5
		elsif intersection.length() == 1
			y1=5
		else
			y1=10
		end

		pok1mult0 = json_load_types["damage_relations"]["no_damage_to"].collect { |no_damage_to| no_damage_to["name"]}
				
		intersection = pok1mult0 & pok2.type

		if !intersection.empty? 
			y1=0
		else
			y1=10
		end

		json_load_types = JSON.parse(load_types(pok2.type.at(0).to_s))
		pok2mult20 = json_load_types["damage_relations"]["double_damage_to"].collect { |double_damage_to| double_damage_to["name"]}
						
		intersection = pok2mult20 & pok1.type

		if intersection.length() == 2
			y2=40
		elsif intersection.length() == 1
			y2=20
		else
			y2=10
		end
		
		pok2mult5 = json_load_types["damage_relations"]["half_damage_to"].collect { |half_damage_to| half_damage_to["name"]}
						
		intersection = pok2mult5 & pok1.type

		if intersection.length() == 2
			y2=2.5
		elsif intersection.length() == 1
			y2=5
		else
			y2=10
		end

		pok2mult0 = json_load_types["damage_relations"]["no_damage_to"].collect { |no_damage_to| no_damage_to["name"]}

		intersection = pok2mult0 & pok1.type

		if !intersection.empty? 
			y2=0
		else
			y2=10
		end

		#Z = a random number between 217 and 255 
		z1 = rand(217..255)
		z2 = rand(217..255)

		pok1.dmg = 25*((((((c1/d1)/50)+2)*x1)*y1/10)*z1)/255
		pok2.dmg = 25*((((((c2/d2)/50)+2)*x2)*y2/10)*z2)/255

		battleHp1 = pok1.hp
		battleHp2 = pok2.hp

		while battleHp1 >= 0 or battleHp2 >= 0 do 
			if pok1.spd > pok2.spd then
				battleHp1-=pok2.dmg          
				if battleHp1 <= 0
					return false
					break
				end
				battleHp2-=pok1.dmg          
				if battleHp2 <= 0
					return true
					break
				end	
			else
				battleHp2-=pok1.dmg          
				if battleHp2 <= 0
					return true
					break
				end	
				battleHp1-=pok2.dmg          
				if battleHp1 <= 0
					return false
					break
				end
				
			end
		end

	end

	def who_won(pok1, pok2)
		if pok1.battle(pok1, pok2) == true then
			return true
		else
			return false
		end
	end

	def announcement(pok1, pok2)
		battleHp1 = pok1.hp
		battleHp2 = pok2.hp
		if pok1.battle(pok1, pok2) == true then
			while battleHp1 > 0 or battleHp2 > 0 do 
				if pok1.spd > pok2.spd then
					if (battleHp1-=pok2.dmg)<=0 then 
						puts "HP "+pok1.name.capitalize+": 0"
						break 
					else 
						puts "HP "+pok2.name.capitalize+": "+battleHp1.to_i.to_s 
					end
					if (battleHp2-=pok1.dmg)<=0 then 
						puts "HP "+pok2.name.capitalize+": 0" 
						break 
					else 
						puts "HP "+pok2.name.capitalize+": "+battleHp2.to_i.to_s 
					end 			
				else
					if (battleHp2-=pok1.dmg)<=0 then  
						puts "HP "+pok2.name.capitalize+": 0"  
						break 
					else 
						puts "HP "+pok2.name.capitalize+": "+battleHp2.to_i.to_s 
					end
					 if (battleHp1-=pok2.dmg)<=0 then  
						puts "HP "+pok1.name.capitalize+": 0"
						break 
					else puts "HP "+pok1.name.capitalize+": "+battleHp1.to_i.to_s 
					end
				end
			end
			puts pok2.name.capitalize+" has fainted!"
			puts pok1.name.capitalize+" was stronger and has won the battle!"
		else
			while battleHp1 > 0 or battleHp2 > 0 do 
				if pok1.spd > pok2.spd then
					if (battleHp1-=pok2.dmg)<=0 then  
						puts "HP "+pok1.name.capitalize+": 0"
						break 
					else 
						puts "HP "+pok1.name.capitalize+": "+battleHp1.to_i.to_s 
					end
					if (battleHp2-=pok1.dmg)<=0 then  
						puts "HP "+pok2.name.capitalize+": 0"
						break 
					else 
						puts "HP "+pok2.name.capitalize+": "+battleHp2.to_i.to_s 
					end  			
				else
					if (battleHp2-=pok1.dmg)<=0 then  
						puts "HP "+pok2.name.capitalize+": 0"
						break 
					else 
						puts "HP "+pok2.name.capitalize+": "+battleHp2.to_i.to_s 
					end
					if (battleHp1-=pok2.dmg)<=0 then  
						puts "HP "+pok1.name.capitalize+": 0"
						break 
					else 
						puts "HP "+pok1.name.capitalize+": "+battleHp1.to_i.to_s 
					end
				end  
			end
			puts pok1.name.capitalize+" has fainted!"
			puts pok2.name.capitalize+" was stronger and has won the battle!"
		end
	end
end

puts "Round 1: Battle 1"
#pokemon 1
pok1 = Pokemon.new()

pok1.pokemon_details(load_pok1, pok1)

puts ""
puts "VERSUS: \n"
puts ""

#pokemon 2
pok2 = Pokemon.new()

pok2.pokemon_details(load_pok2, pok2)

puts ""
#Round 1 Battle 1
puts "Battle 1, Start!!!"
pok1.announcement(pok1, pok2)
begin
puts ""
puts "#---------------------------------------------------------------#"
puts "Round 1: Battle 2"
#pokemon 3
pok3 = Pokemon.new()
pok3.pokemon_details(load_pok3, pok3)

puts ""
puts "VERSUS: \n"
puts ""

#pokemon 4
pok4 =Pokemon.new()
pok4.pokemon_details(load_pok4, pok4)
puts ""
#Round 1 Battle 2
puts "Battle 2, Start!!!"
pok3.announcement(pok3, pok4)

puts ""
puts "#---------------------------------------------------------------#"
puts "Round 1: Battle 3"
#Round 1 battle 3
#pokemon 5
pok5 = Pokemon.new()
pok5.pokemon_details(load_pok5, pok5)

puts ""
puts "VERSUS: \n"
puts ""

#pokemon 6
pok6 =Pokemon.new()
pok6.pokemon_details(load_pok6, pok6)

puts ""
#BATTLE 3
puts "Battle 3, Start!!!"
pok5.announcement(pok5, pok6)

#Round 1 Battle 4
puts ""
puts "#---------------------------------------------------------------#"
puts "Round 1: Battle 4"
#pokemon 7
pok7 = Pokemon.new()
pok7.pokemon_details(load_pok7, pok7)			

puts ""
puts "VERSUS: \n"
puts ""

#pokemon 8
pok8 =Pokemon.new()
pok8.pokemon_details(load_pok8, pok8)

puts ""
#BATTLE 4
puts "Battle 4 Start!!"
pok7.announcement(pok7, pok8)

#Semi_Final Battle 5
#pokemon winner battle 1
pokSF1= Pokemon.new()

if pok1.who_won(pok1, pok2) == true then
	pokSF1 = pok1
else
	pokSF1 = pok2
end

puts ""
puts "#---------------------------------------------------------------#"
puts "Semi Finals: Battle 5"
puts "winner battle 1: "+pokSF1.name.capitalize                             		

puts "types: "+pokSF1.type.at(0)+" "+ if pokSF1.type.at(1) then pokSF1.type.at(1).to_s  else " " end                     
puts "hp : "+pokSF1.hp.to_s

puts ""
puts "VERSUS: \n"
puts ""

#pokemon winner battle 2
pokSF2= Pokemon.new()

if pok3.who_won(pok3, pok4) == true then
	pokSF2 = pok3
else
	pokSF2 = pok4
end

puts "winner battle 2: "+pokSF2.name.capitalize                             		

puts "types: "+pokSF2.type.at(0)+" "+ if pokSF2.type.at(1) then pokSF2.type.at(1).to_s  else " " end                     
puts "hp : "+pokSF2.hp.to_s

puts ""
#Semi Final BATTLE 5
puts "Semi Final Battle 5, Start!!"
pokSF1.announcement(pokSF1, pokSF2)

#Semi_Final Battle 6
#pokemon winner battle 3
pokSF3= Pokemon.new()

if pok5.who_won(pok5, pok6) == true then
	pokSF3 = pok5
else
	pokSF3 = pok6
end

puts ""
puts "#---------------------------------------------------------------#"
puts "Semi Finals: Battle 6"
puts "winner battle 3: "+pokSF3.name.capitalize                             		

puts "types: "+pokSF3.type.at(0)+" "+ if pokSF3.type.at(1) then pokSF3.type.at(1).to_s  else " " end                     
puts "hp : "+pokSF3.hp.to_s

puts ""
puts "VERSUS: \n"
puts ""

#pokemon winner battle 4
pokSF4= Pokemon.new()

if pok7.who_won(pok7, pok8) == true then
	pokSF4 = pok7
else
	pokSF4 = pok8
end

puts "winner battle 4: "+pokSF4.name.capitalize                             		

puts "types: "+pokSF4.type.at(0)+" "+ if pokSF4.type.at(1) then pokSF4.type.at(1).to_s  else " " end                     
puts "hp : "+pokSF4.hp.to_s

puts ""
#Semi Final BATTLE 6
puts "Semi Final Battle 6, Start!!"
pokSF3.announcement(pokSF3, pokSF4)

#Final Battle 7
#pokemon winner battle 5
pokFin1= Pokemon.new()

if pokSF1.who_won(pokSF1, pokSF2) == true then
	pokFin1 = pokSF1
else
	pokFin1 = pokSF2
end

puts ""
puts "#---------------------------------------------------------------#"
puts "Finals: Battle 7"
puts "winner battle 5: "+pokFin1.name.capitalize                             		

puts "types: "+pokFin1.type.at(0)+" "+ if pokFin1.type.at(1) then pokFin1.type.at(1).to_s  else " " end                     
puts "hp : "+pokFin1.hp.to_s

puts ""
puts "VERSUS: \n"
puts ""

#pokemon winner battle 6
pokFin2= Pokemon.new()

if pokSF3.who_won(pokSF3, pokSF4) == true then
	pokFin2 = pokSF3
else
	pokFin2 = pokSF4
end

puts "winner battle 6: "+pokFin2.name.capitalize                             		

puts "types: "+pokFin2.type.at(0)+" "+ if pokFin2.type.at(1) then pokFin2.type.at(1).to_s  else " " end                     
puts "hp : "+pokFin2.hp.to_s

puts ""
#Semi Final BATTLE 5
puts "Final Battle, Start!!"
pokFin1.announcement(pokFin1, pokFin2)
if pokFin1.who_won(pokFin1, pokFin2) == false then
	puts pokFin2.name.capitalize+" has won the tournament!!!!!"
else
	puts pokFin1.name.capitalize+" has won the tournament!!!!!"
end

end
