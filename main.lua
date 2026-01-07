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
    local fov = fov or (0.5 * math.pi) -- 90 deg
    local focal_length = 1 / (math.tan(fov / 2))
    local x = focal_length * x / z
    local y = focal_length * y / z
    return -x, -y -- The actual projected image is mirrored both ways
end

-- Take a point in 3D space and draw it
function draw3d(x, y, z, fov)
    local x, y = project(x, y, z, fov)
    drawNormalized(x, y, 1 / z)
end

-- Rotate in the AB plane
function rotato(a, b, angle)
    local angle = angle
    local newA = a * math.cos(angle) + b * math.sin(angle)
    local newB = b * math.cos(angle) - a * math.sin(angle)
    return newA, newB
end

local z1 = 3
local z2 = 2
local vertices = {
    { -0.5, 0.5,  z1 },
    { 0.5,  0.5,  z1 },
    { -0.5, -0.5, z1 },
    { 0.5,  -0.5, z1 },

    { -0.5, 0.5,  z2 },
    { 0.5,  0.5,  z2 },
    { -0.5, -0.5, z2 },
    { 0.5,  -0.5, z2 },
}

function love.update(dt)
    for i = 1, #vertices, 1 do
        local x, z = rotato(vertices[i][1], vertices[i][3], math.pi / 3 * dt)
        local y = vertices[i][2]
        vertices[i] = { x, y, z }
    end
end

function love.draw()
    for i = 1, #vertices, 1 do
        draw3d(unpack(vertices[i]))
    end
end
