winSide = love.graphics.getDimensions()
love.window.setMode(winSide, winSide)
love.window.setTitle("Speeen")

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

z1 = -1
side = 1
z2 = z1 - side
halfside = side / 2
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

function love.update(dt)
    local angle = dt * 2 -- Rads per second
    for i = 1, #vertices do
        local x, y, z = unpack(vertices[i])
        local t = math.abs(z1 + z2) / 2
        local tz = z + t
        local rx, rz = rotateXZ(x, tz, angle)
        local rz = rz - t
        vertices[i] = { rx, y, rz }
    end
end

function love.draw()
    for i = 1, #vertices do
        draw3d(unpack(vertices[i]))
    end
end
