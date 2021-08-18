
local EditPrompt
local ColorPrompt
local DeletePrompt
local FontPrompt
local BGPrompt
local ScalePrompt
local SceneGroup = GetRandomIntInRange(0, 0xffffff)

local Scenes = {}
local CurrentScene = {}

function ScenePrompts()
    Citizen.CreateThread(function()
        local str = Config.Prompts.Edit[1]
        EditPrompt = PromptRegisterBegin()
        PromptSetControlAction(EditPrompt, Config.Prompts.Edit[2])
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(EditPrompt, str)
        PromptSetEnabled(EditPrompt, 1)
        PromptSetVisible(EditPrompt, 1)
        PromptSetStandardMode(EditPrompt,1)
        PromptSetGroup(EditPrompt, SceneGroup)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C,EditPrompt,true)
        PromptRegisterEnd(EditPrompt)

        local str2 = Config.Prompts.Delete[1]
        DeletePrompt = PromptRegisterBegin()
        PromptSetControlAction(DeletePrompt, Config.Prompts.Delete[2])
        str2 = CreateVarString(10, 'LITERAL_STRING', str2)
        PromptSetText(DeletePrompt, str2)
        PromptSetEnabled(DeletePrompt, 1)
        PromptSetVisible(DeletePrompt, 1)
        PromptSetStandardMode(DeletePrompt,1)
        PromptSetGroup(DeletePrompt, SceneGroup)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C,DeletePrompt,true)
        PromptRegisterEnd(DeletePrompt)

        local str3 = Config.Prompts.Color[1]
        ColorPrompt = PromptRegisterBegin()
        PromptSetControlAction(ColorPrompt, Config.Prompts.Color[2])
        str3 = CreateVarString(10, 'LITERAL_STRING', str3)
        PromptSetText(ColorPrompt, str3)
        PromptSetEnabled(ColorPrompt, 1)
        PromptSetVisible(ColorPrompt, 1)
        PromptSetStandardMode(ColorPrompt,1)
        PromptSetGroup(ColorPrompt, SceneGroup)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C,ColorPrompt,true)
        PromptRegisterEnd(ColorPrompt)

        local str4 = Config.Prompts.Font[1]
        FontPrompt = PromptRegisterBegin()
        PromptSetControlAction(FontPrompt, Config.Prompts.Font[2])
        str4 = CreateVarString(10, 'LITERAL_STRING', str4)
        PromptSetText(FontPrompt, str4)
        PromptSetEnabled(FontPrompt, 1)
        PromptSetVisible(FontPrompt, 1)
        PromptSetStandardMode(FontPrompt,1)
        PromptSetGroup(FontPrompt, SceneGroup)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C,FontPrompt,true)
        PromptRegisterEnd(FontPrompt)

        local str5 = Config.Prompts.BG[1]
        BGPrompt = PromptRegisterBegin()
        PromptSetControlAction(BGPrompt, Config.Prompts.BG[2])
        str5 = CreateVarString(10, 'LITERAL_STRING', str5)
        PromptSetText(BGPrompt, str5)
        PromptSetEnabled(BGPrompt, 1)
        PromptSetVisible(BGPrompt, 1)
        PromptSetStandardMode(BGPrompt,1)
        PromptSetGroup(BGPrompt, SceneGroup)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C,BGPrompt,true)
        PromptRegisterEnd(BGPrompt)

        local str6 = Config.Prompts.Scale[1]
        ScalePrompt = PromptRegisterBegin()
        PromptSetControlAction(ScalePrompt, Config.Prompts.Scale[2])
        str6 = CreateVarString(10, 'LITERAL_STRING', str6)
        PromptSetText(ScalePrompt, str6)
        PromptSetEnabled(ScalePrompt, 1)
        PromptSetVisible(ScalePrompt, 1)
        PromptSetStandardMode(ScalePrompt,1)
        PromptSetGroup(ScalePrompt, SceneGroup)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C,ScalePrompt,true)
        PromptRegisterEnd(ScalePrompt)
    end)
end

function DrawText3D(x, y, z, text,type,font,bg,scale)
    local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())  
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if onScreen then
        SetTextColor(Config.Colors[type][1],Config.Colors[type][2],Config.Colors[type][3], 215)
    	SetTextScale(scale,scale)
  		SetTextFontForCurrentCommand(font)--0,1,5,6, 9, 11, 12, 15, 18, 19, 20, 22, 24, 25, 28, 29
    	SetTextCentre(1)
    	DisplayText(str,_x,_y-0.13)
    	local factor = (string.len(text)) / 225
    	DrawSprite("feeds", "hud_menu_4a", _x, _y-(0.12+(scale/200)),(scale/20)+ factor, scale/5, 0.1, Config.Colors[bg][1],Config.Colors[bg][2],Config.Colors[bg][3], 190, 0)

    end
