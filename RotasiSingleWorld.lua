--
FarmWorld = ""
FarmWorldId = ""
SeedStorage = ""
SeedStorageId = ""
dumpWorld = ""
dumpWorldId = ""
BlockID = 182
SeedID = BlockID + 1
isPlantSeed = true
--
WhenTrashCount = 100
trashList = {
    5028, -- Earth Essence
    5032, -- Fissure
    5034, -- Waterfall
    5036, -- Hidden Door
    5038, -- Anemone
    5040, -- Aurora
    5042, -- Obsidian
    5044, -- Lava Lamp
    7162, -- Hour Glass
    7164 -- Red House Entrance
}
drop_list_items = {
    5030,
    1406
}
--
BREAK_BG_ID = 298

DELAY_PLACE = 300
DELAY_BREAK = 290
DELAY_HARVEST = 300
DELAY_PLANT = 280
--[[===============================]]--
bot = getBot()
world = getWorld()
inventory = bot:getInventory()


function attemptJoinWorld(world, id)
    if bot.status ~= 1 then
        while bot.status ~= 1 do
            bot:connect()
            sleep(20000)
        end
    end

    while getWorld().name ~= world do
        sleep(200)
        bot:warp(world, id)
        sleep(5000)
    end
end

function getFloats(id)
    for _,obj in pairs(world:getObjects()) do
        if obj.id == id and bot:getWorld():hasAccess(obj.x, obj.y) then
            bot:findPath(obj.x//32, obj.y//32)
            sleep(200)
        end
    end
end

function disconnectedControl()
    if bot.status ~= 1 then
        while bot.status ~= 1 do
            bot:connect()
            sleep(20000)
        end
        sleep(5000)
    end
    local currentWorld = tostring(world.name)
    while currentWorld ~= FarmWorld do
        sleep(5000)
        bot:warp(FarmWorld, FarmWorldId)
        sleep(5000)
    end
end

function disconnectedCondition(task)
    if bot.status ~= 1 then
        while bot.status ~= 1 do
            disconnectedControl()
        end
        sleep(5000)
        if task == "harvest" then
            bot.auto_collect = false
            sleep(2000)
            while getWorld().name ~= FarmWorld do
                attemptJoinWorld(FarmWorld, FarmWorldId)
                sleep(5000)
            end
            while world:getTile(getLocal().posx / 32,getLocal().posy / 32).fg == 6 do
                attemptJoinWorld(FarmWorld, FarmWorldId)
                sleep(3000)
            end
            sleep(3000)
        end
        if task == "pnb" then
            bot.auto_collect = false
            while getWorld().name ~= FarmWorld do
                attemptJoinWorld(FarmWorld, FarmWorldId)
                sleep(5000)
            end
            while world:getTile(getLocal().posx / 32,getLocal().posy / 32).fg == 6 do
                attemptJoinWorld(FarmWorld, FarmWorldId)
                sleep(3000)
            end
            goToBreakLocation()
            sleep(3000)
        end
        if task == "planting" then
            bot.auto_collect = false
            while getWorld().name ~= FarmWorld do
                attemptJoinWorld(FarmWorld, FarmWorldId)
                sleep(5000)
            end
            while world:getTile(getLocal().posx / 32,getLocal().posy / 32).fg == 6 do
                attemptJoinWorld(FarmWorld, FarmWorldId)
                sleep(3000)
            end
            sleep(3000)
        end

        if task == "drop_seed" then
            bot.auto_collect = false
            while getWorld().name ~= SeedStorage do
                attemptJoinWorld(SeedStorage, SeedStorageId)
                sleep(5000)
            end
            while world:getTile(getLocal().posx / 32,getLocal().posy / 32).fg == 6 do
                attemptJoinWorld(SeedStorage, SeedStorageId)
                sleep(3000)
            end
            sleep(3000)
        end

        if task == "drop_items" then
            bot.auto_collect = false
            while getWorld().name ~= SeedStorage do
                attemptJoinWorld(dumpWorldId, dumpWorldId)
                sleep(5000)
            end
            while world:getTile(getLocal().posx / 32,getLocal().posy / 32).fg == 6 do
                attemptJoinWorld(dumpWorld, dumpWorldId)
                sleep(3000)
            end
            dropSpecific()
            sleep(3000)
        end
    end
end

function task_harvest()
    disconnectedCondition("harvest")

    bot.auto_collect = true
    bot.collect_range = 4
    for i, tile in ipairs(world:getTiles()) do
        disconnectedCondition("harvest")
        if tile.fg == SeedID and tile:canHarvest() then
            disconnectedCondition("harvest")
            bot:findPath(tile.x, tile.y)
            sleep(DELAY_HARVEST)
            if bot.status == 1 then
                if world:getTile(tile.x, tile.y).fg == SeedID or world:getTile(tile.x, tile.y).bg == SeedID then
                    if bot:isInTile(tile.x, tile.y) then
                        bot:hit(tile.x, tile.y)
                    else
                        bot:findPath(tile.x, tile.y)
                        sleep(DELAY_HARVEST)
                        bot:hit(tile.x, tile.y)
                    end
                    sleep(DELAY_HARVEST)
                end
            else
                disconnectedCondition("harvest")
            end
            if bot.status == 1 then
                if world:getTile(tile.x, tile.y).fg == SeedID or world:getTile(tile.x, tile.y).bg == SeedID then
                    if bot:isInTile(tile.x, tile.y) then
                        bot:hit(tile.x, tile.y)
                    else
                        bot:findPath(tile.x, tile.y)
                        sleep(DELAY_HARVEST)
                        bot:hit(tile.x, tile.y)
                    end
                    sleep(DELAY_HARVEST)
                end
            else
                disconnectedCondition("harvest")
            end
        end
        if inventory:getItemCount(BlockID) >= 180 then
            bot.auto_collect = false
            break
        end
    end
end

function plant()
    disconnectedCondition("planting")
    for i, tile in ipairs(world:getTiles()) do
        disconnectedCondition("planting")
        if bot.status == 1 then
            if
            0 == world:getTile(tile.x, tile.y).fg and 0 ~= world:getTile(tile.x, tile.y + 1).fg and
                    world:getTile(tile.x, tile.y + 1).fg ~= SeedID and
                    inventory:getItemCount(SeedID) > 0
            then
                disconnectedCondition("planting")
                bot:findPath(tile.x, tile.y)
                sleep(DELAY_PLANT)
                if bot:isInTile(tile.x, tile.y) then
                    bot:place(tile.x, tile.y, SeedID)
                    sleep(DELAY_PLANT)
                else
                    bot:findPath(tile.x, tile.y)
                    sleep(DELAY_PLANT)
                    if bot:isInTile(tile.x, tile.y) then
                        bot:place(tile.x, tile.y, SeedID)
                        sleep(DELAY_PLANT)
                    end
                end
            end
        else
            disconnectedCondition("planting")
        end
    end
end

function dropTrash()
    bot.auto_collect = false
    local shouldDrop = false
    for i, trash in ipairs(trashList) do
        if inventory:getItemCount(trash) > WhenTrashCount then
            --bot:trash(trash, inventory:getItemCount(trash))
            --sleep(2000)
            shouldDrop = true
        end
    end

    if shouldDrop then
        attemptJoinWorld(dumpWorld, dumpWorldIdm)
        for i, trash in ipairs(trashList) do
            if inventory:getItemCount(trash) > WhenTrashCount then
                bot:trash(trash, inventory:getItemCount(trash))
                sleep(2000)
            end
        end
        sleep(4000)
        attemptJoinWorld(FarmWorld, FarmWorldId)
        sleep(1000)
    end
end

function dropSpecific()
    bot.auto_collect = false
    local shouldDrop = false

    for i, item in ipairs(drop_list_items) do
        if inventory:getItemCount(item) > WhenTrashCount then
            shouldDrop = true
        end
    end

    if shouldDrop then
        sleep(4000)
        bot:warp(dumpWorld)
        sleep(3000)
        disconnectedControl("drop_items")
        for i, item in ipairs(drop_list_items) do
            while inventory:getItemCount(item) > WhenTrashCount do
                bot:drop(item, inventory:getItemCount(item))
                sleep(2000)
                if inventory:getItemCount(item) > 0 then
                    bot:moveUp()
                    sleep(2000)
                end
            end
        end
    end

    attemptJoinWorld(FarmWorld, FarmWorldId)
end

function dropSeed()
    disconnectedCondition("drop_seed")

    attemptJoinWorld(SeedStorage, SeedStorageId)
    sleep(4000)

    while bot:getInventory():getItemCount(SeedID) do
        disconnectedCondition("drop_seed")
        bot:drop(SeedID, bot:getInventory():getItemCount(SeedID))
        sleep(2000)
        bot:moveUp()
    end
end

function goToBreakLocation()
    bot.auto_collect = false
    for _, tile in ipairs(getTiles()) do
        if tile.bg == BREAK_BG_ID then
            bot:findPath(tile.x, tile.y)
            sleep(200)
            while not bot:isInTile(tile.x, tile.y) do
                sleep(200)
            end
            sleep(1000)
        end
    end
end

function checkReadyTree()
    isReadyTree = 0
    for i, tile in ipairs(world:getTiles()) do
        if tile:canHarvest() then
            if tile.fg == SeedID or tile.bg == SeedID then
                isReadyTree = 1
            end
        end
    end
    return isReadyTree
end

function tilealfg(x,y)
    disconnectedCondition("pnb")
    local currentWorld = tostring(world.name)
    if currentWorld ~= "" and currentWorld ~= "EXIT" then
        tilefgx = world:getTile(x,y).fg
        return {tilefg = tilefgx}
    end
end

function tilealbg(x,y)
    disconnectedCondition("pnb")
    local currentWorld = tostring(world.name)
    if currentWorld ~= "" and currentWorld ~= "EXIT" then
        tilebgx = world:getTile(x,y).bg
        return {tilebg = tilebgx}
    end
end

function getBotPos()
    Botx = math.floor(getLocal().posx / 32)
    Boty = math.floor(getLocal().posy / 32)
end


function PNB()
    disconnectedControl("pnb")
    goToBreakLocation()

    bot.auto_collect = true
    bot.collect_range = 3

    getBotPos()
    sleep(2000)

    while inventory:getItemCount(BlockID) > 0 do
        disconnectedControl("pnb")
        -- Place
        if tilealfg(Botx, Boty-1).tilefg == 0 then
            if bot:isInTile(Botx, Boty) then
                bot:place(Botx, Boty-1, BlockID)
                sleep(DELAY_PLACE)
            end
        end
        -- Break
        while (tilealfg(Botx, Boty-1).tilefg ~= 0 or tilealbg(Botx, Boty-1).tilebg ~= 0) do
            disconnectedControl("pnb")
            if math.floor(getLocal().posx//32) ~= Botx and math.floor(getLocal().posy//32) ~= BotY then
                bot:findPath(BotPxz, BotPyz)
                sleep(1000)
                getBotPos()
            end
            if bot:isInTile(Botx, Boty) then
                bot:hit(Botx, Boty-1 )
                sleep(DELAY_BREAK)
            end
        end
    end
end

function mainAction()
    if world.name ~= FarmWorld then
        attemptJoinWorld(FarmWorld, FarmWorldId)
    end

    disconnectedControl()
    checkReadyTree()

    while world:getTile(getLocal().posx / 32,getLocal().posy / 32).fg == 6 do
        attemptJoinWorld(FarmWorld, FarmWorldId)
        sleep(3000)
    end

    while  isReadyTree == 1 do
        if bot:getInventory():getItemCount(BlockID) <= 180 then
            disconnectedControl()
            if world.name ~= FarmWorld then
                attemptJoinWorld(FarmWorld, FarmWorldId)
            end
            dropTrash()
            bot:say("Harvest!")
            task_harvest()
            sleep(4000)
        end

        if bot:getInventory():getItemCount(BlockID) >= 150 then
            disconnectedControl()
            if world.name ~= FarmWorld then
                attemptJoinWorld(FarmWorld, FarmWorldId)
            end
            dropTrash()
            bot:say("Break!")
            PNB()
        end

        if bot:getInventory():getItemCount(SeedID) > 0 and isPlantSeed then
            isconnectedControl()
            if world.name ~= FarmWorld then
                attemptJoinWorld(FarmWorld, FarmWorldId)
            end
            sleep(3000)
            bot:say("Plant!")
            plant()
            if inventory:getItemCount(SeedID) > 0 then
                dropSeed()
            end
            sleep(3000)
        end

    end
end

bot:say("Started!")

while true do
    mainAction()
    sleep(1000)
end
