-- Create a menu for the animations
local animations_menu = RageUI.CreateMenu("Animations", "Select an animation to play")
animations_menu:SetStyleSize(200)
animations_menu:DisplayPageCounter(true)
local results_menu = RageUI.CreateSubMenu(animations_menu, "Results", "Results of the search")
results_menu:DisplayPageCounter(true)
local dict_menu = RageUI.CreateSubMenu(animations_menu, "Dictionary", "Animations of the dictionary")

local open = false
local results = {}
local dict = nil
local inAnim = false
local previousAnim = nil
animations_menu.Closed = function()
    open = false
    RageUI.Visible(animations_menu, false)
    ClearPedTasksImmediately(GetPlayerPed(-1))
    inAnim = false
    previousAnim = nil
    index = 1
end

local index = 1
local animation_list = {}
local animation_list_page = {}
local all_indexes = {}
local max_pages = 0
local path_to_animations = "animDictsCompact.json"

-- Create a thread to load the animations

Citizen.CreateThread(function()
    local fileJson = LoadResourceFile(GetCurrentResourceName(), path_to_animations)
    if fileJson then
        animation_list = json.decode(fileJson)
    end

    for k, v in pairs(animation_list) do
        if not DoesAnimDictExist(v.DictionaryName) then
            table.remove(animation_list, k)
        end
    end
    max_pages = math.ceil(#animation_list / 8)
    for i = 1, max_pages do
        local page = {}
        for k = (i - 1) * 8 + 1, i * 8 do
            if animation_list[k] then
                table.insert(page, animation_list[k])
            end
        end
        table.insert(animation_list_page, page)
        table.insert(all_indexes, i)
    end
end)


RegisterNetEvent('mth-animations:menu', function()
    OpenAnimationsMenu()
end)

function OpenAnimationsMenu()
    if open then
        open = false
        RageUI.Visible(animations_menu, false)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        inAnim = false
        previousAnim = nil
        index = 1
        return
    else
        open = true
        RageUI.Visible(animations_menu, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(animations_menu, function()
                    -- add a button to search an animation
                    RageUI.Button("Search for an animation", nil, { RightLabel = "→→→" }, true, {
                        onSelected = function()
                            local result = KeyboardInput("Search for an animation")
                            if result then
                                -- when the search is done, display all the results in a list
                                results = {}
                                -- for each dict, check if the search is in the animations names
                                for k, v in pairs(animation_list) do
                                    for k2, v2 in pairs(v.Animations) do
                                        if string.find(string.lower(v2), string.lower(result)) then
                                            table.insert(results, { v.DictionaryName, v2 })
                                        end
                                    end
                                end
                            end
                        end
                    }, results_menu)
                    -- add a button for each page
                    for k, v in pairs(animation_list_page[index]) do
                        RageUI.Button(v.DictionaryName, nil, { RightLabel = ">" }, true, {
                            onSelected = function()
                                -- when the button is selected, display all the animations of the dictionary
                                dict = k
                            end
                        }, dict_menu)
                    end
                    RageUI.List("Page", all_indexes, index, nil, {}, true, {
                        onListChange = function(Index)
                            index = Index
                        end,
                        onSelected = function()
                            local result = KeyboardInput("Page number")
                            if result and tonumber(result) and tonumber(result) <= max_pages and tonumber(result) > 0 then
                                index = tonumber(result)
                            end
                        end
                    })
                end)
                RageUI.IsVisible(results_menu, function()
                    -- add a button for each result
                    if #results > 0 then
                        for k, v in pairs(results) do
                            RageUI.Button(v[2], "DictionaryName : " .. v[1], { RightLabel = ">" }, true, {
                                onSelected = function()
                                    -- when the button is selected, play the animation
                                    PlayAnimation(v[1], v[2])
                                end
                            })
                        end
                    else
                        RageUI.Separator("No results")
                    end
                end)
                RageUI.IsVisible(dict_menu, function()
                    -- set the menu subtitle to the current dictionary
                    dict_menu.Subtitle = animation_list_page[index][dict].DictionaryName
                    -- add a button for each animation of the dictionary
                    for k, v in pairs(animation_list_page[index][dict].Animations) do
                        RageUI.Button(v, nil, { RightLabel = "→→→" }, true, {
                            onSelected = function()
                                -- when the button is selected, play the animation
                                PlayAnimation(animation_list_page[index][dict].DictionaryName, v)
                            end
                        })
                    end
                end)
                Wait(0)
            end
        end)
    end
end


function PlayAnimation(dict, anim)
    if inAnim and tostring(anim) == tostring(previousAnim) then
        ClearPedTasksImmediately(GetPlayerPed(-1))
        inAnim = false
    elseif inAnim then
        ClearPedTasksImmediately(GetPlayerPed(-1))
        local player = GetPlayerPed(-1)
        -- load the animation
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
        -- play the animation
        TaskPlayAnim(player, dict, anim, 8.0, 8.0, -1, 1, 0, false, false, false)
    else
        inAnim = true
        previousAnim = anim
        local player = GetPlayerPed(-1)
        -- load the animation
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
        -- play the animation
        TaskPlayAnim(player, dict, anim, 8.0, 8.0, -1, 1, 0, false, false, false)
    end
end

function KeyboardInput(text)
	local result = nil
	AddTextEntry("CUSTOM_AMOUNT", text)
	DisplayOnscreenKeyboard(1, "CUSTOM_AMOUNT", '', "", '', '', '', 255)
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Wait(1)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		result = GetOnscreenKeyboardResult()
		Citizen.Wait(1)
	else
		Citizen.Wait(1)
	end
	return result
end
