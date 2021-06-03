#!/usr/bin/env ruby

def ma_fonction
	puts "ma premiere fonction"
	nom = gets.chomp
	puts "signe: " + nom
	return nom
end

nom = ma_fonction
puts "Merci #{nom}"

puts "coucou ça marche" if nom == "nicolas"

i=0
nombre = 777
while i < 10
	if i == nombre
		puts "Trouvé"
		break
	else
		i = i + 1 
		puts "#{i} coups restants"
	end
end	
