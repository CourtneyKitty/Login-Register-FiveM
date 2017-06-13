--IF YOU CHANGE SHIT AND BREAK IT DON'T FUCKING ANNOY ME ON THE FORUMS CAUSE U BROKE IT.

local uiopen = false
local timeuntilkicked = 0
firstspawn = true
AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == true then
		FreezeEntityPosition(GetPlayerPed(-1), true)
		uiopen = true
		timeuntilkicked = 300
		firstspawn = false
	end
end)

Citizen.CreateThread(function()
  	while true do
    	if uiopen then
    		openGui()
    	end
    	if timeuntilkicked == 1 then
    		TriggerServerEvent("login:kick",source)
    	end
    Citizen.Wait(500)
  	end
end)
Citizen.CreateThread(function()
  	while true do
    	if uiopen then
    		timeuntilkicked = timeuntilkicked - 1
    	end
    Citizen.Wait(1000)
  	end
end)
Citizen.CreateThread(function()
  	while true do
    	if uiopen then
			drawTxt(0.66, 1.45, 1.0,1.0,0.4, "Time until kicked: ~r~"..timeuntilkicked.."", 255, 255, 255, 255)
			drawTxt(1.00, 1.45, 1.0,1.0,0.4, "/~r~register ~g~password ~b~F~w~name ~b~L~w~name ~b~Description", 255, 255, 255, 255)
    	end
    Citizen.Wait(0)
  	end
end)
RegisterNetEvent("character:register")
AddEventHandler("character:register", function()
	FreezeEntityPosition(GetPlayerPed(-1), false)
	closeGui()
	DrawMissionText("~h~Welcome to ~r~NEW~w~YORK~b~CITY~w~ Role Play! ", 5000)
end)

RegisterNetEvent("character:login")
AddEventHandler("character:login", function()
	FreezeEntityPosition(GetPlayerPed(-1), false)
	closeGui()
	DrawMissionText("~h~Welcome back to to ~r~NEW~w~YORK~b~CITY~w~ Role Play!", 5000)
end)

RegisterNetEvent("character:reset")
AddEventHandler("character:reset", function()
	FreezeEntityPosition(GetPlayerPed(-1), false)
	closeGui()
	firstspawn = false
end)

function DrawMissionText(m_text, showtime)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(m_text)
    DrawSubtitleTimed(showtime, 1)
end

function openGui()
  --SetNuiFocus(true)
  SendNUIMessage({openQuestion = true})
end

function closeGui()
  uiopen = false
  --SetNuiFocus(false)
  SendNUIMessage({openQuestion = false})
  --DrawMissionText("~h~Register or Login using /register or /login!", 5000)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
        SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

Citizen.CreateThread(function()
  while true do
    if uiopen then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
      --if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
      --  SendNUIMessage({type = "click"})
      --end
    end
    Citizen.Wait(0)
  end
end)
--]]