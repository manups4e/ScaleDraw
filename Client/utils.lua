---Converts player's current screen resolution coordinates into scaleform coordinates (1280 x 720)
---@param realX number
---@param realY number
---@return vector2
function ConvertResolutionCoordsToScaleformCoords(realX, realY)
    local x, y = GetActiveScreenResolution()
    return vector2(realX / x * 1280, realY / y * 720)
end

---Converts scaleform coordinates (1280 x 720) into player's current screen resolution coordinates
---@param scaleformX number
---@param scaleformY number
---@return vector2
function ConvertScaleformCoordsToResolutionCoords(scaleformX, scaleformY)
    local x, y = GetActiveScreenResolution()
    return vector2(scaleformX / 1280 * x, scaleformY / 720 * y)
end

---Converts screen coords (0.0 - 1.0) into scaleform coords (1280 x 720)
---@param scX number
---@param scY number
---@return vector2
function ConvertScreenCoordsToScaleformCoords(scX, scY)
    return vector2(scX * 1280, scY * 720)
end

---Converts scaleform coords (1280 x 720) into screen coords (0.0 - 1.0)
---@param scaleformX number
---@param scaleformY number
---@return vector2
function ConvertScaleformCoordsToScreenCoords(scaleformX, scaleformY)
    local scalX, scalY = 1.0 / 1280, 1.0 / 720
    return vector2(scaleformX * scalX, scaleformY * scalY)
end

---Converts actual resolution pixels (ex: 1920 x 1080) to screen coords (0.0 -> 1.0)
function ConvertResolutionCoordsToScreenCoords(x, y)
    local w, h = GetActualScreenResolution()
    local normalizedX = math.max(0.0, math.min(1.0, x / w))
    local normalizedY = math.max(0.0, math.min(1.0, y / h))
    return vector2(normalizedX, normalizedY)
end

---Converts screen coords (0.0 to 1.0) into actual resolution coords (ex: 1280 x 720)
function ConvertScreenCoordsToResolutionCoords(x, y)
    local w, h = GetActualScreenResolution()
    return vector2(math.floor(x * w), math.floor(y * h))
end

---Converts player's current screen resolution size into scaleform size (1280 x 720)
---@param realWidth number
---@param realHeight number
---@return vector2
function ConvertResolutionSizeToScaleformSize(realWidth, realHeight)
    local x, y = GetActiveScreenResolution()
    return vector2(realWidth / x * 1280, realHeight / y * 720)
end

---Converts scaleform size (1280 x 720) into player's current screen resolution size
---@param scaleformWidth number
---@param scaleformHeight number
---@return vector2
function ConvertScaleformSizeToResolutionSize(scaleformWidth, scaleformHeight)
    local x, y = GetActiveScreenResolution()
    return vector2(scaleformWidth / 1280 * x, scaleformHeight / 720 * y)
end

---Converts screen size (0.0 - 1.0) into scaleform size (1280 x 720)
---@param scWidth number
---@param scHeight number
---@return vector2
function ConvertScreenSizeToScaleformSize(scWidth, scHeight)
    return vector2(scWidth * 1280, scHeight * 720)
end

---Converts scaleform size (1280 x 720) into screen size (0.0 - 1.0)
---@param scaleformWidth number
---@param scaleformHeight number
---@return vector2
function ConvertScaleformSizeToScreenSize(scaleformWidth, scaleformHeight)
    -- Normalize size to 0.0 - 1.0 range
    local w, h = GetActualScreenResolution()
    return vector2((scaleformWidth / w), (scaleformHeight / h))
end

---Converts current resolution sizes into screen sizes (0.0 to 1.0)
function ConvertResolutionSizeToScreenSize(width, height)
    local w, h = GetActualScreenResolution()
    local normalizedWidth = math.max(0.0, math.min(1.0, width / w))
    local normalizedHeight = math.max(0.0, math.min(1.0, height / h))
    return vector2(normalizedWidth, normalizedHeight)
