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
end

local animation_list = {}

local path_to_animations = "animations.txt"

-- Read the text file containing the animation list
local fileText = LoadResourceFile(GetCurrentResourceName(), path_to_animations)
if fileText then
    local currentCategory = nil
    local currentIndent = 0
    for line in string.gmatch(fileText, "[^\r\n]+") do
        -- Check the indentation level of the current line
        local newIndent = string.match(line, "^(%s+)")
        if newIndent then
            newIndent = #newIndent
        else
            newIndent = 0
        end
        -- Compare the indentation level to the previous line
        -- If the indentation level is 0, it's a new category
        if newIndent == 0 then
            currentCategory = line
            animation_list[currentCategory] = {}
        else
            -- remove the indent space before the animation name
            line = string.sub(line, newIndent + 1)
            -- this is an animation of the current category
            table.insert(animation_list[currentCategory], line)
        end
    end
end

RegisterCommand("animations", function()
    OpenAnimationsMenu()
end)

function OpenAnimationsMenu()
    if open then
        open = false
        RageUI.Visible(animations_menu, false)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        inAnim = false
        previousAnim = nil
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
                                -- for each sublist, check if any result
                                for k, v in pairs(animation_list) do
                                    for k2, v2 in pairs(v) do
                                        if string.find(string.lower(v2), string.lower(result)) then
                                            table.insert(results, { k, v2 })
                                        end
                                    end
                                end
                            end
                        end
                    }, results_menu)
                    -- add a button for each animation
                    for k, v in pairs(animation_list) do
                        RageUI.Button(k, nil, { RightLabel = "→→→" }, true, {
                            onSelected = function()
                                dict = k
                            end
                        }, dict_menu)
                    end
                end)
                RageUI.IsVisible(results_menu, function()
                    -- add a button for each result
                    if #results > 0 then
                        for k, v in pairs(results) do
                            RageUI.Button(v[2], nil, { RightLabel = "→→→" }, true, {
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
                    if animation_list[dict] then
                        -- add a button for each animation
                        for k, v in pairs(animation_list[dict]) do
                            RageUI.Button(v, nil, { RightLabel = "→→→" }, true, {
                                onSelected = function()
                                    -- when the button isselected, play the animation
                                    PlayAnimation(dict, v)
                                end
                            })
                        end
                    end
                end)
                Wait(0)
            end
        end)
    end
end


function PlayAnimation(dict, anim)
    if inAnim and anim == previousAnim then
        inAnim = false
        ClearPedTasksImmediately(GetPlayerPed(-1))
    elseif inAnim and anim ~= previousAnim then
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