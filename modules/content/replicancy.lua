SMODS.ConsumableType{
    key = "Replicant",
    primary_colour = HEX("a30262"),
    secondary_colour = HEX("ff9a56"),
    collection_rows = { 5, 5 },
    shop_rate = 0,
    default = "c_akyrs_replicant_forecast"
}

SMODS.UndiscoveredSprite{
    key = "Replicant",
    atlas = "replicant_undisc",
    pos = {x=0, y=0}
}

SMODS.Consumable{
    key = "replicant_forecast",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=0, y=0},
    config = {
        extras = 2,
    },
    can_use = function (self, card)
        return true
    end,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras,
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        for i = 1, card.ability.extras do
            if not AKYRS.has_room(G.consumeables) then break end
            local _c = SMODS.add_card{set = "Replicant"}
            _c:juice_up(0.3,0.3)
        end
    end
}

SMODS.Consumable{
    key = "replicant_connection",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=1, y=0},
    config = {
        max_highlighted = 3,
        extras = 2,
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = { set = "Other", key = "akyrs_crystalised" }
        return {
            vars = {
                card.ability.max_highlighted,
                card.ability.extras,
            }
        }
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        for _, c in ipairs(G.hand.highlighted) do
            for i = 1, card.ability.extras do
                AKYRS.simple_event_add(function ()
                    local cnew = AKYRS.copy_p_card(c, nil, nil, nil, nil, G.hand)
                    local s = pseudorandom_element(SMODS.Suits, "akyrs_replicant_connection_suit")
                    local r = pseudorandom_element(SMODS.Ranks, "akyrs_replicant_connection_rank")
                    SMODS.change_base(cnew, s.key, r.key)
                    SMODS.Stickers.akyrs_crystalised:apply(cnew, true)
                    SMODS.calculate_context({ playing_card_added = true, cards = { cnew }})
                    return true
                end, 0)
            end
        end
    end

}

SMODS.Consumable{
    key = "replicant_steganography",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=2, y=0},
    config = {
        extras = 2,
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { key = "akyrs_concealed", set = "Other" }
        return {
            vars = {
                card.ability.extras,
            }
        }
    end,
    can_use = function (self, card)
        return true
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        if AKYRS.has_room(G.jokers) then
            
        end
        for i = 1, card.ability.extras do
            AKYRS.simple_event_add(function ()
                if AKYRS.has_room(G.jokers) then
                    local cnew = SMODS.add_card{ set = "Joker", rarity = 'Rare'}
                    SMODS.Stickers.akyrs_concealed:apply(cnew, true)
                end
                return true
            end, 0)
        end
    end
}

SMODS.Consumable{
    key = "replicant_database",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=3, y=0},
    config = {
        extras = {
            add = 1,
            disca = 1,
        },
    },
    select_card = 'consumeables',
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                (math.max(G.GAME.starting_params.play_limit,G.GAME.starting_params.play_limit) + card.ability.extras.add),
                card.ability.extras.disca,
            }
        }
    end,
    can_use = function (self, card)
        return G.GAME.blind.in_blind
    end,
    use = function (self, card, area, copier)
        local to_return = (math.max(G.GAME.starting_params.play_limit,G.GAME.starting_params.play_limit) + card.ability.extras.add)
        local cards = AKYRS.pseudorandom_elements(G.hand.cards,to_return,pseudoseed("akyrs_replicant_db_select"))
        table.sort(cards, AKYRS.hand_sort_function)
        for _,c in ipairs(cards) do
            draw_card(c.area, G.deck, 0, "down", nil, c)
        end
        AKYRS.simple_event_add(function ()
            ease_discard(card.ability.extras.disca)
            G.deck:shuffle("akyrs_shuffled_db_replicant")
            G.FUNCS.draw_from_deck_to_hand()
            return true
        end)
    end,
}

SMODS.Consumable{
    key = "replicant_short_form_content",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=4, y=0},
    config = {
        extras = -1,
    },
    select_card = 'consumeables',
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras,
            }
        }
    end,
    can_use = function (self, card)
        return G.STATE == G.STATES.BLIND_SELECT
    end,
    use = function (self, card, area, copier)
        AKYRS.juice_like_tarot(card)
        G.GAME.akyrs_sfc_used = card.ability.extras
        local blinds_candidate = AKYRS.filter_table(G.P_BLINDS, function (item)
            return item.boss and item.boss.showdown and (not item.in_pool or item:in_pool())
        end, false, true)
        local blind_to_go = pseudorandom_element(blinds_candidate, "akyrs_short_form_replicant")
        AKYRS.start_blind_arbitrarily(blind_to_go.key)
    end
}

SMODS.Consumable{
    key = "replicant_smart_home",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=5, y=0},
    config = {
        extras = 3,
        min_highlighted = 0,
        max_highlighted = 99999,
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { key = "akyrs_attention", set = "Other" }
        if not G.hand then return {
            vars = {
                "???", "???"
            }
        } end
        local h = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
        return {
            vars = {
                card.ability.extras,
                localize(h, "poker_hands") ~= "ERROR" and localize(h, "poker_hands") or "???", 
            }
        }
    end,
    can_use = function (self, card)
        return #G.hand.highlighted > 0 or AKYRS.is_mod_loaded("Cryptid")
    end,
    use = function (self, card, area, copier)
        AKYRS.simple_event_add(function ()
            if #G.hand.highlighted > 0 or AKYRS.is_mod_loaded("Cryptid") then
                table.sort(G.hand.highlighted or {},AKYRS.hand_sort_function_immute)
                AKYRS.juice_like_tarot(card)
                local h = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
                SMODS.smart_level_up_hand(card, h, false, card.ability.extras)
                AKYRS.do_things_to_card(G.hand.highlighted,
                    function (cx)
                        SMODS.Stickers.akyrs_attention:apply(cx, true)
                    end
                )
            end
            return true 
        end, 0)
    end
}

