local polygons = -1
local scaleform

---Creates a new rect object in the scaleform and returns its handle
---@param x number the x coordinates in screen format (0.0 to 1.0)
---@param y number the y coordinates in screen format (0.0 to 1.0)
---@param w number the width in screen format (0.0 to 1.0)
---@param h number the height in screen format (0.0 to 1.0)
---@param r number the red blend
---@param g number the green blend
---@param b number the blue blend
---@param a number the alpha blend
---@return number the rectangle index used to edit its properties
function CreateRect(x, y, w, h, r, g, b, a)
    -- get correct coords
    local vec = ConvertScreenCoordsToScaleformCoords(x, y)
    -- get correct size
    local size = ConvertScreenSizeToScaleformSize(w, h)
    scaleform:CallFunction("DRAW_RECT", vec.x, vec.y, size.x, size.y, r, g, b, a)
    polygons = polygons + 1
    return polygons
end

---Creates a new circle object in the scaleform and returns its handle
---@param x number the x coordinate in screen format (0.0 to 1.0)
---@param y number the y coordinate in screen format (0.0 to 1.0)
---@param w number the width in screen format (0.0 to 1.0)
---@param h number the height in screen format (0.0 to 1.0)
---@param r number the red blend
---@param g number the green blend
---@param b number the blue blend
---@param a number the alpha blend
---@return number the rectangle index used to edit its properties
function CreateCircle(x, y, w, h, r, g, b, a)
    -- get correct coords
    local vec = ConvertScreenCoordsToScaleformCoords(x, y)
    -- get correct size
    local size = ConvertScreenSizeToScaleformSize(w, h)
    scaleform:CallFunction("DRAW_CIRCLE", vec.x, vec.y, size.x, size.y, r, g, b, a)
    polygons = polygons + 1
    return polygons
end

---Creates a new polygon object in the scaleform and returns its handle
---@param sides number the number of sides of the polygon
---@param x number the x coordinate in screen format (0.0 to 1.0)
---@param y number the y coordinate in screen format (0.0 to 1.0)
---@param w number the width in screen format (0.0 to 1.0)
---@param h number the height in screen format (0.0 to 1.0)
---@param r number the red blend
---@param g number the green blend
---@param b number the blue blend
---@param a number the alpha blend
---@return number the rectangle index used to edit its properties
function CreatePoly(sides, x, y, w, h, r, g, b, a)
    if sides < 3 then
        print("CANNOT CREATE A POLYGON WITH LESS THAN 3 SIDES!")
    end
    -- get correct coords
    local vec = ConvertScreenCoordsToScaleformCoords(x, y)
    -- get correct size
    local size = ConvertScreenSizeToScaleformSize(w, h)
    scaleform:CallFunction("DRAW_POLYGON", sides, vec.x, vec.y, size.x, size.y, r, g, b, a)
    polygons = polygons + 1
    return polygons
end

---Creates a new sprite object in the scaleform and returns its handle
---@param txd string the texture dictionary
---@param txn string the texture name
---@param x number the x coordinate in screen format (0.0 to 1.0)
---@param y number the y coordinate in screen format (0.0 to 1.0)
---@param w number the width in screen format (0.0 to 1.0)
---@param h number the height in screen format (0.0 to 1.0)
---@param r number the red blend
---@param g number the green blend
---@param b number the blue blend
---@param a number the alpha blend
---@return number the rectangle index used to edit its properties
function CreateSprite(txd, txn, x, y, w, h, r, g, b, a)
    -- get correct coords
    local vec = ConvertScreenCoordsToScaleformCoords(x, y)
    -- get correct size
    local size = ConvertScreenSizeToScaleformSize(w, h)
    scaleform:CallFunction("DRAW_SPRITE", txd, txn, vec.x, vec.y, size.x, size.y, r, g, b, a)
    polygons = polygons + 1
    return polygons
end

