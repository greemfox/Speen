-- TODO:
-- [x] normalize coords
---- [x] center the drawing
-- [ ] draw points
-- [ ] connect points
-- [ ] repeat
width, height = love.graphics.getDimensions()
function drawNormalized(normalizedX, normalizedY, imgPath, scale)
    local imgPath = imgPath or '^^.png'
    local scale = scale or 0.1
    local img = love.graphics.newImage(imgPath)
    local imgWidth, imgHeight = img:getDimensions()
    local x = (normalizedX + 1) * (width / 2) - (imgWidth * scale / 2)
    local y = (normalizedY - 1) * (-height / 2) - (imgHeight * scale / 2)
    love.graphics.draw(img, x, y, 0, scale) -- 0 rads rotation
end

function love.draw()
    for i = -1, 1, 0.01 do
        drawNormalized(i, i)
    end
end
