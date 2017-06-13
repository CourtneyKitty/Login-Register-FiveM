require "resources/mysql-async/lib/MySQL"

--IF YOU CHANGE SHIT AND BREAK IT DON'T FUCKING ANNOY ME ON THE FORUMS CAUSE U BROKE IT.
function getPlayerIdentifierEasyMode(source)


    local rawIdentifiers = GetPlayerIdentifiers(source)

    if rawIdentifiers then
        
        for key, value in pairs(rawIdentifiers) do
            
            playerIdentifier = value
            
        end
        
    else
    
        return false
        
    end
    
    return playerIdentifier -- should usually be only 1 identifier according to the wiki
    
end
TriggerEvent('es:addCommand', 'register', function(source, args, user)

    local playerIdentifier = getPlayerIdentifierEasyMode(source)
    local password = args[2]
    local fname = args[3] -- player id
    local lname = args[4]
    local description = table.concat(args, " ", 5)
    if password == nil or type(tostring(password)) == nil or type(tonumber(password)) == nil or fname == nil or type(tostring(fname)) == nil or type(tonumber(fname)) == nil or lname == nil or type(tostring(lname)) == nil  or type(tonumber(lname)) == nil or description == nil or type(tostring(description)) == nil then
        TriggerClientEvent("chatMessage", source, "SYSTEM", { 247, 98, 31 }, "^1Example^7: /^3register ^7[^3password^7] [^3first name^7] [^3second name^7] [^3description^7]")

    else
        MySQL.Async.fetchAll("SELECT * FROM characters WHERE identifier = @identifier", {['@identifier'] = playerIdentifier}, function(result)

            if result[1] == nil then
                print("hello?")
                MySQL.Async.execute("INSERT INTO characters (`identifier`) VALUES (@identifier)", { ['@identifier'] = playerIdentifier})
                MySQL.Async.execute("UPDATE characters SET password=@pass,fname=@fname,lname=@lname,description=@desc,logincheck=@check WHERE identifier = @identifier", { ['@identifier'] = playerIdentifier,['@pass'] = password,['@fname'] = fname,['@lname'] = lname,['@desc'] = description,['@check'] = 1})
                TriggerClientEvent("character:register", source)
            else
                TriggerClientEvent("chatMessage", source, "SYSTEM", { 247, 98, 31 }, "^1You have already registered!")          
            end
        end)
    end
end)

local attempt = 0
TriggerEvent('es:addCommand', 'login', function(source, args, user)

    local playerIdentifier = getPlayerIdentifierEasyMode(source)
    local password = args[2]
    MySQL.Async.fetchAll("SELECT * FROM characters WHERE identifier = @identifier", {['@identifier'] = playerIdentifier}, function(result)
    	if password == nil or type(tostring(password)) == nil then
    
        	TriggerClientEvent("chatMessage", source, "SYSTEM", { 247, 98, 31 }, "^1Example^7: /^3login ^7[^3password^7]")
        elseif result[1] == nil then
            TriggerClientEvent("chatMessage", source, "SYSTEM", { 247, 98, 31 }, "^1You haven't even registered!")         
    	else
    		if password == result[1].password and result[1].logincheck == 0 then
    			MySQL.Async.execute("UPDATE logincheck=@check WHERE identifier = @identifier", { ['@identifier'] = playerIdentifier,['@check'] = 1})
    			TriggerClientEvent("character:login", source)
    		elseif password == result[1].password and result[1].logincheck == 1 then
    			TriggerClientEvent("chatMessage", source, "SYSTEM", { 247, 98, 31 }, "^1You have already logged in!")
    		elseif password ~= result[1].password and result[1].logincheck == 1 then
    			TriggerClientEvent("chatMessage", source, "SYSTEM", { 247, 98, 31 }, "^1You have already logged in!")
    		elseif password ~= result[1].password and result[1].logincheck == 0 then
    			attempt = attempt + 1
    			TriggerClientEvent("chatMessage", source, "SYSTEM", { 247, 98, 31 }, "^1You have entered your password incorrectly! ("..attempt.."/3")
    			if attempt == 3 then
    				local reason = "You have failed to enter your password 3 times!"
    				DropPlayer(source,reason)
    			end
            else
                attempt = attempt + 1
                TriggerClientEvent("chatMessage", source, "SYSTEM", { 247, 98, 31 }, "^1You have entered your password incorrectly! ("..attempt.."/3")
                if attempt == 3 then
                    local reason = "You have failed to enter your password 3 times!"
                    DropPlayer(source,reason)
                end
    		end
    	end
    end)
end)

AddEventHandler('playerDropped', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    identifier = user.identifier
    MySQL.Async.execute("UPDATE characters set logincheck=@check WHERE identifier = @identifier", { ['@identifier'] = identifier,['@check'] = 0})
  end)
end)