end

---Adjust 1080p values to any aspect ratio
---@param x number
---@param y number
---@param w number
---@param h number
---@return number
---@return number
---@return number
---@return number
function AdjustNormalized16_9ValuesForCurrentAspectRatio(x, y, w, h)
    local fPhysicalAspect = GetAspectRatio(false)
    if IsSuperWideScreen() then
        fPhysicalAspect = 16.0 / 9.0
    end

    local fScalar = (16.0 / 9.0) / fPhysicalAspect
    local fAdjustPos = 1.0 - fScalar

    w = w * fScalar

    local newX = x * fScalar
    x = newX + fAdjustPos * 0.5
    x, w = AdjustForSuperWidescreen(x, w)
    return x, y, w, h
end

function GetWideScreen()
    local WIDESCREEN_ASPECT = 1.5
    local fLogicalAspectRatio = GetAspectRatio(false)
    local w, h = GetActualScreenResolution()
    local fPhysicalAspectRatio = w / h
    if fPhysicalAspectRatio <= WIDESCREEN_ASPECT then
        return false
    end
    return fLogicalAspectRatio > WIDESCREEN_ASPECT;
end

---Adjusts normalized values to SuperWidescreen resolutions
---@param x number
---@param w number
---@return number,number
function AdjustForSuperWidescreen(x, w)
    if not IsSuperWideScreen() then
        return x, w
    end

    local difference = ((16.0 / 9.0) / GetAspectRatio(false))

    x = 0.5 - ((0.5 - x) * difference)
    w = w * difference

    return x, w
end

function IsSuperWideScreen()
    local aspRat = GetAspectRatio(false)
    return aspRat > (16.0 / 9.0)
end

function math.clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

function math.lerp(a, b, t)
    return a + (b - a) * t
end

function math.mag(x, y, z)
    return math.sqrt(x * x + y * y + z * z)
end

---Adjust coordinates from vector to screen position
---@param position vector3 World position of the component
---@param offset vector3 Optional offset from position
---@param displayRange number|nil Maximum distance to display (default: 100.0)
---@param nearScalingDistance number|nil where scaling starts (default: 0.0)
---@param farScalingDistance number|nil Distance where scaling ends (default: 100.0)
---@param maxScale number|nil Maximum scale value (default: 1.0)
---@param minScale number|nil Minimum scale value (default: 0.0)
---@return boolean,vector2,number
function GetScreenCoordinatesForComponent(position, offset, displayRange, nearScalingDistance, farScalingDistance,
                                          maxScale, minScale)
    if displayRange == nil then displayRange = 100.0 end
    if nearScalingDistance == nil then nearScalingDistance = 0.0 end
    if farScalingDistance == nil then farScalingDistance = 100.0 end
    if maxScale == nil then maxScale = 1.0 end
    if minScale == nil then minScale = 0.0 end

    local Diff = position - GetFinalRenderedCamCoord();
    local Dist = math.mag(Diff.x, Diff.y, Diff.z);

    local DistanceScale = GetGameplayCamFov() / 45.0;

    Dist = Dist * DistanceScale;

    if (Dist <= displayRange) then
        local WorldCoors = position + offset;
        local success, screenPosX, screenPosY = GetScreenCoordFromWorldCoord(WorldCoors.x, WorldCoors.y, WorldCoors.z)
        if (success) then
            return success, vector2(screenPosX, screenPosY),
                RampValue(Dist, nearScalingDistance, farScalingDistance, maxScale, minScale) * 100;
        end
    end
    return false, vec(-1, -1), 0.0
end

function RampValue(x, funcInA, funcInB, funcOutA, funcOutB)
    local funcInRange = funcInB - funcInA;
    local t = math.clamp((x - funcInA) / funcInRange, 0.0, 1.0)
    return math.lerp(t, funcOutA, funcOutB);
end

function GetCornerPosition()
end
