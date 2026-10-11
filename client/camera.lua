-- Cinematic orbit camera around the player ped.

Camera = { active = false }

local cam
local angle, zoom, preset = 0.0, 1.0, 'full'
local lighting = 'studio'

local Lights = {
    off    = nil,
    studio = { r = 255, g = 245, b = 235, range = 6.0, intensity = 1.6 },
    neon   = { r = 40,  g = 220, b = 255, range = 6.0, intensity = 2.2 },
    violet = { r = 170, g = 90,  b = 255, range = 6.0, intensity = 2.2 },
    sunset = { r = 255, g = 140, b = 70,  range = 6.0, intensity = 1.8 },
}

local function presetData()
    return Config.Camera.presets[preset] or Config.Camera.presets.full
end

local function compute()
    local ped = PlayerPedId()
    local p = GetEntityCoords(ped)
    local data = presetData()
    local h = math.rad(GetEntityHeading(ped) + angle)
    local dist = data.dist * zoom
    local pos = vector3(p.x - math.sin(h) * dist, p.y + math.cos(h) * dist, p.z + data.height)
    local look = vector3(p.x, p.y, p.z + data.look)
    return pos, look, data.fov or Config.Camera.fov
end

local function newCam()
    local pos, look, fov = compute()
    local c = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, fov, false, 2)
    PointCamAtCoord(c, look.x, look.y, look.z)
    return c
end

function Camera.Start(startPreset)
    preset = startPreset or 'full'
    angle, zoom = 0.0, 1.0
    if cam then DestroyCam(cam, false) end
    cam = newCam()
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 700, true, true)
    Camera.active = true

    CreateThread(function()
        while Camera.active do
            local light = Lights[lighting]
            if light then
                local pos = GetCamCoord(cam)
                local p = GetEntityCoords(PlayerPedId())
                local lp = vector3((pos.x + p.x) / 2, (pos.y + p.y) / 2, pos.z + 0.6)
                DrawLightWithRange(lp.x, lp.y, lp.z, light.r, light.g, light.b, light.range, light.intensity)
            end
            Wait(0)
        end
    end)
end

-- Smoothly move to a preset (full, head, torso, legs, feet)
function Camera.Focus(name, ms)
    if not Camera.active then return end
    if name and Config.Camera.presets[name] then preset = name end
    zoom = 1.0
    local nextCam = newCam()
    SetCamActiveWithInterp(nextCam, cam, ms or 650, 1, 1)
    local old = cam
    cam = nextCam
    SetTimeout((ms or 650) + 50, function()
        if old and old ~= cam then DestroyCam(old, false) end
    end)
end

local function refresh()
    if not cam then return end
    local pos, look, fov = compute()
    SetCamCoord(cam, pos.x, pos.y, pos.z)
    PointCamAtCoord(cam, look.x, look.y, look.z)
    SetCamFov(cam, fov)
end

function Camera.Rotate(delta)
    angle = (angle + (tonumber(delta) or 0)) % 360
    refresh()
end

function Camera.Zoom(delta)
    zoom = math.max(Config.Camera.zoomMin, math.min(Config.Camera.zoomMax, zoom + (tonumber(delta) or 0)))
    refresh()
end

function Camera.SetAngle(a)
    angle = tonumber(a) or 0.0
    refresh()
end

function Camera.SetLighting(name)
    if Lights[name] ~= nil or name == 'off' then lighting = name end
end

function Camera.Stop()
    if not Camera.active then return end
    Camera.active = false
    RenderScriptCams(false, true, 600, true, true)
    if cam then DestroyCam(cam, false) end
    cam = nil
end
