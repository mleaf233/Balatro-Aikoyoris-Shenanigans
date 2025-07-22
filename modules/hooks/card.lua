local caSave = CardArea.save
function CardArea:save(cardAreaTable)
    if G.GAME.akyrs_any_drag and cardAreaTable then
        cardAreaTable.akyrs_drag_to_target_save = self.states.collide.can
    end
    return caSave(self,cardAreaTable)
end
local caLoad = CardArea.load
function CardArea:load(cardAreaTable)
    
    if G.GAME.akyrs_any_drag and cardAreaTable then
        self.states.collide.can = cardAreaTable.akyrs_drag_to_target_save
    end
    return caLoad(self,cardAreaTable)
end
local v_scu = set_consumeable_usage
function set_consumeable_usage(card)
    

    return v_scu(card)
end


function Card:akyrs_flip_y()
    if self.facing == 'front' then 
        self.flipping = 'akyrs_f2b_y'
        self.facing='back'
        self.pinch.y = true
    elseif self.facing == 'back' then
        self.ability.wheel_flipped = nil
        self.flipping = 'akyrs_b2f_y'
        self.facing='front'
        self.pinch.y = true
    end
end
-- basically function get_front_spriteinfo(_front) returns pos n shit
AKYRS.sprite_info_override = function (_center,_front, card, orig_a, orig_p)
    --if not _center or not _front then return end
    --print(card.config.center_key,_front.suit,_front.value)
    _center = _center or card.config.center
    _front = _front or card.base
    if card and card.ability and card.ability.akyrs_special_card_type == "suit" then
        return AKYRS.suit_to_atlas(_front.suit)
    end
    if card and card.ability and card.ability.akyrs_special_card_type == "rank" then
        return AKYRS.rank_to_atlas(_front.value)
    end

    return orig_a, orig_p
end


AKYRS.should_playing_card_loc_hooks = function (_c, card)
    if not _c or not card then return false end
    --print(_c)
    return not not card.ability.akyrs_special_card_type
end

AKYRS.playing_card_loc_hooks = function (_c,full_UI_table,specific_vars,card)
    if card and card.ability and card.ability.akyrs_special_card_type == "rank" then
        localize{type = 'other', key = 'akyrs_playing_card_rank', set = 'Other', nodes = full_UI_table.name, vars = {localize(specific_vars.value, 'ranks'), localize(specific_vars.suit, 'suits_plural'), colours = {specific_vars.colour}}}
    end
    if card and card.ability and card.ability.akyrs_special_card_type == "suit" then
        localize{type = 'other', key = 'akyrs_playing_card_suit', set = 'Other', nodes = full_UI_table.name, vars = {localize(specific_vars.value, 'ranks'), localize(specific_vars.suit, 'suits_plural'), colours = {specific_vars.colour}}}
    end
end

AKYRS.should_score_chips = function (_c, card)
    --print(_c)
    if card.ability.akyrs_special_card_type == "suit" then
        return false
    end
    return true
end

AKYRS.mod_card_displays = function(_c,card,desc_nodes,specific_vars)
    if card and card.ability and card.ability.akyrs_special_card_type == "rank" then
        localize{type = 'other', key = 'akyrs_no_suit', nodes = desc_nodes}
    end
    if card and card.ability and card.ability.akyrs_special_card_type == "suit" then
        localize{type = 'other', key = 'akyrs_no_rank', nodes = desc_nodes}
    end
end


local cardSetSpriteHook = Card.set_sprites
function Card:set_sprites(_c,_f)
    local x = cardSetSpriteHook(self,_c,_f)
    
    if AKYRS.should_draw_letter(self) then
        local letter_to_render = self:get_letter_with_pretend()
        local _atlas, _pos = AKYRS.get_sprite_for_letter(self,letter_to_render)
        if _atlas and _pos then
            if self.akyrs_letter then self.akyrs_letter:remove() end
            self.akyrs_letter = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, _atlas, _pos)
            self.akyrs_letter.states.hover = self.states.hover
            self.akyrs_letter.states.click = self.states.click
            self.akyrs_letter.states.drag = self.states.drag
            self.akyrs_letter.states.collide.can = false
            self.akyrs_letter:set_role({major = self, role_type = 'Glued', draw_major = self})
        end
    end
    return x
end


local gen_voucher_key_hook = get_next_voucher_key
function get_next_voucher_key(tag)
    local x = gen_voucher_key_hook(tag)
    if x then
        G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers = G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers or {}
        G.GAME.akyrs_generated_but_not_redeemed_vouchers_check = G.GAME.akyrs_generated_but_not_redeemed_vouchers_check or {}
        G.GAME.akyrs_generated_but_not_redeemed_vouchers_check[x] = true
        table.insert(G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers,x)
        AKYRS.remove_dupes(G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers)
    end
    return x
end

local get_next_vouchers_hook = SMODS.get_next_vouchers
function SMODS.get_next_vouchers(vouchers)
    local v = get_next_vouchers_hook(vouchers)
    if v and #v > 0 then
        for _,x in ipairs(v) do
            G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers = G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers or {}
            G.GAME.akyrs_generated_but_not_redeemed_vouchers_check = G.GAME.akyrs_generated_but_not_redeemed_vouchers_check or {}
            G.GAME.akyrs_generated_but_not_redeemed_vouchers_check[x] = true
            table.insert(G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers,x)
        end
        AKYRS.remove_dupes(G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers)

    end
    return v
