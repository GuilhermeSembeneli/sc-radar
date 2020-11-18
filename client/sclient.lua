---------------------------------------------------------------------------------------------------------
--VARIABLES
---------------------------------------------------------------------------------------------------------
local ped = PlayerPedId()
local time = false
---------------------------------------------------------------------------------------------------------
--THREAD
---------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do 
        local speed = GetEntitySpeed(ped)*3.60
        local ScTime = 1000
        local position = GetEntityCoords(ped)
        veh = GetVehiclePedIsIn(ped)
        if IsEntityAVehicle(veh) then
            if GetPedInVehicleSeat(veh, -1) then
                for k,v in pairs(SCconfig.Radar) do
                    local distance = GetDistanceBetweenCoords(position, vector3(v.x, v.y, v.z), true)
                    if distance < 55 then
                        ScTime = 1
                        if veh then
                            drawTxt(" Limite Permitido ~r~"..v.speed.."~w~Km/h",4,0.5,0.92,0.35,255,255,255,255)
                        end
                    end
                    if distance < v.distance then 
                        ScTime = 1
                        if speed >= v.speed then
                            drawTxt("~p~Limite de velocidade ultrapassado!~w~",4,0.08,0.75,0.38,255,255,255,255)
                            if not time then
                                PlaySoundFrontend( -1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", true );
                                TriggerServerEvent("sc:payment:radar", v.pay)
                                time = true
                                SetTimeout(1000, function()
                                        time = false
                                end)
                            end
                        end
                    end
                end
            end
        else
        ScTime = 5000
        RemoveBlip(blip)
        end
        Citizen.Wait(ScTime)
    end
end)


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        if not DoesBlipExist(blip) then
            if  IsEntityAVehicle(veh) then
                for k,v in pairs(SCconfig.Radar) do
                    blip = AddBlipForCoord(v.x, v.y, v.z)
                    SetBlipSprite(blip, v.id)
                    SetBlipColour(blip, v.color)
                    SetBlipScale(blip, v.scale)
                    SetBlipAsShortRange(blip, true)
                    BeginTextCommandSetBlipName("STRING");
                    AddTextComponentString(v.name)
                    EndTextCommandSetBlipName(blip)
                end
            end
        end
    end 
end)

---------------------------------------------------------------------------------------------------------
--Function
---------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end