local Model = {}

local Json = require "json"


function Model:new()
	local loadFromFile
	local saveToFile
	local checkExists
	
	local m = {}
	m.shapesLevels = nil
	m.userData = nil
	
	

	function loadFromFile( filename, base )
		local contents
		base = base or  system.ResourceDirectory
		local filePath = system.pathForFile( filename, base )
	    print("LoadFrom: ".. filePath)
		local file = io.open( filePath, "r" )
		if file then
			-- read all contents of file into a string
			contents = file:read( "*a" )
			file:close()
		end
		return contents
	end
	
	function saveToFile(data, filename, base)
		base = base or system.DocumentsDirectory
	    local filePath = system.pathForFile( filename or "data.txt", base )
	    print("Saveto: "..filePath)
	    local file = io.open( filePath, "w" )
		
		if file then
	    	file:write(data)
			file:close()
	  	else 
	  		print("Unable to save file: "..filePath)
	  	end
	end
	
	function checkExists(filename, base)
		base = base or  system.DocumentsDirectory
		local path = system.pathForFile( filename, base )
		local file = io.open( path, "r" )
		if file then		
			file:close()
			return true
		end
		return false
	end
	
	function m:saveUserData(data)
		if data then 
			local encoded = Json.encode(data)
			saveToFile(encoded, "userData.json", system.DocumentsDirectory)
		end
	end
	
	function m:loadUserData()
		local data = loadFromFile("userData.json", system.DocumentsDirectory)
		if not data then 
			data = loadFromFile("userDataTemplate.json", system.ResourceDirectory) 
			print("READ template data")
		end
		if data then 
			return Json.decode(data)
		end
		return false
	end
	
	function m:loadConfiguration()
		local data = loadFromFile("configurationData.json")
		if data then
			return Json.decode(data)
		end
		return false
	end
	
	function m:removeSelf()
		m = nil
	end
	
	return m
end

return Model