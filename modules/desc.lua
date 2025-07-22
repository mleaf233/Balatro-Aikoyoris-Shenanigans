AKYRS.DescriptionDummy{
    key = "maxwell_example",
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local cards = {}
        table.insert(cards, AKYRS.create_random_card("maxwellui") )
        table.insert(cards, AKYRS.create_random_card("maxwellui") )
        table.insert(cards, AKYRS.create_random_card("maxwellui") )
        table.insert(cards, AKYRS.create_random_card("maxwellui") )
        table.insert(cards, AKYRS.create_random_card("maxwellui") )
        table.insert(cards, AKYRS.create_random_card("maxwellui") )
        table.insert(cards, AKYRS.create_random_card("maxwellui") )
        table.insert(cards, AKYRS.create_random_card("maxwellui") )
        local letters = {'s','p','e','c','t','r','a','l'}
        for index, value in ipairs(cards) do
            value.ability.forced_letter_render = true
            value.is_null = true
            value:set_letters(letters[index])
        end
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if desc_nodes ~= full_UI_table.main then
            AKYRS.card_area_preview(G.akyrsCardsPrev, desc_nodes, {
                cards = cards,
                override = true,
                w = 2.4,
                h = 0.5,
                ml = 0,
                box_height = 2.5,
                alignment = "bm",
                scale = 0.5,
                func_delay = 0.1* AKYRS.get_speed_mult(AKYRS.current_hover_card),
                func_after = function(ca) 
                    if ca and ca.cards then
                        for i,k in ipairs(ca.cards) do
                            if not k.removed then
                                G.E_MANAGER:add_event(Event{
                                    trigger = "after",
                                    blockable = false,
                                    delay = (0.1*i) * AKYRS.get_speed_mult(AKYRS.current_hover_card),
                                    func = function ()
                                        k.highlighted = true
                                        return true
                                    end
                                },"akyrs_desc")
                            end
                        end

                        G.E_MANAGER:add_event(Event{
                            trigger = "after",
                            blockable = false,
                            blocking = false,
                            delay = (1+0.5) * AKYRS.get_speed_mult(AKYRS.current_hover_card),
                            func = function ()

                                if ca and ca.cards then            
                                    for i,k in ipairs(ca.cards) do
                                        k:start_dissolve({G.C.RED}, true, 0)
                                    end
                                    local cn = create_card("Spectral", ca, nil, nil, true, true, nil)
                                    cn.T.scale = 0.5
                                    ca:emplace(cn)
                                end
                                return true
                            end
                        },"akyrs_desc")
                    end
                end,
            })
        end

    end,
}

AKYRS.DescriptionDummy{
    key = "yona_yona_ex",
    generate_ui = function(self, info_queue, cardd, desc_nodes, specific_vars, full_UI_table)
        local cards = {}
        local card = AKYRS.create_random_card("yona")
        card:set_base(G.P_CARDS["S_4"], true)
        table.insert(cards,card)
        local card = AKYRS.create_random_card("yona")
        card:set_base(G.P_CARDS["C_7"], true)
        table.insert(cards,card)
        SMODS.Joker.super.generate_ui(self, info_queue, cardd, desc_nodes, specific_vars, full_UI_table)
        AKYRS.card_area_preview(G.yonacards,desc_nodes,{
            override = true,
            cards = cards,
            w = 1.2,
            h = 0.6,
            ml = 0,
            scale = 0.5,
            func_delay = 0.5,
            func_list = {
                function (ca) if ca and ca.cards then ca.cards[1]:juice_up() end end,
                function (ca) if ca and ca.cards then ca.cards[1]:juice_up() end end,
                function (ca) if ca and ca.cards then ca.cards[2]:juice_up() end end,
                function (ca) if ca and ca.cards then ca.cards[2]:juice_up() end end,
            }
        })
    end,
}

