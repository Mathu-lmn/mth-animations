---@type table
local Heritage = {
    Background = { Dictionary = "pause_menu_pages_char_mom_dad", Texture = "mumdadbg", Width = 433, Height = 228 },
    Mum = { Dictionary = "char_creator_portraits", X = 25, Width = 228, Height = 228 },
    Dad = { Dictionary = "char_creator_portraits", X = 195, Width = 228, Height = 228 },
}

---@type Window
function RageUI.Window.Heritage(Mum, Dad)
    ---@type table
    local CurrentMenu = RageUI.CurrentMenu;
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            -- if Mum < 0 or Mum > 21 then
            --     Mum = 0
            -- end
            -- if Dad < 0 or Dad > 23 then
            --     Dad = 0
            -- end
            Mum = Mum - 1
            Dad = Dad - 1
            -- print(Mum)
            -- if Mum >= 21 and Mum <= 22 then
            --     Mum = "special_female_" .. Mum
            -- elseif Mum < 21 then
            --     Mum = "female_" .. Mum
            -- elseif Mum > 22 then
            --     Mum = "male_" .. Mum
            -- elseif Mum >= 43 then
            --     Mum = "special_male_" .. Mum
            -- end


            if (Mum < 21) then
                Mum = "male_" .. Mum;
            elseif (Mum < 42) then
                Mum = "female_" .. (Mum - 21);
            elseif (Mum < 45) then
                Mum = "special_male_" .. (Mum - 42);
            else
                Mum = "special_female_0";
            end

            if (Dad < 21) then
                Dad = "male_" .. Dad ;
            elseif (Dad < 42) then
                Dad = "female_" .. (Dad - 21);
            elseif (Dad < 45) then
                Dad = "special_male_" .. (Dad - 42) ;
            else
                Dad = "special_female_0";
            end

            -- if Dad >= 21 then
            --     Dad = "special_male_" .. (tonumber(string.sub(Dad, 2, 2)) - 1)
            -- else
            --     Dad = "male_" .. Dad
            -- end
            -- if (MuDadm < 21) then
            --     textureName = "male_" + secondShapedId;
            --  elseif (secondShapedId < 42) {
            --     textureName = "female_" + (secondShapedId - 21);
            --  elseif (secondShapedId < 45) {
            --     textureName = "special_male_" + (secondShapedId - 42);
            --  else
            --     textureName = "special_female_0";
            --  end

            RenderSprite(Heritage.Background.Dictionary, Heritage.Background.Texture, CurrentMenu.X,
                CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset,
                Heritage.Background.Width + (CurrentMenu.WidthOffset / 1), Heritage.Background.Height)
            RenderSprite(Heritage.Dad.Dictionary, Dad, CurrentMenu.X + Heritage.Dad.X + (CurrentMenu.WidthOffset / 2),
                CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Heritage.Dad.Width, Heritage.Dad.Height)
            RenderSprite(Heritage.Mum.Dictionary, Mum, CurrentMenu.X + Heritage.Mum.X + (CurrentMenu.WidthOffset / 2),
                CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Heritage.Mum.Width, Heritage.Mum.Height)
            RageUI.ItemOffset = RageUI.ItemOffset + Heritage.Background.Height
        end
    end
end
