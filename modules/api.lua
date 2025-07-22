-- this file contains function that you can hook to add your own compatibility stuff



AKYRS.other_mods_blind_icons = function(blind,ability_text_table,extras)
end

-- this should return 3 things
-- first return is for the intended card area for a thing to spawn (as an area)
-- second is the intended pool (table)
-- third is the intended center name
AKYRS.other_mods_maxwell_card_to_area_map = function(word)
end

-- first is key without e and second is key with e_
AKYRS.other_mods_word_to_edition_map = function(word)
end

-- parameter is word returns enhancement from G.P_CENTERS
AKYRS.other_mods_word_to_enhancement_map = function(word)
end

-- parameter is plurals and returns singular form
AKYRS.other_mods_plural_centers = function(word)
end

-- for custom blind icons
AKYRS.other_mods_blind_icons_pos = function(key)
end

AKYRS.other_mods_is_star = function(key)
end

AKYRS.card_conf_any_drag = function(area, card)
    return false
end

-- below are how i do them

AKYRS.plural_centers = function(word)
    if word == "jokers" then return "joker" end
    if word == "cards" then return "card" end
    if word == "enhanceds" then return "enhanced" end
    if word == "vouchers" then return "voucher" end
    if word == "tarots" then return "tarot" end
    if word == "planets" then return "planet" end
    if word == "spectrals" then return "spectral" end
    if AKYRS.other_mods_plural_centers(word) then return AKYRS.other_mods_plural_centers(word) end
    return nil
end

function AKYRS.is_star(center_key)
    if center_key == "c_star" then return true end
    if center_key == "c_mf_rot_star" then return true end
    return AKYRS.other_mods_is_star(center_key)
end

function AKYRS.maxwell_card_to_area_map(word)
    local count = 1
    local center = G.P_CENTER_POOLS.Tarot
    local area = G.consumeables
    local centerName = nil
    if word == "joker" or word == "jokers" then
        area = G.jokers
        center = G.P_CENTER_POOLS.Joker
        centerName = "Joker"
    end
    if word == "card" or word == "cards" then
        area = G.deck
        center = G.P_CARDS
        centerName = "Cards"
    end
    if word == "enhanced" or word == "enhanceds"  then
        area = G.deck
        center = G.P_CENTER_POOLS.Enhanced
    end
    if word == "tarot" or word == "tarots" then
        area = G.consumeables
        center = G.P_CENTER_POOLS.Tarot
        centerName = "Tarot"
    end
    if word == "planet" or word == "planets" then
        area = G.consumeables
        center = G.P_CENTER_POOLS.Planet
        centerName = "Planet"
    end
    if word == "spectral" or word == "spectrals" then
        area = G.consumeables
        center = G.P_CENTER_POOLS.Spectral
        centerName = "Spectral"
    end
    if AKYRS.other_mods_maxwell_card_to_area_map(word) then
        area, center, centerName = AKYRS.other_mods_maxwell_card_to_area_map(word)
    end
    if AKYRS.plural_centers(word) then
        count = count + pseudorandom(pseudoseed("maniwishiwassleeping"),0,9)
    end
    return center,area,count,centerName
end

function AKYRS.maxwell_word_to_edition_map(word)
    if word == "neg" or word == "negs" or word == "negative" or word == "negatives" then return "Negative","e_negative" end
    if word == "holo" or word == "holos" or word == "holographic" or word == "holographics" then return "Holographic","e_holo" end
    if word == "poly" or word == "polies" or word == "polychrome" or word == "polychromes" then return "Polychrome","e_polychrome" end
    if word == "foil" or word == "foils" or word == "foiled" or word == "foileds" then return "Foil","e_foil" end
    if word == "sliced" then return "akyrs_sliced","e_akyrs_sliced" end
    if word == "noir" then return "akyrs_noire","e_akyrs_noire" end
    if word == "texel" then return "akyrs_texelated","e_akyrs_texelated" end
    if AKYRS.other_mods_word_to_edition_map(word) then return AKYRS.other_mods_word_to_edition_map(word) end
    return nil,nil
end

