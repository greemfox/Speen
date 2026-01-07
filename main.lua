-- TODO:
-- [ ] project from 3d
-- [ ] connect points
-- [ ] redraw
winWidth, winHeight = love.graphics.getDimensions()
function drawNormalized(normalizedX, normalizedY, scale, imgPath)
    local scale = scale or 0.1
    local imgPath = imgPath or '^^.png'
    local img = love.graphics.newImage(imgPath)
    local imgWidth, imgHeight = img:getDimensions()
    local x = (normalizedX + 1) * (winWidth / 2) - (imgWidth * scale / 2)
    local y = (normalizedY - 1) * (-winHeight / 2) - (imgHeight * scale / 2)
    love.graphics.draw(img, x, y, 0, scale) -- 0 rads rotation
end

local points = { { -0.5, 0.5 }, { 0.5, 0.5 }, { -0.5, -0.5 }, { 0.5, -0.5 } }

function love.draw()
    for i = 1, #points, 1 do
        drawNormalized(points[i][1], points[i][2])
    end
end