end

local editing = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        if editing == true then
            editing = false
        end
    end
end)

Citizen.CreateThread(function() --
    ScenePrompts()
    TriggerServerEvent("ricx_scene:getscenes")
    while true do
        Citizen.Wait(1)
        if Scenes[1] ~= nil then
            for i,v in pairs(Scenes) do
                local cc = GetEntityCoords(PlayerPedId())
                local sc =  Scenes[i].coords
                GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2, useZ)
                local dist = GetDistanceBetweenCoords(cc.x,cc.y,cc.z,sc.x,sc.y,sc.z, 1)
                if dist < Config.ViewDistance then
                    if dist < Config.EditDistance then
                        if editing == false then
                            local label  = CreateVarString(10, 'LITERAL_STRING', "Scene")
                            PromptSetActiveGroupThisFrame(SceneGroup, label)
                            if Citizen.InvokeNative(0xC92AC953F0A982AE,DeletePrompt) then
                                editing = true
                            TriggerServerEvent("ricx_scene:delete",i)
                            end
                            if Citizen.InvokeNative(0xC92AC953F0A982AE,EditPrompt) then
                                editing = true
                                TriggerServerEvent("ricx_scene:edit",i)
                            end
                            if Citizen.InvokeNative(0xC92AC953F0A982AE,ColorPrompt) then
                                editing = true
                                TriggerServerEvent("ricx_scene:color",i)
                            end
                            if Citizen.InvokeNative(0xC92AC953F0A982AE,FontPrompt) then
                                editing = true
                                TriggerServerEvent("ricx_scene:font",i)
                            end
                            if Citizen.InvokeNative(0xC92AC953F0A982AE,BGPrompt) then
                                editing = true
                                TriggerServerEvent("ricx_scene:background",i)
                            end
                            if Citizen.InvokeNative(0xC92AC953F0A982AE,ScalePrompt) then
                                editing = true
                                TriggerServerEvent("ricx_scene:scale",i)
                            end
                        else
                            print("Wait before edit")
                        end
                    end
                    DrawText3D(sc.x,sc.y,sc.z,"*"..Scenes[i].text.."*",Scenes[i].color,Scenes[i].font, Scenes[i].bg, Scenes[i].scale)
                   -- Draw3DText(sc.x,sc.y,sc.z,Scenes[i].text)
                    --print(Scenes[i].text)
                end
            end
        end
    end
end)

RegisterCommand('scene', function(source, args, raw)
    TriggerEvent("ricx_scene:start")
 end)

RegisterNetEvent('ricx_scene:sendscenes')
AddEventHandler('ricx_scene:sendscenes', function(scenes)
    Scenes = scenes
    for i,v in pairs(Scenes) do
        print(Scenes[i])
    end
end)

RegisterNetEvent('ricx_scene:client_edit')
AddEventHandler('ricx_scene:client_edit', function(nr)
    local scenetext = ""
    Citizen.CreateThread(function()
		AddTextEntry('FMMC_MPM_NA', Config.Texts.AddDetails)
		DisplayOnscreenKeyboard(0, "FMMC_MPM_NA", "", "", "", "", "", 50)
		while (UpdateOnscreenKeyboard() == 0) do
			DisableAllControlActions(0);
			Citizen.Wait(5);
		end
		if (GetOnscreenKeyboardResult()) then
            scenetext = GetOnscreenKeyboardResult()
			
            TriggerServerEvent("ricx_scene:edited",scenetext,nr)
			CancelOnscreenKeyboard()
		end
    end)
end)

RegisterNetEvent('ricx_scene:start')
AddEventHandler('ricx_scene:start', function()
    local scenetext = ""
    Citizen.CreateThread(function()
		AddTextEntry('FMMC_MPM_NA', Config.Texts.AddDetails)
		DisplayOnscreenKeyboard(0, "FMMC_MPM_NA", "", "", "", "", "", 50)
		while (UpdateOnscreenKeyboard() == 0) do
			DisableAllControlActions(0);
			Citizen.Wait(5);
		end
		if (GetOnscreenKeyboardResult()) then
            scenetext = GetOnscreenKeyboardResult()
			
            TriggerServerEvent("ricx_scene:add",scenetext,GetEntityCoords(PlayerPedId()))
			CancelOnscreenKeyboard()
		end
    end)
end)
