local all_sets = {}
for i,k in pairs(G.P_CENTER_POOLS) do
    all_sets[i] = true
end

SMODS.Sticker{
    key = "self_destructs",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 0, y = 0},
    rate = 0,
    badge_colour = G.C.RED,
    sets =  all_sets,
    calculate = function(self, card, context)
    end,
    apply = function(self, card, val)
        card.ability[self.key] = val
        card:set_cost()
    end
}

SMODS.Seal{
    key = "debuff",
    atlas = 'aikoyoriStickers',
    pos = {x = 1, y = 0},
    badge_colour = HEX('91777c'),
    sound = { sound = 'generic1', per = 1.2, vol = 0.4 },

    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.hand_drawn then
            card.debuff = true
        end
    end,

}


SMODS.Sticker{
    key = "sigma",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 3, y = 0},
    rate = 0,
    badge_colour = HEX("ee36ff"),
    sets =  all_sets,
    calculate = function(self, card, context)
    end,
    apply = function(self, card, val)
        card.ability[self.key] = val
        card.ability.akyrs_stay_sigma = true
        card:set_cost()
    end,
    
    draw = function (self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
        G.shared_stickers[self.key]:draw_shader('akyrs_texelated', nil, card.ARGS.send_to_shader, nil, card.children.center)
        G.shared_stickers[self.key]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
    end
}
