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
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras,
            }
        }
    end,
}

SMODS.Consumable{
    key = "replicant_connection",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=1, y=0},
    config = {
        max_highlighted = 2,
        extras = 2,
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.max_highlighted,
                card.ability.extras,
            }
        }
    end,

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
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                (math.max(G.GAME.starting_params.play_limit,G.GAME.starting_params.play_limit) + card.ability.extras.add),
                card.ability.extras.disca,
            }
        }
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
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extras,
            }
        }
    end,
}

SMODS.Consumable{
    key = "replicant_smart_home",
    set = "Replicant",
    atlas = "replicant",
    pos = {x=5, y=0},
    config = {
        extras = 2,
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { key = "akyrs_crystalised", set = "Other" }
        return {
            vars = {
                card.ability.extras,
            }
        }
    end,
}