AKYRS.DescriptionDummy{
    key = "2fa_example",
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local cards = {}
        table.insert(cards, AKYRS.create_random_card("2faui") )
        table.insert(cards, AKYRS.create_random_card("2faui") )
        table.insert(cards, AKYRS.create_random_card("2faui") )
        table.insert(cards, AKYRS.create_random_card("2faui") )
        table.insert(cards, AKYRS.create_random_card("2faui") )
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if desc_nodes ~= full_UI_table.main then
            AKYRS.card_area_preview(G.akyrsCardsPrev2fa, desc_nodes, {
                cards = cards,
                override = true,
                w = 2.4,
                h = 0.5,
                ml = 0,
                box_height = 2.5,
                alignment = "bm",
                scale = 0.5,
                func_delay = 0,
                func_after = function(ca) 
                    if ca and ca.cards then
                        for i,k in ipairs(ca.cards) do
                            if not k.removed then
                                G.E_MANAGER:add_event(Event{
                                    trigger = "after",
                                    blockable = false,
                                    delay = (0.5 + 0.1*i) * AKYRS.get_speed_mult(AKYRS.current_hover_card),
                                    func = function ()
                                        k.highlighted = true
                                        G.E_MANAGER:add_event(Event{
                                            trigger = 'after',
                                            blocking = false,
                                            delay = 0.2*i,
                                            func = function ()
                                                if ca and ca.cards then
                                                    if ca.cards[i] then
                                                        ca.cards[i]:flip()
                                                    end
                                                end
                                                return true
                                            end
                                        },"akyrs_desc")
                                        return true
                                    end
                                },"akyrs_desc")
                            end
                        end

                        G.E_MANAGER:add_event(Event{
                            trigger = "after",
                            blockable = false,
                            blocking = false,
                            delay = 2.5 * AKYRS.get_speed_mult(AKYRS.current_hover_card),
                            func = function ()

                                if ca and ca.cards then            
                                    for i,k in ipairs(ca.cards) do
                                        local _rank = nil
                                        local _suit = nil
                                        while _rank == nil or _suit == nil do
                                            _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('akyrs2fadr'))
                                            _suit = pseudorandom_element(SMODS.Suits, pseudoseed('akyrs2fads'))
                                        end
                                        
                                        
                                        if ca.cards[i] then
                                            AKYRS.change_base_skip(ca.cards[i],_suit.key,_rank.key)
                                            ca.cards[i]:flip()
                                        end
                                    end
                                end
                                return true
                            end
                        },"akyrs_desc")
                    end
                end,
            })            
        end

    end,
}
AKYRS.DescriptionDummy{
    key = "credit_larantula",
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)

        AKYRS.embedded_ui_sprite("akyrs_larantula_l_credits",{x = 0, y = 0}, desc_nodes, {
            w = 800,
            h = 800,
            rounded = 0.5
        })
    end,
}

AKYRS.DescriptionDummy{
    key = "tldr_tldr",
}
AKYRS.DescriptionDummy{
    key = "expert_blind"
}
AKYRS.DescriptionDummy{
    key = "master_blind"
}
AKYRS.DescriptionDummy{
    key = "ultima_blind"
}
AKYRS.DescriptionDummy{
    key = "remaster_blind"
}
AKYRS.DescriptionDummy{
    key = "lunatic_blind"
}
AKYRS.DescriptionDummy{
    key = "dx_blind"
}

AKYRS.DescriptionDummy{
    key = "no_disabling"
}
AKYRS.DescriptionDummy{
    key = "no_reroll"
}
AKYRS.DescriptionDummy{
    key = "no_overriding"
}
AKYRS.DescriptionDummy{
    key = "no_skipping"
}
AKYRS.DescriptionDummy{
    key = "word_blind"
}
AKYRS.DescriptionDummy{
    key = "puzzle_blind"
}
AKYRS.DescriptionDummy{
    key = "forgotten_blind"
}
AKYRS.DescriptionDummy{
    key = "postwin_blind"
}
AKYRS.DescriptionDummy{
    key = "endless_blind"
}
AKYRS.DescriptionDummy{
    key = "kessoku_band",
}