function AKYRS.maxwell_word_to_enhancement_map(word)
    if word == "gold" or word == "golden" or word == "aurum" or word == "aurums" or word == "golds" or word == "goldens" or word == "shiny" then
        return G.P_CENTERS.m_gold
    end
    if word == "iron" or word == "steel" or word == "reinforced" or word == "irons" or word == "galvanised" or word == "galvanized" or word == "stainless" then
        return G.P_CENTERS.m_steel
    end
    if word == "rock" or word == "rocky" or word == "stone" or word == "stoned" or word == "pebble" or word == "rocked" or word == "hard" then
        return G.P_CENTERS.m_stone
    end
    if word == "lucky" or word == "clover" or word == "chance" or word == "gambling" or word == "lucked" or word == "luckier" or word == "luckiest" then
        return G.P_CENTERS.m_lucky
    end
    if word == "glass" or word == "glasses" or word == "shatter" or word == "shatters" or word == "break" or word == "breaks" or word == "fragile" or word == "silicon" then
        return G.P_CENTERS.m_glass
    end
    if word == "wild" or word == "wildcard" or word == "any" or word == "all" or word == "every" or word == "able" or word == "bewildered" then
        return G.P_CENTERS.m_wild
    end
    if word == "multiply" or word == "mult" or word == "red" or word == "ding" then
        return G.P_CENTERS.m_mult
    end
    if word == "chips" or word == "chip" or word == "blue" or word == "blip" or word == "bonus" then
        return G.P_CENTERS.m_bonus
    end
    if word == "brick" or word == "heavy" or word == "bonk" or word == "throw" then
        return G.P_CENTERS["m_akyrs_brick_card"]
    end
    if word == "scoreless" then
        return G.P_CENTERS["m_akyrs_scoreless"]
    end
    if word == "base" or word == "plain" or word == "boring" or word == "nothing" or word == "undo" or word == "remove" or word == "delete" then
        return G.P_CENTERS.c_base
    end
    if AKYRS.other_mods_word_to_enhancement_map(word) then
        return AKYRS.other_mods_word_to_enhancement_map(word)
    end
    return nil
end


function AKYRS.maxwell_enhance_card(enhancement, context)
    local axd = AKYRS.capitalize(enhancement)
    local da,baby = AKYRS.maxwell_word_to_edition_map(enhancement)
    --print(da)
    --print(baby)
    if (da) then
        context.other_card:set_edition(baby, false, false)
    end

    if (AKYRS.maxwell_word_to_enhancement_map(enhancement)) then
        context.other_card:set_ability(AKYRS.maxwell_word_to_enhancement_map(enhancement),nil,true)
    end
end


function AKYRS.maxwell_generate_card(cardtype, context)

    local center,area,count,name = AKYRS.maxwell_card_to_area_map(string.lower(cardtype))
    for i = 1, count do
        if name == "Cards" then
            local front = pseudorandom_element(G.P_CARDS, pseudoseed('akyrs:maxwell'))
            local carder = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS['c_base'], {playing_card = G.playing_card})
            area:emplace(carder)
            table.insert(G.playing_cards, carder)
        elseif area == G.deck then
            local front = pseudorandom_element(G.P_CARDS, pseudoseed('akyrs:maxwell'))
            local carder = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, front, pseudorandom_element(G.P_CENTER_POOLS.Enhanced,pseudoseed("maxwellrandom")), {playing_card = G.playing_card})
            area:emplace(carder)
            table.insert(G.playing_cards, carder)
        elseif name then
            --print(cardtype)
            --print(name)
            pcall(function()
                if area and AKYRS.has_room(area) then
                    
                    local carder = create_card(name, area, nil, nil, nil, nil, nil, 'akyrs:maxwell')
                    if carder then
                        area:emplace(carder)
                    end
                end
            end)
        end 
    end

end


AKYRS.suit_to_atlas = function (suit_key)
    if suit_key == "Hearts" then
        -- print("<3")
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = (G.SETTINGS.colourblind_option and 4 or 0), y = 0}
    end
    if suit_key == "Clubs" then
        -- print("|-8o")
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = (G.SETTINGS.colourblind_option and 5 or 1), y = 0}
    end
    if suit_key == "Diamonds" then
        -- print("<>")
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = (G.SETTINGS.colourblind_option and 6 or 2), y = 0}
    end
    if suit_key == "Spades" then
        -- print("|-C>")
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = (G.SETTINGS.colourblind_option and 7 or 3), y = 0}
    end
    return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = 8, y = 0}
end
AKYRS.rank_to_atlas = function (rank_key)
    
    if rank_key == "Jack" then
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = 9, y = 0}
    end
    if rank_key == "Queen" then
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = 10, y = 0}
    end
    if rank_key == "King" then
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = 11, y = 0}
    end
    if rank_key == "Ace" then
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = 0, y = 1}
    end
    --          nan check v                           
    if tonumber(rank_key) and (tonumber(rank_key) == tonumber(rank_key)) and tonumber(rank_key) >= 2 and tonumber(rank_key) <= 10 then
        return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = 11 - tonumber(rank_key), y = 1}
    end
    return G.ASSET_ATLAS['akyrs_rank_suit_cards'], { x = 10, y = 1}
