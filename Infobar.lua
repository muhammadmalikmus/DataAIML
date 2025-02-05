local function getColor(number, max)
    local r, g, b
    i = math.abs(number, max, 9)

    if i <= 1 then r, g, b = 255, 0, 0
        elseif i == 2 then r, g, b = 237, 27, 3
        elseif i == 3 then r, g, b = 235, 63, 6
        elseif i == 4 then r, g, b = 229, 104, 8
        elseif i == 5 then r, g, b = 228, 126, 10
        elseif i == 6 then r, g, b = 220, 169, 16
        elseif i == 7 then r, g, b = 213, 201, 19
        elseif i == 8 then r, g, b = 176, 205, 10
        elseif i == 9 then r, g, b = 124, 195, 13
    end

    return r, g, b
end


function gradient(x1, y1, x2, y2, left)
    local w = x2 - x1
    local h = y2 - y1

    for i = 0, w do
        local a = (i / w) * 200

        draw.Color(0, 0, 0, a)
        if left then
            draw.FilledRect(x1 + i, y1, x1 + i + 1, y1 + h)
        else
            draw.FilledRect(x1 + w - i, y1, x1 + w - i + 1, y1 + h)
        end
    end
end

local frame_rate = 0.0
local get_abs_fps = function()
    frame_rate = 0.9 * frame_rate + (1.0 - 0.9) * globals.AbsoluteFrameTime()
    return math.floor((1.0 / frame_rate) + 0.5)
end


local kills  = {}
local deaths = {}

local function KillDeathCount(event)

    local local_player = client.GetLocalPlayerIndex( );
    local INDEX_Attacker = client.GetPlayerIndexByUserID( event:GetInt( 'attacker' ) );
    local INDEX_Victim = client.GetPlayerIndexByUserID( event:GetInt( 'userid' ) );

    if (event:GetName( ) == "client_disconnect") or (event:GetName( ) == "begin_new_match") then
        kills = {}
        deaths = {}
    end

    if event:GetName( ) == "player_death" then
        if INDEX_Attacker == local_player then
            kills[#kills + 1] = {};
        end
        
        if (INDEX_Victim == local_player) then
            deaths[#deaths + 1] = {};
        end

    end
end

function paint_traverse()
    local x, y = draw.GetScreenSize()
    local centerX = x / 2
	local r, g, b = getColor(get_abs_fps(), 100)
	
    --left
    gradient(centerX - 200, y - 20, centerX - 51, y, 0, true)
    gradient(centerX - 200, y - 20, centerX - 51, y - 19, true)
   
    --middle
    draw.Color(0, 0, 0, 200)
    draw.FilledRect(centerX - 50, y - 20, centerX + 50, y)

    draw.Color(0, 0, 0, 255)
    draw.FilledRect(centerX - 50, y - 20, centerX + 50, y - 19)

    --right
    gradient(centerX + 50, y - 20, centerX + 200, y, false)
    gradient(centerX + 50, y - 20, centerX + 200, y - 19, false)

    --fps
    draw.Color(255, 255, 255, 255)
    draw.Text(centerX - 20, y - 15, get_abs_fps())

    draw.Color(200, 255, 0, 255)
    draw.Text(centerX + 10, y - 15, "FPS")

    --kills
    draw.Color(255, 255, 255, 255)
    draw.Text(centerX - 73, y - 15, #kills)

    draw.Color(255, 100, 0, 255)
    draw.Text(centerX - 55, y - 15, "Kills")

    --deaths
    draw.Color(255, 255, 255, 255)
    draw.Text(centerX + 47, y - 15, #deaths)

    draw.Color(255, 50, 50, 255)
    draw.Text(centerX + 65, y - 15, "Deaths")
end

client.AllowListener( "player_death" );
client.AllowListener( "client_disconnect" );
client.AllowListener( "begin_new_match" );
callbacks.Register( "FireGameEvent", "KillDeathCount", KillDeathCount);
callbacks.Register("Draw", "paint_traverse", paint_traverse);