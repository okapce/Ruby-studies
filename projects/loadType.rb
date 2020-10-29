require "open-uri" # Allows us to send GET requests and receive the response
require "json" 	   # Allows us to parse the reponse into a JSON object/hash

def load_types(type_get)
	begin
	URI.open("https://pokeapi.co/api/v2/type/"+type_get.to_s+"/").read
	rescue OpenURI::HTTPError
		puts "Error: No se pudo conectar al sitio, por favor, intente nuevamente."
		
	rescue
		puts "Error: No se pudo conectar al sitio, por favor, intente nuevamente."
		
	end
end