end

AKYRS.blind_icons_pos = function (key)
    
    if key == "expert" then          return  { x = 0, y = 1} end
    if key == "master" then          return  { x = 1, y = 1} end
    if key == "ultima" then          return  { x = 2, y = 1} end
    if key == "remaster" then        return  { x = 3, y = 1} end
    if key == "lunatic" then         return  { x = 4, y = 1} end
    if key == "dx" then              return  { x = 0, y = 2} end
    if key == "no_reroll" then       return  { x = 0, y = 0} end
    if key == "no_disabling" then    return  { x = 1, y = 0} end
    if key == "no_face" then         return  { x = 2, y = 0} end
    if key == "forgotten_blind" then return  { x = 5, y = 1} end
    if key == "word_blind" then      return  { x = 6, y = 1} end
    if key == "puzzle_blind" then    return  { x = 7, y = 1} end
    if key == "postwin_blind" then   return  { x = 8, y = 1} end
    if key == "endless_blind" then   return  { x = 9, y = 1} end
    if key == "no_overriding" then   return  { x = 1, y = 2} end
    if key == "no_skipping" then     return  { x = 2, y = 2} end
    if AKYRS.other_mods_blind_icons_pos(key) then return AKYRS.other_mods_blind_icons_pos(key) end
    return {x = 9, y = 9}
end

local int_checks = {["0"] = true, ["1"] = true, ["2"] = true, ["3"] = true, ["4"] = true, ["5"] = true, ["6"] = true, ["7"] = true, ["8"] = true, ["9"] = true, }

function AKYRS.get_sprite_for_letter(card, letter) -- quote on quote, can actually be any length, returns G.ASSET_ATLAS[youatlas], pos
    if not letter then return end
    if aiko_alphabets_to_num_no_wild[string.lower(letter)] then
        local i = aiko_alphabets_to_num_no_wild[string.lower(letter)]
        if letter:upper() == letter then -- this is for uppercase
            return G.ASSET_ATLAS["akyrs_lettersStickers"], { x = (i - 1) % 10, y = math.floor((i - 1) / 10) }
        else
            return G.ASSET_ATLAS["akyrs_lettersStickers"], { x = (i - 1) % 10, y = 3 + math.floor((i - 1) / 10) } 
        end
    end
    if letter == "#" then
        return G.ASSET_ATLAS["akyrs_lettersStickers"], { x = 6, y = 2 }
    end
    if int_checks[letter] then
        local v = tonumber(letter)
        return G.ASSET_ATLAS["akyrs_lettersStickers"], { x = v, y = 6 }
    end
    if AKYRS.non_letter_symbols_reverse[letter] then
        local i = AKYRS.non_letter_symbols_reverse[letter]
        return G.ASSET_ATLAS["akyrs_lettersStickers"], { x = (i - 1) % 10, y = 7 + math.floor((i - 1) / 10) }
    end
end


