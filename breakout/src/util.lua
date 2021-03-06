function table.slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end

    return sliced
end

function GenerateQuads(atlas, tileWidth, tileHeight)
    local horizontalCount = atlas:getWidth() / tileWidth
    local verticalCount = atlas:getHeight() / tileHeight

    local tileCount = 1
    local spritesheet = {}

    for y = 0, verticalCount - 1 do
        for x = 0, horizontalCount - 1 do
            spritesheet[tileCount] = love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, atlas:getDimensions())
            tileCount = tileCount + 1
        end
    end

    return spritesheet
end

function GenerateQuadsPaddles(atlas)
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
        counter = counter + 1
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
        counter = counter + 1
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
        counter = counter + 1
        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
        counter = counter + 1

        x = 0
        y = y + 32
    end

    return quads
end

function GenerateQuadsBalls(atlas)
    local x = 96
    local y = 48

    local quads = {}

    for counter = 1, 7 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8
        if counter == 4 then
            y = 56
            x = 96
        end
    end

    return quads
end

function GenerateQuadBricks(atlas)
    quads = GenerateQuads(atlas, 32, 16)
    return table.slice(quads, 1, 21)
end

function renderHealth(health)
    local healthX = VIRTUAL_WIDTH - 100
    local maxHealth = 3

    for i = 1, maxHealth do
        if i <= health then
            love.graphics.draw(Textures['hearts'], Frames['hearts'][1], healthX, 4)
        else
            love.graphics.draw(Textures['hearts'], Frames['hearts'][2], healthX, 4)
        end
        healthX = healthX + 11
    end
end

function renderScore(score)
    love.graphics.setFont(Fonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end

function renderLevelName(name)
    love.graphics.printf('Level '..name, 0, 15,VIRTUAL_WIDTH - 10, 'right')
end

function DisplayFPS()
    love.graphics.setFont(Fonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

function loadHighScores()
    love.filesystem.setIdentity('breakout')

    if not love.filesystem.getInfo('breakout.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'AAA\n'
            scores = scores .. tostring(i * 1000) .. '\n'
        end

        love.filesystem.write('breakout.lst', scores)
    end

    local isName = true
    local currentName = nil
    local counter = 1

    local scores = {}

    for i = 1, 10 do
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    for line in love.filesystem.lines('breakout.lst') do
        if isName then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        isName = not isName
    end
    return scores
end