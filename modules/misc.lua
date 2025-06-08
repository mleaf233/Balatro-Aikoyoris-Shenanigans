local aikoyori_mod_config = SMODS.current_mod.config

aikoyori_mod_config.wildcard_behaviour = aikoyori_mod_config.wildcard_behaviour or 1

function AKYRS.table_contains(tbl, x)
    local found = false
    for _, v in pairs(tbl) do
        if v == x then
            found = true
        end
    end
    return found
end


AKYRS.aiko_pickRandomInTable = function(t)
    return t[math.random(1, #t)]
end

aiko_alphabets = {}
aiko_alphabets_no_wilds = {}
aiko_alphabets_to_num = {}
for i = 97, 122 do
    table.insert(aiko_alphabets, string.char(i))
    table.insert(aiko_alphabets_no_wilds, string.char(i))
    aiko_alphabets_to_num[string.char(i)] = i - 96
end
table.insert(aiko_alphabets,"#")
aiko_alphabets_to_num["#"] = 27

function AKYRS.alphabet_delta(alpha, delta)
    local numero = string.byte(alpha) + delta
    while numero < string.byte(' ') do
        numero = numero + 95
    end
    if numero > string.byte('~') then
        numero = (numero - string.byte(' ')) % 95 + string.byte(' ')
    end
    return string.char(numero)
end

card_suits = {}
card_suits_with_meta = {}
card_ranks = {}
card_rank_numbers = {}
card_ranks_with_meta = {}

for k, v in pairs(SMODS.Ranks) do
    table.insert(card_ranks_with_meta,v)
end

table.sort(card_ranks_with_meta, function(s1,s2)
    --print("COMPARING "..s1.key.." and "..s2.key)
    return s1.sort_nominal < s2.sort_nominal
end)

for i, v in pairs(card_ranks_with_meta) do
    table.insert(card_ranks,v.key)
    card_rank_numbers[v.key] = i
    --print(v.key,i)
end


for k, v in pairs(SMODS.Suits) do
    table.insert(card_suits, k)
    table.insert(card_suits_with_meta, v)
end

function AKYRS.getNextIDs(id)
    nexts = {}
    if(card_ranks_with_meta[id]) then
            --print(table_to_string(card_ranks_with_meta[id]))
        for i, v in ipairs(card_ranks_with_meta[id].next) do
            table.insert(nexts,card_rank_numbers[v]) 
        end
    end
    --print(table_to_string(nexts))
    return nexts
end


function AKYRS.aiko_intersect_table(a,b)
    local ai = {}
    for _,v in ipairs(a) do
        ai[v] = true
    end
    local ret = {}
    for _,v in ipairs(b) do
        if ai[v] then
            ret[#ret + 1] = v
        end
    end
    return ret
end


function AKYRS.concat_table(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

function AKYRS.getFirstElementOfTable(t)
    for k, v in pairs(t) do
        return v
    end
end

function AKYRS.getFirstKeyOfTable(t)
    for k, v in pairs(t) do
        return k
    end
end


AKYRS.pickableSuit = { "S", "H", "C", "D" }
AKYRS.pickableRank = { "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A" }
AKYRS.rankToNumber = { ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["T"] = 10,
   ["J"] = 11, ["Q"] = 12, ["K"] = 13, ["A"] = 14 }
function AKYRS.concat_table(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

AKYRS.allTarotExceptWheel = {}
-- symbols
AKYRS.non_letter_symbols = {
    "_", "-", "@", "!", "?", "+", "/", "\\", "*", ".", "'", '"', "&", " ", ":", ";", "=", ",", "(",")","[","]","{","}","$","%","^", "`", "~", "|", "<", ">"
}
AKYRS.non_letter_symbols_reverse = {}
for _, symbol in ipairs(AKYRS.non_letter_symbols) do
    AKYRS.non_letter_symbols_reverse[symbol] = true
end


function AKYRS.aiko_mod_startup(self)
    if not self then return end
    if not AKYRS.aikoyori_letters_stickers then
        AKYRS.aikoyori_letters_stickers = {}
    end
    for i, v in ipairs(aiko_alphabets_no_wilds) do
        --print("PREPPING STICKERS "..v, " THE LETTER IS NUMBER "..i.. "should be index x y ",(i - 1) % 10 , math.floor((i-1) / 10))
        AKYRS.aikoyori_letters_stickers[v:upper()] = Sprite(0, 0, self.CARD_W, self.CARD_H, G.ASSET_ATLAS
            ["akyrs_lettersStickers"], { x = (i - 1) % 10, y = math.floor((i - 1) / 10) })
        AKYRS.aikoyori_letters_stickers[v] = Sprite(0, 0, self.CARD_W, self.CARD_H, G.ASSET_ATLAS
            ["akyrs_lettersStickers"], { x = (i - 1) % 10, y = 3 + math.floor((i - 1) / 10) })
    end
    AKYRS.aikoyori_letters_stickers["#"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_lettersStickers"], { x = 6, y = 2 })
    AKYRS.aikoyori_letters_stickers["correct"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_lettersStickers"], { x = 7, y = 2 })
    AKYRS.aikoyori_letters_stickers["misalign"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_lettersStickers"], { x = 8, y = 2 })
    AKYRS.aikoyori_letters_stickers["incorrect"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_lettersStickers"], { x = 9, y = 2 })
    for v = 0, 9 do
        --print("PREPPING STICKERS "..v, " THE LETTER IS NUMBER "..i.. "should be index x y ",(i - 1) % 10 , math.floor((i-1) / 10))
        AKYRS.aikoyori_letters_stickers[v..""] = Sprite(0, 0, self.CARD_W, self.CARD_H, G.ASSET_ATLAS
            ["akyrs_lettersStickers"], { x = (v) % 10, y = 6 + math.floor((v) / 10) })
    end
    for i, v in ipairs(AKYRS.non_letter_symbols) do
        --print("PREPPING STICKERS "..v, " THE LETTER IS NUMBER "..i.. "should be index x y ",(i - 1) % 10 , math.floor((i-1) / 10))
        AKYRS.aikoyori_letters_stickers[v] = Sprite(0, 0, self.CARD_W, self.CARD_H, G.ASSET_ATLAS
            ["akyrs_lettersStickers"], { x = (i - 1) % 10, y = 7 + math.floor((i - 1) / 10) })
    end
    
end


function AKYRS.randomCard()
    local suit =AKYRS.aiko_pickRandomInTable(AKYRS.pickableSuit)
    local rank =AKYRS.aiko_pickRandomInTable(AKYRS.pickableRank)
    return suit .. "_" .. rank
end

function AKYRS.randomSameRank(cardCode)
    local suit = string.sub(cardCode, 1, 1)
    local rank = string.sub(cardCode, 3, 3)
    local newSuit =AKYRS.aiko_pickRandomInTable(AKYRS.pickableSuit)
    while newSuit == suit do
        newSuit =AKYRS.aiko_pickRandomInTable(AKYRS.pickableSuit)
    end
    return newSuit .. "_" .. rank
end

function AKYRS.randomSameSuit(cardCode)
    local suit = string.sub(cardCode, 1, 1)
    local rank = string.sub(cardCode, 3, 3)
    local newRank =AKYRS.aiko_pickRandomInTable(AKYRS.pickableRank)
    while newRank == rank do
        newRank = AKYRS.pickableRank[math.random(1, 13)]
    end
    return suit .. "_" .. newRank
end

function AKYRS.randomConsecutiveRank(cardCode, up, randomSuit)
    local suit = string.sub(cardCode, 1, 1)
    local rank = string.sub(cardCode, 3, 3)
    local newRank = rank
    newRank = AKYRS.pickableRank[math.fmod(AKYRS.rankToNumber[rank] - 1, #AKYRS.pickableRank) + 1]
    if randomSuit then
        local newSuit =AKYRS.aiko_pickRandomInTable(AKYRS.pickableSuit)
        while newSuit == suit do
            newSuit =AKYRS.aiko_pickRandomInTable(AKYRS.pickableSuit)
        end
        return newSuit .. "_" .. newRank
    else
        return suit .. "_" .. newRank
    end
end

function table_to_string(tables)
    if type(tables) == "nil" then
        return "nil"
    end
    local strRet = ""
    for k,v in pairs(tables) do
        local stra = v
        if type(stra) == "table" then
            strRet = strRet..k.." :( "..table_to_string(stra).." ), "
        else
            strRet = strRet..k.." : "..tostring(stra)..", "
        end
    end
    return strRet
end
function table_to_string_depth(tables, depth)
    if depth == 0 then
        local keys = ""
        for k, _ in pairs(tables) do
            keys= keys..k..":k , "
        end
        return "["..#tables.."]"
    end
    if type(tables) == "nil" then
        return "nil"
    end
    local strRet = ""
    for k,v in pairs(tables) do
        local stra = v
        if type(stra) == "table" then
            strRet = strRet..k.." :( "..table_to_string_depth(stra, depth - 1).." ), "
        else
            strRet = strRet..k.." : "..tostring(stra)..", "
        end
    end
    return strRet
end

function AKYRS.getBlindText(key)
    if G.GAME.akyrs_mathematics_enabled then
        return {
            localize("ph_akyrs_math_score_1")..G.GAME.akyrs_math_threshold..localize("ph_akyrs_math_score_2")
            ,nil
        }
    elseif (key == "bl_akyrs_the_thought") and G.GAME.blind and not G.GAME.blind.disabled then
        return {localize("ph_aiko_beat_puzzle"),localize("ph_word_puzzle")}
    else
        return {nil,nil}
    end
end

function AKYRS.getCashOutText(config,scale,stake_sprite)
    
    if G.GAME.aiko_puzzle_win then
        return {n=G.UIT.C, config={padding = 0.05, align = 'cm', minw = 2}, nodes={
            {n=G.UIT.R, config={align = 'cm'}, nodes={
                {n=G.UIT.O, config={object = DynaText({string = {' '..localize('ph_puzzle_clear')..' '}, colours = {G.C.EDITION}, shadow = true, pop_in = 0, float = true, scale = .8*scale, silent = true})}}
            }}
        }}
    end
    if config.saved then return end

    if G.GAME.akyrs_mathematics_enabled then
        return {n=G.UIT.C, config={padding = 0.05, align = 'cm'}, nodes={
            {n=G.UIT.R, config={align = 'cm'}, nodes={
                {n=G.UIT.O, config={object = DynaText({string = {' '..localize("ph_akyrs_math_score_1")..G.GAME.akyrs_math_threshold..localize("ph_akyrs_math_score_2")..' '}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4*scale, silent = true})}}
            }},
            {n=G.UIT.R, config={align = 'cm', minh = 0.8}, nodes={
                {n=G.UIT.O, config={w=0.5,h=0.5 , object = stake_sprite, hover = true, can_collide = false}},
                {n=G.UIT.T, config={text = G.GAME.blind.chip_text, scale = scale_number(G.GAME.blind.chips, scale, 100000), colour = G.C.RED, shadow = true}}
            }}
        }}
    end
end


function AKYRS.getGameOverBlindText()
    if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.key then
        if (G.GAME.blind.config.blind.key == "bl_akyrs_the_thought") then
            return string.upper(G.GAME.word_todo)
        else
            return nil
        end
    else
        return nil
    end
end

function AKYRS.isBlindKeyAThing(inta)
    local comp = inta or G.GAME.blind
    return comp and comp.config and comp.config.blind and comp.config.blind.key and true or nil
end
function AKYRS.getBlindKeySafe(inta)
    local comp = inta or G.GAME.blind
    return comp and comp.config and comp.config.blind and comp.config.blind.key or ""
end

function AKYRS.checkBlindKey(blind_key)
    if AKYRS.isBlindKeyAThing() and blind_key == G.GAME.blind.config.blind.key then
        return true
    end
    return false
end

AKYRS.get_speed_mult = function(card)
    return ((card and (card.area == G.jokers or
        card.area == G.consumeables or
        card.area == G.hand or 
        card.area == G.play or
        card.area == G.shop_jokers or 
        card.area == G.shop_booster or
        card.area == G.load_shop_vouchers
    )) and G.SETTINGS.GAMESPEED) or 1
end

-- credit to nh6574 for helping with this bit
AKYRS.card_area_preview = function(cardArea, desc_nodes, config)
    if not config then config = {} end
    local height = config.h or 1.25
    local width = config.w or 1
    local original_card = config.original_card or AKYRS.current_hover_card or nil
    local speed_mul = config.speed or AKYRS.get_speed_mult(original_card)
    local card_limit = config.card_limit or #config.cards or 1
    local override = config.override or false
    local cards = config.cards or {}
    local padding = config.padding or 0.07
    local func_after = config.func_after or nil
    local init_delay = config.init_delay or 1
    local func_list = config.func_list or nil
    local func_delay = config.func_delay or 0.2
    local margin_left = config.ml or 0.2
    local margin_top = config.mt or 0
    local alignment = config.alignment or "cm"
    local scale = config.scale or 1
    local type = config.type or "title"
    local box_height = config.box_height or 0
    local highlight_limit = config.highlight_limit or 0
    if override or not cardArea then
        cardArea = CardArea(
            G.ROOM.T.x + margin_left * G.ROOM.T.w, G.ROOM.T.h + margin_top
            , width * G.CARD_W, height * G.CARD_H,
            {card_limit = card_limit, type = type, highlight_limit = highlight_limit, collection = true,temporary = true}
        )
        for i, card in ipairs(cards) do
            card.T.w = card.T.w * scale
            card.T.h = card.T.h * scale
            card.VT.h = card.T.h
            card.VT.h = card.T.h
            local area = cardArea
            if(card.config.center) then
                -- this properly sets the sprite size <3
                card:set_sprites(card.config.center)
            end
            area:emplace(card)
        end
    end
    local uiEX = {
        n = G.UIT.R,
        config = { align = alignment , padding = padding, no_fill = true, minh = box_height },
        nodes = {
            {n = G.UIT.O, config = { object = cardArea }}
        }
    }
    if cardArea then
        if desc_nodes then
            desc_nodes[#desc_nodes+1] = {
                uiEX
            }
        end
    end
    if func_after or func_list then 
        G.E_MANAGER:clear_queue("akyrs_desc")
    end
    if func_after then 
        G.E_MANAGER:add_event(Event{
            delay = init_delay * speed_mul,
            blockable = false,
            trigger = "after",
            func = function ()
                func_after(cardArea)
                return true
            end
        },"akyrs_desc")
    end
    
    if func_list then 
        for i, k in ipairs(func_list) do
            G.E_MANAGER:add_event(Event{
                delay = func_delay * i * speed_mul,
                blockable = false,
                trigger = "after",
                func = function ()
                    k(cardArea)
                    return true
                end
            },"akyrs_desc")
        end
    end
    return uiEX
end

AKYRS.temp_card_area = CardArea(
    -99990,-99990,0,0,
    {card_limit = 999999, type = 'title', highlight_limit = 0, collection = true}
)

AKYRS.create_random_card = function(seed)
    return Card(0,0, G.CARD_W, G.CARD_H, pseudorandom_element(G.P_CARDS,pseudoseed(seed)), G.P_CENTERS.c_base)
end


function AKYRS.change_base_skip(card, suit, rank)
    if not card then return false end
    local _suit = SMODS.Suits[suit or card.base.suit]
    local _rank = SMODS.Ranks[rank or card.base.value]
    if not _suit or not _rank then
        sendWarnMessage(('Tried to call SMODS.change_base with invalid arguments: suit="%s", rank="%s"'):format(suit, rank), 'Util')
        return false
    end
    card:set_base(G.P_CARDS[('%s_%s'):format(_suit.card_key, _rank.card_key)], true)
    return card
end

function AKYRS.embedded_ui_sprite( sprite_atlas, sprite_pos, desc_nodes, config )
    if not config then config = {} end
    local sprite_atli = G.ASSET_ATLAS[sprite_atlas]
    local height = config.h or sprite_atli.py
    local width = config.w or sprite_atli.px
    local scale = config.scale or 1
    local padding = config.padding or 0.07
    local rounded = config.rounded or 0.1
    local margin_left = config.ml or 0.2
    local margin_top = config.mt or 0
    local alignment = config.alignment or "cm"
    local box_height = config.box_height or 0
    local aspect_ratio = sprite_atli.px / sprite_atli.py
    local longer_value = math.max(sprite_atli.px, sprite_atli.py)
    local sprt = Sprite(
        G.ROOM.T.x + margin_left * G.ROOM.T.w, G.ROOM.T.h + margin_top
        ,width*scale/(aspect_ratio*longer_value), height*scale/(aspect_ratio*longer_value),
        sprite_atli, sprite_pos
    )
    local uiEX = 
    {
        n = G.UIT.R,
        config = { align = alignment , padding = padding, no_fill = true, minh = box_height, r = rounded },
        nodes = {
            {n = G.UIT.O, config = { object = sprt }}
        }
    }
    if desc_nodes then
        desc_nodes[#desc_nodes+1] = {uiEX}
    end
    return uiEX
end
AKYRS.mod_card_values = function(table_in, config)
    if not config then config = {} end
    local add = config.add or 0
    local multiply = config.multiply or 1
    local keywords = config.keywords or {}
    local unkeyword = config.unkeywords or {}
    local reference = config.reference or table_in
    local function modify_values(table_in, ref)
        for k, v in pairs(table_in) do
            if type(v) == "number" then
                if (keywords[k] or #keywords < 1) and not unkeyword[k] then
                    if ref and ref[k] then
                        table_in[k] = (ref[k] + add) * multiply
                    end
                end
            elseif type(v) == "table" and ref and k then
                modify_values(v, ref[k])
            end
        end
    end
    if table_in == nil then
        return
    end
    modify_values(table_in, reference)
end

AKYRS.mod_card_values_misprint = function(table_in, config)
    if not config then config = {} end
    local add = config.add or 0
    local multiply = config.multiply or 1
    local randomize = config.random or {digits_min = 1, digits_max = 1, min = 1, max = 1,scale = 1 }
    local random_seed = config.randomseed or "modcardvalue"
    random_seed = (G.GAME and G.GAME.pseudorandom.seed or "") .. " - " .. random_seed
    local keywords = config.keywords or {}
    local unkeyword = config.unkeywords or AKYRS.blacklist_mod or {}
    local function_check = config.func or function(name, value) return true end
    local reference = config.reference or table_in
    local function modify_values(table_in, ref)
        for k, v in pairs(table_in) do
            if type(v) == "number" then
                if (keywords[k] or #keywords < 1) and not unkeyword[k] then
                    if ref and ref[k] and function_check(k,ref[k]) then
                        local numberstr = randomize.can_negate and pseudorandom_element({"","-",pseudoseed(random_seed.."a")}) or ""
                        local digits = pseudorandom(pseudoseed(random_seed.."ab"),randomize.digits_min,randomize.digits_max)
                        for i = 1,digits do
                            numberstr = numberstr .. pseudorandom(pseudoseed(random_seed.."b"),0,9)
                        end
                        if numberstr == "" or numberstr == "-" then
                            numberstr = "0"
                        end
                        local number = tonumber(numberstr) * (10 ^ randomize.scale)
                        number = math.fmod(number,randomize.max - randomize.min) + randomize.min
                        table_in[k] = (ref[k] + add) * multiply * number
                    end
                end
            elseif type(v) == "table" and ref and k then
                modify_values(v, ref[k])
            end
        end
    end
    if table_in == nil then
        return
    end
    modify_values(table_in, reference)
end

AKYRS.deep_copy = function(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[AKYRS.deep_copy(orig_key)] = AKYRS.deep_copy(orig_value)
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

AKYRS.get_default_ability = function(key)
    return G.P_CENTERS[key] and G.P_CENTERS[key].config or {}
end

AKYRS.word_splitter = function(word)
    
    local wordArray = {}
    for i = 1, #word do
      table.insert(wordArray, word:sub(i, i))
    end
    return wordArray
end
AKYRS.word_to_cards = function(word)
    
    local wordArray = AKYRS.word_splitter(word)
    local cards = {}
    for i, k in ipairs(wordArray) do
      local new_c = AKYRS.create_random_card("maxwellui")
      new_c.is_null = true
      new_c.ability.aikoyori_letters_stickers = k
      new_c.ability.forced_letter_render = true
      table.insert(cards, new_c)
    end
    return cards
end

AKYRS.HardcoreChallenge = SMODS.Challenge:extend {
    obj_table = AKYRS.HC_CHALLENGES,
    obj_buffer = {},
    get_obj = function(self, key)
        for _, v in ipairs(AKYRS.HC_CHALLENGES) do
            if v.id == key then return v end
        end
    end,
    set = "Challenge",
    required_params = {
        'key',
    },
    deck = { type = "Hardcore Challenge Deck" },
    rules = { custom = {}, modifiers = {} },
    jokers = {},
    consumeables = {},
    vouchers = {},
    restrictions = { banned_cards = {}, banned_tags = {}, banned_other = {} },
    unlocked = function(self) return true end,
    class_prefix = 'hc',
    process_loc_text = function(self)
        SMODS.process_loc_text(G.localization.misc.hardcore_challenge_names, self.key, self.loc_txt, 'name')
    end,
    register = function(self)
        if self.registered then
            sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
            return
        end
        self.id = self.key
        -- only needs to be called once
        SMODS.insert_pool(AKYRS.HC_CHALLENGES, self)
        SMODS.Challenge.super.register(self)
    end,
    inject = function(self) end,
}

function AKYRS.find_stake_from_level(level)
    for i, k in pairs(G.P_STAKES) do 
        if k == level then
            return i, k
        end
        if k.key == level then
            return i, k
        end
        if k.stake_level == level then
            return i, k
        end
    end
    return nil, nil
end

AKYRS.crypternity = function (e)
    e.akyrs_sigma = true
    return e
end

AKYRS.swap_case = function (word)
    if not word then return nil end
    local swapped = ""
    for i = 1, #word do
        local c = word:sub(i, i)
        if c:match("%l") then
            swapped = swapped .. c:upper()
        elseif c:match("%u") then
            swapped = swapped .. c:lower()
        else
            swapped = swapped .. c
        end
    end
    return swapped
end

local uppercaser = {
    ["`"] = "~",
    ["1"] = "!",
    ["2"] = "@",
    ["3"] = "#",
    ["4"] = "$",
    ["5"] = "%",
    ["6"] = "^",
    ["7"] = "&",
    ["8"] = "*",
    ["9"] = "(",
    ["0"] = ")",
    ["-"] = "_",
    ["="] = "+",
    [";"] = ":",
    ["'"] = '"',
    [","] = "<",
    ["."] = ">",
    ["/"] = "?",
    ["\\"] = "|",
    ["["] = "{",
    ["]"] = "}",
}

function AKYRS.get_shifted_from_key(key)
    local k = key
    if key and uppercaser[key] then 
        k = uppercaser[key]
    elseif string.upper(key) ~= key then
        k = string.upper(key)
    end
    return k
end

function AKYRS.is_value_within_threshold(target, value, threshold_percent)
    local threshold = target * (threshold_percent / 100)
    if Talisman then
        return to_big(math.abs(target - value)):lte(threshold)
    end
    return math.abs(target - value) <= threshold
end

function AKYRS.adjust_rounding(num)
    return math.floor(num*10)/10
end

function AKYRS.does_hand_only_contain_symbols(cardarea)
    if G.deck and G.deck.cards and #G.deck.cards > 0 then return false end
    for i,k in ipairs(cardarea.cards) do
        if tonumber(k.ability.aikoyori_letters_stickers) then
            return false
        end
    end
    return true
end

AKYRS.make_new_card_area = function(config)
    if not config then config = {} end
    local height = config.h or 1.25
    local width = config.w or 1
    local card_limit = config.card_limit or 52
    local margin_left = config.ml or 0.
    local margin_top = config.mt or 0
    local type = config.type or "title"
    local temporary = config.temporary or false
    local akyrs_pile_drag = config.pile_drag or nil
    local highlight_limit = config.highlight_limit or 0
    local emplace_func = config.emplace_func or nil
    local sol_emplace_func = config.sol_emplace_func or nil
    local use_room = config.use_room or true
    local ca = CardArea(
        (use_room and G.ROOM.T.x or 0) + margin_left * (use_room and G.ROOM.T.w or 1), (use_room and G.ROOM.T.h or 0) + margin_top
        , width , height,
        {card_limit = card_limit, type = type, highlight_limit = highlight_limit, akyrs_emplace_func = emplace_func, akyrs_sol_emplace_func = sol_emplace_func, temporary = temporary, akyrs_pile_drag=akyrs_pile_drag }
    )
    ca.states.collide.can = true
    ca.states.release_on.can = true
    return ca
end

AKYRS.destroy_existing_cards = function(cardarea)
    if cardarea and cardarea.cards then
        for i,k in ipairs(cardarea.cards) do
            k:start_dissolve(nil, true)
        end
    end
    if cardarea then 
        cardarea:remove()
    end
end


function AKYRS.draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only, forced_facing)
    percent = percent or 50
    delay = delay or 0.1 
    if dir == 'down' then 
        percent = 1-percent
    end
    sort = sort or false
    local drawn = nil

    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = delay,
        blocking = not (G.SETTINGS.GAMESPEED >= 999 and ((to == G.hand and from == G.deck) or (to == G.deck and from == G.hand))), -- Has to be these specific draws only, otherwise it's buggy
        
        func = function()
            if card then 
                if from then card = from:remove_card(card) end
                if card then drawn = true end
                if card and to == G.hand and not card.states.visible then
                    card.states.visible = true
                end
                local stay_flipped = G.GAME and G.GAME.blind and G.GAME.blind:stay_flipped(to, card, from)
                if to then
                    to:emplace(card, nil, stay_flipped)
                else
                    
                end
                if card and forced_facing then 
                    card.sprite_facing = forced_facing
                    card.facing = forced_facing
                end
            else
                card = to:draw_card_from(from, stay_flipped, discarded_only)
                if card then drawn = true end
                if card and to == G.hand and not card.states.visible then
                    card.states.visible = true
                end
                if card and forced_facing then 
                    card.sprite_facing = forced_facing
                    card.facing = forced_facing
                end
            end
            if not mute and drawn then
                if from == G.deck or from == G.hand or from == G.play or from == G.jokers or from == G.consumeables or from == G.discard then
                    G.VIBRATION = G.VIBRATION + 0.6
                end
                play_sound('card1', 0.85 + percent*0.2/100, 0.6*(vol or 1))
            end
            if sort then
                to:sort()
            end
            SMODS.drawn_cards = SMODS.drawn_cards or {}
            if card and card.playing_card then SMODS.drawn_cards[#SMODS.drawn_cards+1] = card end
            
            if card and forced_facing then 
                card.facing = forced_facing
                card.sprite_facing = forced_facing
            end
            return true
        end
      }))
end
function AKYRS.instant_draw_card(from, to, percent, dir, sort, card, mute, stay_flipped, vol, discarded_only, forced_facing)
    percent = percent or 50
    if dir == 'down' then 
        percent = 1-percent
    end
    sort = sort or false
    local drawn = nil

    if card then 
        if from then card = from:remove_card(card) end
        if card then drawn = true end
        if card and to == G.hand and not card.states.visible then
            card.states.visible = true
        end
        local stay_flipped = G.GAME and G.GAME.blind and G.GAME.blind:stay_flipped(to, card, from)
        if to then
            to:emplace(card, nil, stay_flipped)
        else
            
        end
        if card and forced_facing then 
            card.sprite_facing = forced_facing
            card.facing = forced_facing
        end
    else
        card = to:draw_card_from(from, stay_flipped, discarded_only)
        if card then drawn = true end
        if card and to == G.hand and not card.states.visible then
            card.states.visible = true
        end
        if card and forced_facing then 
            card.sprite_facing = forced_facing
            card.facing = forced_facing
        end
    end
    if not mute and drawn then
        if from == G.deck or from == G.hand or from == G.play or from == G.jokers or from == G.consumeables or from == G.discard then
            G.VIBRATION = G.VIBRATION + 0.6
        end
        play_sound('card1', 0.85 + percent*0.2/100, 0.6*(vol or 1))
    end
    if sort then
        to:sort()
    end
    SMODS.drawn_cards = SMODS.drawn_cards or {}
    if card and card.playing_card then SMODS.drawn_cards[#SMODS.drawn_cards+1] = card end
    
    if card and forced_facing then 
        card.facing = forced_facing
        card.sprite_facing = forced_facing
    end
    return true
        
end

AKYRS.simple_event_add = function (func, delay, queue)
    G.E_MANAGER:add_event(Event{
        trigger = 'after',
        delay = delay or 0.1,
        func = func
    }, queue)
end

AKYRS.check_type = function(d)
    local type_map = {
        {"Controller",Controller},
        {"Particles",Particles},
        {"DynaText",DynaText},
        {"Back",Back},
        {"Blind",Blind},
        {"Card",Card},
        {"Tag",Tag},
        {"CardArea",CardArea},
        {"UIElement",UIElement},
        {"UIBox",UIBox},
        {"AnimatedSprite",AnimatedSprite},
        {"Sprite",Sprite},
        {"Card_Character",Card_Character},
        {"Event",Event},
        {"EventManager",EventManager},
        {"Game",Game},
        {"Moveable",Moveable},
        {"Node",Node},
        {"Object",Object},
    }

    for i, class_ref in ipairs(type_map) do
        if d:is(class_ref[2]) then
            return class_ref[1]
        end
    end

    return type(d)
end

function AKYRS.is_in_table(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function AKYRS.find_index(table, value)
    for index, v in ipairs(table) do
        if v == value then
            return index
        end
    end
    return nil
end

function AKYRS.remove_value_from_table(tbl, value)
    local index = AKYRS.find_index(tbl, value)
    if index then
        table.remove(tbl, index)
        return true
    end
    return false
end

function AKYRS.recalculate_cardarea_bundler(cardarea, func, reset)
    local logic = func or function(x) return x.states.drag.is or x.states.click.is end
    for k, card in ipairs(cardarea.cards) do -- G.CONTROLLER.hovering.target.area.cards
        if logic(card) then
            
            card.following_cards = reset and {} or (card.following_cards or {})
            for ke, card2 in ipairs(cardarea.cards) do
                if ke > k and not AKYRS.is_in_table(card.following_cards,card2) and not card2.is_being_pulled then
                    table.insert(card.following_cards, card2)
                    --print(AKYRS.C2S(card2))
                    --print("CARDS IN THE THING - "..AKYRS.TBL_C2S(card.following_cards))
                    
                end
            end
        end

    end
    cardarea.last_card_amnt = #cardarea.cards
end
function AKYRS.reset_cardarea_bundler(cardarea)
    for k, card in ipairs(cardarea.cards) do -- G.CONTROLLER.hovering.target.area.cards
        card.following_cards = nil

    end
end

function AKYRS.C2S(card)
    return (card.base.value .. " of " .. card.base.suit)
end


function AKYRS.TBL_C2S(table)
    local result = ""
    for _, card in ipairs(table) do
        if type(card) == "table" and card.base and card.base.value and card.base.suit then
            result = result .. AKYRS.C2S(card) .. ", "
        else
            return nil
        end
    end
    return result:sub(1, -3) -- Remove the trailing ", "
end

function AKYRS.is_valid_enhancement(name)
    for _, v in pairs(G.P_CENTER_POOLS.Enhanced) do
        local first_part = string.split(v.name," ")[1]
        if first_part == name then
            return true
        end
    end
    return false
end

function AKYRS.is_valid_edition(name)
    for _, v in pairs(G.P_CENTER_POOLS.Edition) do
        if v.name == name then
            return true
        end
    end
    return false
end

function string.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end


function AKYRS.capitalize(stringIn)
    return string.gsub(" " .. stringIn, "%W%l", string.upper):sub(2)
end


function AKYRS.remove_comma(string)
    return string.gsub(string, ",", "")
end

function AKYRS.score_catches_fire_or_not()
    if not G.GAME or not G.GAME.blind then return false end


    if type(G.GAME.blind.chips) == "string" then
        local stud = tonumber(AKYRS.remove_comma(G.GAME.blind.chips))
        if stud ~= stud then
            return false
        end
        G.GAME.blind.chips = Talisman and to_big(stud) or stud

    end
    if Talisman then
        G.GAME.current_round.current_hand.chips = to_big(G.GAME.current_round.current_hand.chips)
        G.GAME.current_round.current_hand.mult = to_big(G.GAME.current_round.current_hand.mult)
        G.GAME.blind.chips = to_big(G.GAME.blind.chips)
    end
    return G.GAME.current_round.current_hand.chips * G.GAME.current_round.current_hand.mult > G.GAME.blind.chips
end


AKYRS.word_letter_count = function(word)
    
    local wordArray = {}
    for i = 1, #word do
        wordArray[word:sub(i, i)] = wordArray[word:sub(i, i)] and wordArray[word:sub(i, i)] + 1 or 1
    end
    return wordArray
end

AKYRS.get_letter_freq_from_cards = function(listofcards)
    
    local wordArray = {}
    for i,v in ipairs(listofcards) do
        local w = string.lower(v:get_letter_with_pretend())
        wordArray[w] = wordArray[w] and wordArray[w] + 1 or 1
    end
    return wordArray
end
AKYRS.get_ranks_freq_from_cards = function(listofcards)
    
    local wordArray = {}
    for i,v in ipairs(listofcards) do
        if not SMODS.has_no_rank(v) then
            local w = v:get_id()
            wordArray[w] = wordArray[w] and wordArray[w] + 1 or 1
        end
    end
    return wordArray
end
AKYRS.icon_sprites = {}

AKYRS.remove_formatting = function(string_in)
    return string.gsub(string_in, "{.-}", "")
end
AKYRS.full_ui_add = function(nodes, key, scale)
    local m = G.localization.descriptions["DescriptionDummy"][key]
    local l = {
        {
            n = G.UIT.R,
            nodes = {
                { n = G.UIT.T, config = { text = m.name, colour = G.C.UI.TEXT_LIGHT, scale = scale*1.2 }},
            }
        }
    }
    if m.text and false then
        for i, tx in ipairs(m.text) do
            table.insert(l, 
                {
                    n = G.UIT.R,
                    nodes = {
                        { n = G.UIT.T, config = { text = AKYRS.remove_formatting(tx), colour = G.C.UI.TEXT_LIGHT, scale = scale }},
                    }
                }
            )
        end
    end
    
    local x = {
        n = G.UIT.C,
        config = { align = "lm", padding = 0.1 },
        nodes = {
            { n = G.UIT.R, config = {}, nodes = l },
            
        }
    }
    table.insert(nodes, x)
end

AKYRS.hand_sort_function = function (a,b)
    if G.GAME and G.GAME.words_reversed then
        return a.T.x > b.T.x
    end
    return a.T.x < b.T.x    
end

G.FUNCS.go_to_aikoyori_discord_server = function(e)
    love.system.openURL( "https://discord.gg/JVg8Bynm7k" )
end

AKYRS.shallow_indexed_table_copy = function(t)
    local t2 = {}
    for i,k in ipairs(t) do
        table.insert(t2,k)
    end
    return t2
end

AKYRS.get_current_blind_config = function()
    return G.P_BLINDS[G.GAME.round_resets.blind_choices[G.GAME.blind_on_deck]]
end

function AKYRS.search_UIT_for_id(uit, id)
    if not id or not uit then return nil end
    for _, node in ipairs(uit.nodes or {}) do
        if node.config and node.config.id == id then
            return node
        elseif node.nodes then
            local result = AKYRS.search_UIT_for_id(node, id)
            if result then
                return result
            end
        end
    end
    return nil
end

AKYRS.blacklist_mod = {
    ["cry_prob"] = true,
    ["akyrs_cycler"] = true,
    ["immutable"] = true,
}


AKYRS.edition_extend_card_limit = function(card)
    if card then
        if card.edition then
            if card.edition.key == "e_negative" then
                return 1
            end
            if card.edition.key == "e_akyrs_noire" then
                return 2
            end
        end
    end
    return 0
end

AKYRS.card_any_drag = function()
    return G and G.GAME and ((G.GAME.akyrs_any_drag and not G.OVERLAY_MENU) or G.GAME.akyrs_ultimate_freedom)
end

AKYRS.construct_case_base = function(suit, rank)
    
    local _suit = SMODS.Suits[suit]
    local _rank = SMODS.Ranks[rank]
    if not _suit or not _rank then
        return nil, ('Tried to call SMODS.change_base with invalid arguments: suit="%s", rank="%s"'):format(suit, rank)
    end
    return G.P_CARDS[('%s_%s'):format(_suit.card_key, _rank.card_key)]
end


function AKYRS.remove_all(t, predicate)
    for i=#t, 1, -1 do
        local v=t[i]
        table.remove(t, i)
        if v and predicate(v) and v.children then
            AKYRS.remove_all(v.children, predicate)
        end
        if v and predicate(v) then v:remove() end
        v = nil
    end
    for _, v in pairs(t) do
        if predicate(v) then
            if v.children then 
                AKYRS.remove_all(v.children, predicate)
            end
            v:remove()
            v = nil
        end
    end
end


function AKYRS.akyrs_remove(uibox,predicate)
    
    if uibox == G.OVERLAY_MENU then G.REFRESH_ALERTS = true end
    uibox.UIRoot:remove()
    for k, v in pairs(G.I[uibox.config.instance_type or 'UIBOX']) do
        if v == uibox then
            table.remove(G.I[uibox.config.instance_type or 'UIBOX'], k)
            break;
        end
    end
    AKYRS.remove_all(uibox.children, predicate)
    Moveable.remove(uibox)
end

function AKYRS.get_p_card_ranks(not_r)
    not_r = not_r or {}
    local ranks = {}
    if not G.playing_cards then return {} end
    for i,j in ipairs(G.playing_cards) do
        --print(j.base.value)
        if j and not SMODS.has_no_rank(j) and j.base.value and SMODS.Ranks[j.base.value] and not not_r[j.base.value] and not AKYRS.find_index(ranks,SMODS.Ranks[j.base.value]) then
            table.insert(ranks,SMODS.Ranks[j.base.value])
        end
    end
    return ranks
end

AKYRS.sort_top = function(a, b)
    return (a.akyrs_stay_on_top or 0) < (b.akyrs_stay_on_top or 0)
end

AKYRS.should_hide_ui = function()
    return next(SMODS.find_card("j_akyrs_no_hints_here")) or G.GAME.akyrs_no_hints or nil
end

AKYRS.remove_objects_in_nodes = function(nodes)
    if #nodes <= 0 then return end
    for _, node in ipairs(nodes) do
        if node.config and node.config.object then 
            node.config.object:remove()
        end
        if node.nodes then
            AKYRS.remove_objects_in_nodes(node.nodes)
        end
    end
end

AKYRS.game_areas = function(area)
    return area == G.play or area == G.hand or area == G.deck or area == G.discard or area == G.jokers or area == G.consumeables or nil
end
AKYRS.non_removing_area = function(area)
    return area == G.hand or area == G.deck or area == G.discard or area == G.jokers or area == G.consumeables or nil
end
AKYRS.non_removing_play_state = function()
    return G.STATE == G.STATES.DRAW_TO_HAND or G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.HAND_PLAYED or G.STATE == G.STATES.ROUND_EVAL
end
AKYRS.is_card_not_sigma = function(card) 
    return card.ability.consumeable or card.ability.set == "Booster" or card.ability.set == "Voucher" or nil
end

AKYRS.nope_buzzer = function(major, text, colour, rotate, scale, hold)
    play_sound("akyrs_loud_incorrect_buzzer",1,0.2)
    attention_text({
        text = text or localize("k_nope_ex"),
        scale = scale or 1, 
        hold = hold or 1.0,
        rotate = rotate or math.pi / 8,
        backdrop_colour = colour or G.GAME.blind.boss_colour,
        align = "cm",
        major = major or G.GAME.blind,
        offset = {x = 0, y = 0.1}
    })
end

AKYRS.wrap_in_col = function(table_ui)
    local x = {}
    for _,v in ipairs(table_ui) do
        x[#x+1] = { n = G.UIT.C, nodes = {v}}
    end
    return x
end


AKYRS.bal = function(balance)
    if balance then
        return G.PROFILES[G.SETTINGS.profile].akyrs_balance == balance
    end
    return G.PROFILES[G.SETTINGS.profile].akyrs_balance
end

AKYRS.bal_val = function(adeq,absu)
    if AKYRS.bal("adequate") then return adeq end
    if AKYRS.bal("absurd") then return absu end
end

AKYRS.remove_dupes = function(tabled)
    if not tabled then return end
    local seen = {}
    for i = #tabled, 1, -1 do
        local card = tabled[i]
        if seen[card] then
            table.remove(tabled, i)
        else
            seen[card] = true
        end
    end
end


AKYRS.change_letter_to = function(card,letter,respect_wild)
    if not card or not letter then return false end
    if respect_wild and card.ability.aikoyori_letters_stickers == "#" then
        card.ability.aikoyori_pretend_letter = letter
    else
        card.ability.aikoyori_letters_stickers = letter
    end
    
end

-- i hate writing lua in the patch\
-- also return blind requirement
AKYRS.mod_blind_requirement = function(blind,chips)
    if blind.debuff.akyrs_anteth_power_of_x_blind_req then
        local ante_power = G.GAME.round_resets.ante ^ blind.debuff.akyrs_anteth_power_of_x_blind_req_power * blind.debuff.akyrs_anteth_power_of_x_blind_req_multiplier
        chips = chips * blind.debuff.akyrs_anteth_power_of_x_blind_req ^ ante_power
    end
    return chips
end

-- this one returns a node so we can add it to the blind popup
AKYRS.mod_blind_display = function(blind)
    if blind.debuff.akyrs_anteth_power_of_x_blind_req then
        local blind_exp_has_power = blind.debuff.akyrs_anteth_power_of_x_blind_req_power and blind.debuff.akyrs_anteth_power_of_x_blind_req_power ~= 1
        local blind_exp_has_multi = blind.debuff.akyrs_anteth_power_of_x_blind_req_multiplier and blind.debuff.akyrs_anteth_power_of_x_blind_req_multiplier ~= 1

        local pwrd = blind.debuff.akyrs_anteth_power_of_x_blind_req .. "^" .. 
            (blind_exp_has_multi and "("..blind.debuff.akyrs_anteth_power_of_x_blind_req_multiplier or "") ..
            (blind_exp_has_power and "("..localize('k_akyrs_power_ante').."^"..blind.debuff.akyrs_anteth_power_of_x_blind_req_power..")" or localize('k_akyrs_power_ante')) ..
            (blind_exp_has_multi and ")" or "") 


        return {n=G.UIT.T, config={text = pwrd..localize('k_x_base'), scale = 0.4, colour = G.C.RED}}
    end
end

AKYRS.word_blind = function()
    return (G.GAME.blind and G.GAME.blind.debuff.akyrs_is_word_blind)
end

AKYRS.pos_to_val = function(ind,targ)
    if not ind or not targ then return end
    local calc_ind = ind - (targ+1) / 2 
    return Talisman and (to_big(1.1):pow(calc_ind)) or 1.1 ^ calc_ind
end


function AKYRS.bulk_level_up(center, card, area, copier, number, silent)
	local used_consumable = copier or card
	if not number then
		number = 1
	end
	for _, v in pairs(card.config.center.config.akyrs_hand_types) do
		update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 }, {
			handname = localize(v, "poker_hands"),
			chips = G.GAME.hands[v].chips,
			mult = G.GAME.hands[v].mult,
			level = G.GAME.hands[v].level,
		})
		level_up_hand(used_consumable, v, silent, number)
	end
	update_hand_text(
		{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
		{ mult = 0, chips = 0, handname = "", level = "" }
	)
end

function AKYRS.silent_bulk_level_up(center, card, area, copier, number)
	local used_consumable = copier or card
	if not number then
		number = 1
	end

    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_words_long'),chips = '...', mult = '...', level=''})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        G.TAROT_INTERRUPT_PULSE = true
        return true end }))
    update_hand_text({delay = 0}, {mult = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        return true end }))
    update_hand_text({delay = 0}, {chips = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        G.TAROT_INTERRUPT_PULSE = nil
        return true end }))
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+1'})
    delay(1.3)
    for k, v in pairs(card.config.center.config.akyrs_hand_types) do
		level_up_hand(used_consumable, v, true, number)
    end
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
end

function AKYRS.blk_lvl_up(hands, card, number)
	local used_consumable = card
	if not number then
		number = 1
	end

    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_akyrs_multiple_hands'),chips = '...', mult = '...', level=''})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
        play_sound('tarot1')
        if card then card:juice_up(0.8, 0.5) end
        G.TAROT_INTERRUPT_PULSE = true
        return true end }))
    update_hand_text({delay = 0}, {mult = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        if card then card:juice_up(0.8, 0.5) end
        return true end }))
    update_hand_text({delay = 0}, {chips = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        if card then card:juice_up(0.8, 0.5) end
        G.TAROT_INTERRUPT_PULSE = nil
        return true end }))
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+1'})
    delay(1.3)
    for k, v in pairs(hands) do
		level_up_hand(used_consumable, k, true, number)
    end
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
end

function AKYRS.balala(joker, poker)
    AKYRS.simple_event_add(function()error("it's balala time!",4) return true end,0)
end