end

-- remove redeemed voucher from the pool of possible pool
local cardRedeem = Card.redeem
function Card:redeem()
    local x = {cardRedeem(self)}
    
    if self.ability.set == "Voucher" then
        G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers = G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers or {}
        G.GAME.akyrs_generated_but_not_redeemed_vouchers_check = G.GAME.akyrs_generated_but_not_redeemed_vouchers_check or {}

        G.GAME.akyrs_generated_but_not_redeemed_vouchers_check[self.config.center_key] = nil
        AKYRS.remove_value_from_table(G.GAME.akyrs_list_of_generated_but_not_redeemed_vouchers,self.config.center_key)

    end
    return unpack(x)
end

AKYRS.hand_display_mod = function(hand,text,disp_text,poker_hands)
    if not hand then return end
    local are_pure = true
    for _,c in ipairs(hand) do
        if not c.ability.akyrs_special_card_type then
            are_pure = false
            break
        end
    end
    if are_pure and #hand > 0 then
        G.GAME.akyrs_pure_hand_modifier = G.GAME.akyrs_pure_hand_modifier or { multiplier = 2, power = 1, level = 1, played = 0 }
        -- what the fuck balatro why is this tostring function essential to it working????
        local _ = tostring(rawget(G.GAME.hands[text], "mult") or 1)
        local _2 = tostring(rawget(G.GAME.hands[text], "chips") or 1)
        local pre_mult = rawget(G.GAME.hands[text], "mult") or 1
        local pre_chips = rawget(G.GAME.hands[text], "chips") or 1
        --print(rawget(G.GAME.hands[text], "mult"))
        local hm = G.GAME.akyrs_pure_hand_modifier
        local final_mult, final_chips
        if Talisman then
            hm.multiplier = to_big(hm.multiplier)
            hm.power = to_big(hm.power)
            pre_mult = to_big(pre_mult)
            pre_chips = to_big(pre_chips)
            -- i fucking hate this
            local _,_2 = tostring(pre_mult),tostring(pre_chips)
            final_mult = pre_mult * to_big(hm.multiplier):pow(hm.power)
            final_chips = pre_chips * to_big(hm.multiplier):pow(hm.power)
        else
            final_mult = pre_mult * hm.multiplier ^ hm.power
            final_chips = pre_chips * hm.multiplier ^ hm.power
        end
        local m_d = "+"..tostring(final_mult-pre_mult)..""
        local h_d = "+"..tostring(final_chips-pre_chips)..""
        local m = final_mult
        local h = final_chips
        local hand_name = localize{ type = "variable", key = "k_akyrs_pure", vars = {disp_text}}
        update_hand_text({immediate = true, nopulse = true, delay = 0}, {handname=hand_name, level=G.GAME.hands[text].level, mult = m_d, chips = h_d, StatusText = true})
        update_hand_text({immediate = nil, nopulse = true, delay = 0}, {handname=hand_name, level=G.GAME.hands[text].level .."×"..tostring(hm.level), mult = m, chips = h})
        
        return true
    end
end
AKYRS.base_cm_mod = function(hand,poker_info,b_chip,b_mult)
    if not hand then return end
    local are_pure = true
    for _,c in ipairs(hand) do
        if not c.ability.akyrs_special_card_type then
            are_pure = false
            break
        end
    end
    if are_pure and #hand > 0 then
        for _,c in ipairs(hand) do
            c:set_debuff(false)
        end
        G.GAME.akyrs_pure_unlocked = true
        G.GAME.akyrs_pure_hand_modifier = G.GAME.akyrs_pure_hand_modifier or { multiplier = 2, power = 1, level = 1, played = 0 }
        G.GAME.akyrs_pure_hand_modifier.played = (G.GAME.akyrs_pure_hand_modifier.played or 0) + 0.5
        -- what the fuck balatro why is this tostring function essential to it working????
        local _ = tostring(rawget(G.GAME.hands[text], "mult") or 1)
        local _2 = tostring(rawget(G.GAME.hands[text], "chips") or 1)
        local pre_mult = rawget(G.GAME.hands[text], "mult") or 1
        local pre_chips = rawget(G.GAME.hands[text], "chips") or 1
        --print(rawget(G.GAME.hands[text], "mult"))
        local hm = G.GAME.akyrs_pure_hand_modifier
        local final_mult, final_chips
        if Talisman then
            hm.multiplier = to_big(hm.multiplier)
            hm.power = to_big(hm.power)
            pre_mult = to_big(pre_mult)
            pre_chips = to_big(pre_chips)
            -- i fucking hate this
            local _,_2 = tostring(pre_mult),tostring(pre_chips)
            final_mult = pre_mult * to_big(hm.multiplier):pow(hm.power)
            final_chips = pre_chips * to_big(hm.multiplier):pow(hm.power)
        else
            final_mult = pre_mult * hm.multiplier ^ hm.power
            final_chips = pre_chips * hm.multiplier ^ hm.power
        end
        local hand_name = localize{ type = "variable", key = "k_akyrs_pure", vars = {poker_info[2]}}
        mult = mod_mult(final_mult)
        hand_chips = mod_chips(final_chips)
        update_hand_text({immediate = true, delay = 0 }, {handname=hand_name, chips = hand_chips, mult = mult})
        return true
    end
end