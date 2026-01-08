-- Define the cube
local z1 = -1
local side = 1
local z2 = z1 - side
local halfside = side / 2
local vertices = {
    { -halfside, halfside,  z1 },
    { halfside,  halfside,  z1 },
    { -halfside, -halfside, z1 },
    { halfside,  -halfside, z1 },
    { -halfside, halfside,  z2 },
    { halfside,  halfside,  z2 },
    { -halfside, -halfside, z2 },
    { halfside,  -halfside, z2 },
}

-- Take absolute coords and normalize them
function normalizeCoords(x, y)
    local x = x or 0
    local y = y or 0
    local nx = (2 * x / winSide - 1)
    local ny = (2 * y / winSide + 1)
    return nx, ny
end

-- Take normalized coords and draw an image
function drawNormalized(normalizedX, normalizedY, scale, imgPath)
    local scale = scale or 0.5
    local imgPath = imgPath or '^^.png'
    local img = love.graphics.newImage(imgPath)
    local imgWidth, imgHeight = img:getDimensions()
    local x = (normalizedX + 1) * (winSide / 2) - (imgWidth * scale / 2)
    local y = (normalizedY - 1) * (-winSide / 2) - (imgHeight * scale / 2)
    love.graphics.draw(img, x, y, 0, scale) -- 0 rads rotation
end

-- Project coords from a 3D space behind the screen onto the screen
function project(x, y, z, fov)
    local fov = fov or (math.pi / 2) -- 90 deg
    local focal_length = 1 / (math.tan(fov / 2))
    local x = focal_length * x / z
    local y = focal_length * y / z
    return x, y
end

-- Take a point in 3D space and draw it
function draw3d(x, y, z)
    local x, y = project(x, y, z)
    drawNormalized(x, y, 0.5 / math.abs(z))
end

-- Rotate around the Y axis
function rotateXZ(x, z, angle)
    local angle = angle
    local newX = x * math.cos(angle) + z * math.sin(angle)
    local newZ = z * math.cos(angle) - x * math.sin(angle)
    return newX, newZ
end

-- Rotate around the X axis
function rotateYZ(y, z, angle)
    local angle = angle
    local newY = y * math.cos(angle) - z * math.sin(angle)
    local newZ = z * math.cos(angle) + y * math.sin(angle)
    return newY, newZ
end

-- Spin the doggamn cube around Y
function spinCubeXZ(dt, speenFactor)
    local angle = dt * speenFactor
    for i = 1, #vertices do
        local x, y, z = unpack(vertices[i])
        local t = math.abs(z1 + z2) / 2
        local tz = z + t
        local rx, rz = rotateXZ(x, tz, angle)
        rz = rz - t
        vertices[i] = { rx, y, rz }
    end
end

-- Spin the doggamn cube around X
function spinCubeYZ(dt, speenFactor)
    local angle = dt * speenFactor
    for i = 1, #vertices do
        local x, y, z = unpack(vertices[i])
        local t = math.abs(z1 + z2) / 2
        local tz = z + t
        local ry, rz = rotateYZ(y, tz, angle)
        rz = rz - t
        vertices[i] = { x, ry, rz }
    end
end

function love.load()
    winSide = love.graphics.getDimensions()
    love.window.setMode(winSide, winSide)
    love.window.setTitle("Speeen")
    handlingCube = { active = false, oldX = 0, oldY = 0 }
end

function love.draw()
    -- Literally just sort the points by Z before drawing
    table.sort(vertices, function(a, b) return a[3] < b[3] end)
    for i = 1, #vertices do
        draw3d(unpack(vertices[i]))
    end
end

function love.update(dt)
    local newX, newY = normalizeCoords(love.mouse.getPosition())
    local dx, dy = 0, 0

    handlingCube.active = false
    if love.mouse.isDown(1, 2) then
        if newX ~= handlingCube.oldX then
            dx = handlingCube.oldX - newX
            handlingCube.active = true
        end
        local speenFactorX = 100 * dx
        if handlingCube.active then
            spinCubeXZ(dt, speenFactorX)
        end

        if newY ~= handlingCube.oldY then
            dy = handlingCube.oldY - newY
            handlingCube.active = true
        end
        local speenFactorY = 100 * dy
        if handlingCube.active then
            spinCubeYZ(dt, speenFactorY)
        end
    end

    love.mouse.setRelativeMode(handlingCube.active)
    handlingCube.oldX, handlingCube.oldY = newX, newY
end
