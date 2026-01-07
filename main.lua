winSide = love.graphics.getDimensions()
love.window.setMode(winSide, winSide)

function drawNormalized(normalizedX, normalizedY, scale, imgPath)
    local scale = scale or 0.5
    local imgPath = imgPath or '^^.png'
    local img = love.graphics.newImage(imgPath)
    local imgWidth, imgHeight = img:getDimensions()
    local x = (normalizedX + 1) * (winSide / 2) - (imgWidth * scale / 2)
    local y = (normalizedY - 1) * (-winSide / 2) - (imgHeight * scale / 2)
    love.graphics.draw(img, x, y, 0, scale) -- 0 rads rotation
end

function project(x, y, z, fov)
    local fov = fov or (0.5 * math.pi)
    local focal_length = 1 / (math.tan(fov / 2))
    local x = focal_length * x / z
    local y = focal_length * y / z
    return -x, -y -- the actual projected image is mirrored both ways
end

function draw3d(x, y, z, fov)
    local x, y = project(x, y, z, fov)
    drawNormalized(x, y, 1 / z)
end

-- rotate in the AB plane
function rotato(a, b, angle)
    local a = a * math.cos(angle) - b * math.sin(angle)
    local b = b * math.sin(angle) - a * math.cos(angle)
    return a, b
end

local z1 = 3
local z2 = 2
local points = {
    { -0.5, 0.5,  z1 },
    { 0.5,  0.5,  z1 },
    { -0.5, -0.5, z1 },
    { 0.5,  -0.5, z1 },

    { -0.5, 0.5,  z2 },
    { 0.5,  0.5,  z2 },
    { -0.5, -0.5, z2 },
    { 0.5,  -0.5, z2 },
}

function love.draw()
    for i = 1, #points, 1 do
        draw3d(unpack(points[i]))
    end
end
