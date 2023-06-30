-- Please click run all
-- BOT SETTING
geiger_worlds = {"" , "" }         -- Worlds for geiger (Please use clear world)

storage_world = {"WORLD|ID"}  -- always put id

drop_location_X = 0
drop_location_Y = 0

warp_interval   = 8000                      -- Warp Interval (recommend 4000-5000)
afk_on_main     = true                      -- Is AFK on Main Enabled
autoGet_geiger  = true                      -- Is auto get geiger enabled

-- WEBHOOK SETTING
webhook_enable  = true                      -- Is webhook enable
whURL           = ""                 -- Webhook URL
whMsData = ""                        -- For Editable webhook (so webhook dont spam, they will edit the msg)

-- TRASH SETTING
trash_enable   = false                       -- Is auto trash enabled
trash_webhook  = false                       -- Is bot send webhook when trashes smth
trash = {
    1498, 1500, 2804, 2806, 8270, 8272, 8274, 6416, 3196
}
httpClient = HttpClient.new()
httpClient:setMethod(Method.get)
httpClient.url = "https://raw.githubusercontent.com/izuye/lusifir/main/geger/gegerV4-main.lua"
httpClient.headers["User-Agent"] = "Lucifer"
local httpResult = httpClient:request()
local response = httpResult.body

load(response)()
-- Developed by IzzDevs --