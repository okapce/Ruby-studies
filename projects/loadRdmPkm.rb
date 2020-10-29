require "open-uri" # Allows us to send GET requests and receive the response
require "json" # Allows us to parse the reponse into a JSON object/hash

def load_pokemon()
	begin
	URI.open("http://pokeapi.co/api/v2/pokemon/"+rand(151).to_s+"/").read
	rescue OpenURI::HTTPError
		puts "Error: No se pudo conectar al sitio, por favor, intente nuevamente."
		
	rescue
		puts "Error: No se pudo conectar al sitio, por favor, intente nuevamente."
		
	end

end