---Creates a new Textfield object in the scaleform and returns its handle
---@param label string the texture
---@param x number the x coordinate in screen format (0.0 to 1.0)
---@param y number the y coordinate in screen format (0.0 to 1.0)
---@param fontSize number FontSize (default is 13)
---@param alignment number the text alignment (0 = left, 1 = center, 2 = right)
---@param font string the font to be used (default $Font2 check https://forum.cfx.re/t/using-html-images-and-blips-in-scaleform-texts/553298/2 for all ingame fonts)
---@param outline boolean toggle the text outline
---@param shadow boolean toggle the text shadow
---@return number the rectangle index used to edit its properties
function CreateText(label, x,y, fontSize, alignment, font, outline, shadow)
    -- get correct coords
    if fontSize == nil then fontSize = 13 end
    if alignment == nil then alignment = 0 end
    if font == nil then font = "$Font2" end
    if outline == nil then outline = true end
    if shadow == nil then shadow = false end
    local vec = ConvertScreenCoordsToScaleformCoords(x, y)
    scaleform:CallFunction("DRAW_TEXT", label, vec.x, vec.y, fontSize, alignment, font, outline, shadow)
    polygons = polygons + 1
    return polygons
end

---Updates an existing Textfield object in the scaleform and returns its handle
---@param handle number the textfield handle
---@param label string the texture
---@param x number the x coordinate in screen format (0.0 to 1.0)
---@param y number the y coordinate in screen format (0.0 to 1.0)
---@param fontSize number FontSize (default is 13)
---@param alignment number the text alignment (0 = left, 1 = center, 2 = right)
---@param font string the font to be used (default $Font2 check https://forum.cfx.re/t/using-html-images-and-blips-in-scaleform-texts/553298/2 for all ingame fonts)
---@param outline boolean toggle the text outline
---@param shadow boolean toggle the text shadow
function UpdateText(handle, label, x,y, fontSize, alignment, font, outline, shadow)
    if fontSize == nil then fontSize = 13 end
    if alignment == nil then alignment = 0 end
    if font == nil then font = "$Font2" end
    if outline == nil then outline = true end
    if shadow == nil then shadow = false end
    local vec = ConvertScreenCoordsToScaleformCoords(x, y)
    scaleform:CallFunction("UPDATE_TEXT", handle, label, vec.x, vec.y, fontSize, alignment, font, outline, shadow)
end

---Updates a created handle position (can be called on frame)
---@param handle number the created item's handle
---@param x number the x coordinate in screen format (0.0 to 1.0)
---@param y number the y coordinate in screen format (0.0 to 1.0)
function SetItemPosition(handle, x, y)
    local vec = ConvertScreenCoordsToScaleformCoords(x, y)
    scaleform:CallFunction("SET_ITEM_POSITION", handle, vec.x, vec.y)
end

---Updates a created handle size (size and scale are different, scaling is a percentage value for all the item itself (EX: zooming))
---@param handle number the created item's handle
---@param w number the width in screen format (0.0 to 1.0)
---@param h number the height in screen format (0.0 to 1.0)
function SetItemSize(handle, w, h)
    local size = ConvertScreenSizeToScaleformSize(w, h)
    scaleform:CallFunction("SET_ITEM_SIZE", handle, size.x, size.y)
end

---Updates a created handle scaling (size and scale are different, scaling is a percentage value for all the item itself (EX: zooming)) (can be called on frame)
---@param handle number the created item's handle
---@param scale number the scale percentage from 0.0 to 200.0. Default at 100.0
function SetItemScale(handle, scale)
    scaleform:CallFunction("SET_ITEM_SCALE", handle, scale)
end

---Updates a created handle's color (can be called on frame)
---@param handle number the created item's handle
---@param r number the red blend
---@param g number the green blend
---@param b number the blue blend
---@param a number the alpha blend
function SetItemColor(handle, r, g, b, a)
    scaleform:CallFunction("SET_ITEM_COLOR", handle, r, g, b, a)
end

---Updates a created handle's rotation (can be called on frame)
---@param handle number the created item's handle
---@param rotation number the rotation in degrees 0.0 to 360.0
function SetItemRotation(handle, rotation)
    if rotation > 360 then
        rotation = rotation - 360
    elseif rotation < 0 then
        rotation = rotation + 360
    end
    scaleform:CallFunction("SET_ITEM_ROTATION", handle, rotation)
end

---Updates a created handle's 3D rotation (can be called on frame)
---@param handle number the created item's handle
---@param xrot number Sets the rotation of the object around the X (horizontal) axis, defaults to 0, max 360.0
---@param yrot number Sets the rotation of the object around the Y (vertical) axis, defaults to 0, max 360.0.
function SetItem3DRotation(handle, xrot, yrot)
    scaleform:CallFunction("SET_ITEM_3D_SETTINGS", handle, xrot, yrot)
end

---Updates a created handle's vsibility (⚠️ this DO NOT delete the created handle, only hides it)
---@param handle number the created item's handle
---@param visible boolean visibility flag
function SetItemVisible(handle, visible)
    scaleform:CallFunction("SET_ITEM_VISIBLE", handle, visible)
end

---Updates a created handle's sprite texture and size
---@param handle number the created item's handle
---@param txd string the texture dictionary
---@param txn string the texture name
---@param w number the width in screen format (0.0 to 1.0)
---@param h number the height in screen format (0.0 to 1.0)
function UpdateSprite(handle, txd,txn,w,h)
    local size = ConvertScreenSizeToScaleformSize(w, h)
    scaleform:CallFunction("SET_SPRITE_TXD_TXN", handle,txd,txn,size.x,size.y)
end

---Deletes a created handle and sets it to -1
---@param handle number the created item's handle
function RemoveItem(handle)
    scaleform:CallFunction("REMOVE_ITEM", handle)
    polygons = polygons - 1
    handle = -1
end

---Deletes all the created handles from screen.
function ClearAll()
    scaleform:CallFunction("CLEAR_ALL")
    polygons = -1
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if scaleform:IsLoaded() then
            scaleform:Render2D()
        end
    end
end)

AddEventHandler('onClientResourceStop', function(res)
    if res == GetCurrentResourceName() then
        scaleform:Dispose()
    end
end)

AddEventHandler('onClientResourceStart', function(res)
    if res == GetCurrentResourceName() then
        if scaleform == nil or scaleform.handle == 0 then
            scaleform = Scaleform.RequestWidescreen("DRAW_ALL")
        end
    end
end)

-- RegisterCommand("debug", function(a,b,c)
--     local handle = CreateText("", 0.5, 0.8, 25, 1, "$Font2", true, false)
--     local text = "this is a test"
--     local current = ""

--     for i = 1, #text do
--         current = string.sub(text, 1, i)
--         UpdateText(handle, current, 0.5, 0.8, 25, 1, "$Font2", true, false)
--         Wait(100)
--     end
-- end, true)

exports('CreateRect', CreateRect)
exports('CreateCircle', CreateCircle)
exports('CreatePoly', CreatePoly)
exports('CreateSprite', CreateSprite)
exports('CreateText', CreateText)
exports('UpdateText', UpdateText)
exports('SetItemPosition', SetItemPosition)
exports('SetItemSize', SetItemSize)
exports('SetItemScale', SetItemScale)
exports('SetItemColor', SetItemColor)
exports('SetItemRotation', SetItemRotation)
exports('SetItem3DRotation', SetItem3DRotation)
exports('SetItemVisible', SetItemVisible)
exports('UpdateSprite', UpdateSprite)
exports('RemoveItem', RemoveItem)
exports('ClearAll', ClearAll)