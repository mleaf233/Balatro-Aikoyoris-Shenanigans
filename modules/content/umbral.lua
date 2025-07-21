SMODS.ConsumableType{
    key = "Umbral",
    primary_colour = HEX("ffd45b"),
    secondary_colour = HEX("925ac3"),
    collection_rows = { 7,6 },
    shop_rate = 4,
}

SMODS.UndiscoveredSprite{
    key = "Umbral",
    atlas = "umbra_undisc",
    pos = {x=0, y=0}
}

--[[
misc.dictionary.b_key_cards
misc.dictionary.k_key
misc.labels.key
descriptions.Other.undiscovered_key
]]
--[[

]]
--[[
-- does not work well with editions and is kinda hard to read so i scrapped it

local umbra_alt_col_spr = function (self, card, front)
    if not card.akyrs_almost_front then
        card.akyrs_almost_front = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS["akyrs_umbra_2"], self.pos)
        card.akyrs_almost_front.layered_parallax = nil
        card.akyrs_almost_front.states.hover = card.states.hover
        card.akyrs_almost_front.states.click = card.states.click
        card.akyrs_almost_front.states.drag = card.states.drag
        card.akyrs_almost_front.states.collide.can = false
        card.akyrs_almost_front:set_role({major = card, role_type = 'Glued', draw_major = card})
    end
end
local umbra_draw = function (self, card, layer)
    if card.config.center.discovered or self.bypass_discovery_center then
        card.akyrs_almost_front:draw_shader('akyrs_color_shift', nil, card.ARGS.send_to_shader)
    end
end

]]