AKYRS.add_blind_extra_info = function(blind,ability_text_table,extras)
    extras = extras or {}
    local icon_size = extras.icon_size or 0.5
    local fsz = extras.text_size or 0.5
    local dfctysz = extras.difficulty_text_size or 0.5
    local bsz = extras.border_size or 1
    local set_parent_child = extras.set_parent_child or false
    local cache = extras.cached_icons or false
    local full_ui = extras.full_ui or false
    local hide = extras.hide or {  }
    local row = extras.row or false
    local info_queue = extras.info_queue or {}
    local z = {}

    if blind and blind.debuff then
        if blind.debuff.akyrs_blind_difficulty and not hide.difficulty then
            local sprite = nil
            if cache then
                AKYRS.icon_sprites[blind.debuff.akyrs_blind_difficulty] = AKYRS.icon_sprites[blind.debuff.akyrs_blind_difficulty] or Sprite(0,0,1*icon_size,1*icon_size, G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"],AKYRS.blind_icons_pos(blind.debuff.akyrs_blind_difficulty))
                sprite = AKYRS.icon_sprites[blind.debuff.akyrs_blind_difficulty]
            else
                sprite = Sprite(0,0,1*icon_size,1*icon_size, G.ASSET_ATLAS["akyrs_aikoyoriMiscIcons"],AKYRS.blind_icons_pos(blind.debuff.akyrs_blind_difficulty))
            end
    
            local blind_txt_dmy = "dd_akyrs_"..blind.debuff.akyrs_blind_difficulty.."_blind"
            z[#z+1] = {
                n = full_ui and G.UIT.R or G.UIT.C, config = { r = 0.2, align = "cm", can_collide = true, hover = true ,detailed_tooltip = AKYRS.DescriptionDummies[blind_txt_dmy] },
                nodes = {
                    {n=G.UIT.O, config={object = sprite, scale = fsz}},
                }
            }
            if full_ui then
                AKYRS.full_ui_add(z[#z].nodes, blind_txt_dmy, dfctysz)
                info_queue[#info_queue+1] = AKYRS.DescriptionDummies[blind_txt_dmy]
            end
        end
        if blind.debuff.akyrs_cannot_be_disabled and not hide.disabled then
            AKYRS.generate_icon_blinds("no_disabling",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        if blind.debuff.akyrs_cannot_be_rerolled and not hide.reroll then
            AKYRS.generate_icon_blinds("no_reroll",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        if blind.debuff.akyrs_is_forgotten_blind and not hide.forgotten_blind then
            AKYRS.generate_icon_blinds("forgotten_blind",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        if blind.debuff.akyrs_is_word_blind and not hide.word_blind then
            AKYRS.generate_icon_blinds("word_blind",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        if blind.debuff.akyrs_is_puzzle_blind and not hide.puzzle_blind then
            AKYRS.generate_icon_blinds("puzzle_blind",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        if blind.debuff.akyrs_is_endless_blind and not hide.endless_blind then
            AKYRS.generate_icon_blinds("endless_blind",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        if blind.debuff.akyrs_is_postwin_blind and not hide.postwin_blind then
            AKYRS.generate_icon_blinds("postwin_blind",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        if blind.debuff.akyrs_cannot_be_overridden and not hide.no_overriding then
            AKYRS.generate_icon_blinds("no_overriding",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        if blind.debuff.akyrs_cannot_be_skipped and not hide.no_overriding then
            AKYRS.generate_icon_blinds("no_skipping",{table = z,cache = cache,icon_size = icon_size,full_ui = full_ui,font_size = fsz,text_size_for_full = dfctysz, info_queue = info_queue})
        end
        AKYRS.other_mods_blind_icons(blind,ability_text_table,extras)
    end
    if z and #z > 0 and blind and ability_text_table then
        local xd = {
            n = full_ui and G.UIT.R or G.UIT.R,
            config = { align = "cm", padding = 0.1, can_collide = true, hover = true},
            nodes = z
        }
        if set_parent_child then
            ability_text_table.UIBox:set_parent_child(xd, ability_text_table)
            --print("CHILD = "..#ability_text_table.children)
            ability_text_table.UIBox:recalculate()
        else
            ability_text_table[#ability_text_table+1] = xd
        end
    end
    if z then return z end
end

AKYRS.generate_icon_blinds = function(key, config)
    if not key then return end
    local z = config.table or {}
    local cache = config.cache or false
    local icon_size = config.icon_size or false
    local atlas = config.atlas or "akyrs_aikoyoriMiscIcons"
    local full_ui = config.full_ui or false
    local fsz = config.font_size or false
    local dfctysz = config.text_size_for_full or false
    local info_queue = config.info_queue or {}
    local sprite = nil
    if cache then
        AKYRS.icon_sprites[key] = AKYRS.icon_sprites[key] or Sprite(0,0,1*icon_size,1*icon_size, G.ASSET_ATLAS[atlas],AKYRS.blind_icons_pos(key))
        sprite = AKYRS.icon_sprites[key]
    else
        sprite = Sprite(0,0,1*icon_size,1*icon_size, G.ASSET_ATLAS[atlas],AKYRS.blind_icons_pos(key))
    end
    local keyed = "dd_akyrs_"..key
    z[#z+1] = {
        n = full_ui and G.UIT.R or G.UIT.C, config = { r = 0.2, align = full_ui and "lc" or "cm", can_collide = true, hover = true ,detailed_tooltip = AKYRS.DescriptionDummies[keyed] },
        nodes = {
            {n=G.UIT.O, config={object = sprite, scale = fsz}},
        }
    }
    if full_ui then
        AKYRS.full_ui_add(z[#z].nodes, "dd_akyrs_"..key, dfctysz)
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies[keyed]
    end
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
