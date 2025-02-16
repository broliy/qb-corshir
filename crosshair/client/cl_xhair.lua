local xhairActive = false
local disableXhair = false

local weapons = {
	'WEAPON_KNIFE',
	'WEAPON_SWITCHBLADE',
	'WEAPON_NIGHTSTICK',
	'WEAPON_BREAD',
	'WEAPON_FLASHLIGHT',
	'WEAPON_HAMMER',
	'WEAPON_BAT',
	'WEAPON_GOLFCLUB',
	'WEAPON_CROWBAR',
	'WEAPON_BOTTLE',
	'WEAPON_DAGGER',
	'WEAPON_HATCHET',
	'WEAPON_MACHETE',
	'WEAPON_BATTLEAXE',
	'WEAPON_POOLCUE',
	'WEAPON_WRENCH',
}

RegisterCommand("crosshair", function()
    disableXhair = not disableXhair
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local get_ped = PlayerPedId()
        local get_ped_veh = GetVehiclePedIsIn(get_ped, false)
        local weapon = GetSelectedPedWeapon(PlayerPedId())
        if not disableXhair and not xhairActive and IsPedArmed(get_ped, 7) and IsControlPressed(0, 25) then
            xhairActive = true
            SendNUIMessage("xhairShow")
        elseif IsControlReleased(0, 25) then 
            xhairActive = false
            SendNUIMessage("xhairHide")
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local weapon = GetSelectedPedWeapon(PlayerPedId())
        local get_ped = PlayerPedId()
        local get_ped_veh = GetVehiclePedIsIn(get_ped, false)
        if CheckWeapon(weapon) then
            xhairActive = false
            SendNUIMessage("xhairHide")
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if IsPedInCover(PlayerPedId(), 0) and not IsPedAimingFromCover(PlayerPedId()) then
            DisablePlayerFiring(PlayerPedId(), true)
        end
        Citizen.Wait(0)
    end
end)

function CheckWeapon(weapon)
	for i = 1, #weapons do
		if GetHashKey(weapons[i]) == weapon then
			return true
		end
	end
	return false
end