SMODS.Consumable{
    set = "Umbral",
    key = "umbral_graduate",
    atlas = "umbra",
    pos = {x=0,y=0},
    loc_vars = function (self, info_queue, card)
        local disallow = not not (G.GAME.akyrs_last_umbral == self.key or not G.GAME.akyrs_last_umbral)
        local text = G.GAME.akyrs_last_umbral and localize{type = "name_text",key = G.GAME.akyrs_last_umbral, set = "Umbral"} or localize("ph_akyrs_unknown")
        if G.GAME.akyrs_last_umbral and not disallow then
            info_queue[#info_queue+1] = G.P_CENTERS[G.GAME.akyrs_last_umbral]
        end
        return {
            main_end = {
                { n = G.UIT.R, config = { padding = 0.1, colour = disallow and G.C.RED or G.C.GREEN, r = 0.1}, nodes = {
                    {
                        n = G.UIT.T, config = {scale = 0.3, text = text}
                    }
                }}
            }
        }
    end,
    can_use = function (self, card)
        return not (G.GAME.akyrs_last_umbral == self.key or not G.GAME.akyrs_last_umbral)
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local disallow = not not (G.GAME.akyrs_last_umbral == self.key or not G.GAME.akyrs_last_umbral)
        if not disallow then
            SMODS.add_card{key = G.GAME.akyrs_last_umbral}
        end
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_realist",
    atlas = "umbra",
    pos = {x=1,y=0},
    config = {
        max_highlighted = 1,
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_akyrs_insolate_card"]
        return {
            vars = {
                card.ability.max_highlighted
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        AKYRS.do_things_to_card(G.hand.highlighted,function (_card)
            _card:set_ability(G.P_CENTERS["m_akyrs_insolate_card"])
        end, {stay_flipped_delay = 1,stagger = 0.1, fifo = true})
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_tribal",
    atlas = "umbra",
    pos = {x=2,y=0},
    config = {
        min_highlighted = 0,
        max_highlighted = 99999,
    },
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local h = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        local pl = AKYRS.get_planet_for_hand(h)
        if pl then
            SMODS.add_card{key = pl}
        end
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_gambit",
    atlas = "umbra",
    pos = {x=3,y=0},
    config = {
        extras = 3,
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras
            }
        }
    end,
    can_use = function (self, card)
        return #G.hand.cards > 0
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        local cards = AKYRS.pseudorandom_elements(G.hand.cards,card.ability.extras,pseudoseed("akyrs_umbral_gambit_c"))
        local rank = pseudorandom_element({"King","Queen","Ace"},pseudoseed("akyrs_umbral_gambit_r"))
        AKYRS.do_things_to_card(cards,function (_card)
            _card = SMODS.change_base(_card,nil,rank)
        end, {stay_flipped_delay = 1,stagger = 0.5,finish_flipped_delay = 0.5, fifo = true})
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_kingpin",
    atlas = "umbra",
    pos = {x=4,y=0},
    can_use = function (self, card)
        return G.STATE == G.STATES.SELECTING_HAND or #G.hand.cards > 0
    end,
    config = {
        extra = 2,
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extra
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        AKYRS.simple_event_add(
            function ()
                for i = 1, card.ability.extra do
                    local c = SMODS.add_card{ area = G.hand, set = "Base", seal = SMODS.poll_seal({guaranteed = true,}), rank = "King" }
                    c.pinned = true
                    c:juice_up(0.3,0.3)
                end
                return true
            end
        )
    end
    
}
AKYRS.tea_cards = {"m_akyrs_thai_tea_card", "m_akyrs_matcha_card", "m_akyrs_earl_grey_tea_card", }
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_tea_time",
    atlas = "umbra",
    pos = {x=5,y=0},
    config = {
        max_highlighted = 1
    },
    loc_vars = function (self, info_queue, card)
        for _,k in ipairs(AKYRS.tea_cards) do
            info_queue[#info_queue+1] = G.P_CENTERS[k] 
        end
        return {
            vars = {
                card.ability.max_highlighted
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        AKYRS.do_things_to_card(G.hand.highlighted,function (_card)
            local ench = pseudorandom_element(AKYRS.tea_cards,pseudoseed("akyrs_umbral_tea_time"))
            _card:set_ability(G.P_CENTERS[ench])
        end, {stay_flipped_delay = 1,stagger = 0.5,finish_flipped_delay = 0.5, fifo = true})
    end
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_break_up",
    atlas = "umbra",
    config = {
        min_highlighted = 1,
        max_highlighted = 1
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.max_highlighted
            }
        }
    end,
    can_use = function (self, card)
        local has_no_rank, has_no_suit 
        for _, c in ipairs(G.hand.highlighted) do
            if SMODS.has_no_suit(c) then
                has_no_suit = true
            end
            if SMODS.has_no_rank(c) then
                has_no_rank = true
            end
        end
        return (#G.hand.highlighted <= card.ability.max_highlighted and #G.hand.highlighted >= card.ability.min_highlighted) and not (has_no_rank and has_no_suit)
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        for _, c in ipairs(G.hand.highlighted) do
            if not SMODS.has_no_suit(c) then
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local c2 = copy_card(c, nil, nil, G.playing_card)
                c2.ability.akyrs_special_card_type = "rank"
                table.insert(G.playing_cards,c2)
                c2:set_sprites(c2.config.center,c2.config.card)
                G.hand:emplace(c2)
            end
            if not SMODS.has_no_rank(c) then
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local c2 = copy_card(c, nil, nil, G.playing_card)
                c2.ability.akyrs_special_card_type = "suit"
                table.insert(G.playing_cards,c2)
                c2:set_sprites(c2.config.center,c2.config.card)
                G.hand:emplace(c2)
            end
            c:start_dissolve({ G.C.AKYRS_UMBRAL_P, G.C.AKYRS_UMBRAL_Y, }, 0.5   )
        end
        
    end,
    pos = {x=6,y=0},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_public_transport",
    atlas = "umbra",
    pos = {x=7,y=0},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_corruption",
    atlas = "umbra",
    pos = {x=8,y=0},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_fomo",
    atlas = "umbra",
    pos = {x=9,y=0},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_misfortune",
    atlas = "umbra",
    pos = {x=0,y=1},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_book_smart",
    atlas = "umbra",
    pos = {x=1,y=1},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_prisoner",
    atlas = "umbra",
    pos = {x=2,y=1},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_overgrowth",
    atlas = "umbra",
    pos = {x=3,y=1},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_intrusive_thoughts",
    atlas = "umbra",
    pos = {x=4,y=1},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_weeping_angel",
    atlas = "umbra",
    pos = {x=5,y=1},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_bunker",
    atlas = "umbra",
    pos = {x=6,y=1},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_rock",
    atlas = "umbra",
    pos = {x=7,y=1},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_crust",
    atlas = "umbra",
    pos = {x=8,y=1},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_mantle",
    atlas = "umbra",
    pos = {x=9,y=1},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_core",
    atlas = "umbra",
    pos = {x=0,y=2},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_atmosphere",
    atlas = "umbra",
    pos = {x=1,y=2},
}
SMODS.Consumable{
    set = "Umbral",
    key = "umbral_free_will",
    atlas = "umbra",
    pos = {x=2,y=2},
    soul_pos = {x=9,y=2, draw=function (card, scale_mod, rotate_mod)
        if card.children.floating_sprite then
            rotate_mod = -G.TIMERS.REAL * 0.731
            local sc = -0.25
            local xm = 0.2 * math.cos(G.TIMERS.REAL)
            local ym = 0.2 * math.sin(G.TIMERS.REAL)
            card.children.floating_sprite:draw_shader('dissolve', 0, nil,nil,card.children.center,sc, rotate_mod,xm,ym+0.2,nil, 0.6)
            card.children.floating_sprite:draw_shader('dissolve', nil, nil,nil,card.children.center,sc, rotate_mod,xm,ym,nil, 0.6)
        end
    end},
    hidden = true,
    soul_rate = 0.003,
    can_repeat_soul = true,
}