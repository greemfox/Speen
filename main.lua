-- TODO:
-- [x] normalize coords
---- [ ] center the drawing
-- [ ] draw points
-- [ ] connect points
-- [ ] repeat
width, height = love.graphics.getDimensions()
function drawNormalized(normalizedX, normalizedY, imgPath, scale)
    imgPath = imgPath or '^^.png'
    scale = scale or 0.1
    x = (normalizedX + 1) * (width / 2)
    y = (normalizedY - 1) * -(height / 2)
    love.graphics.draw(love.graphics.newImage(imgPath), x, y, 0, scale) -- 0 rads rotation
end

function love.draw()
    for i = -1, 1, 0.01 do
        drawNormalized(i, i)
    end
end
