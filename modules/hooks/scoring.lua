-- this file focuses on PURE scoring/joker calculation hooks
function Card.aiko_trigger_external(card)
end

--[[
]]
local hookCalFx = SMODS.calculate_effect
AKYRS.repetable_fx_calc = function(effect, scored_card, from_edition, pre_jokers)
    local r = hookCalFx(effect, scored_card, from_edition, pre_jokers)
    if G.GAME.blind and mult and G.GAME.blind.debuff.akyrs_score_face_with_my_dec_mult and G.GAME.blind.debuff.dec_mult then
        if scored_card and scored_card:is_face(true) then
            G.E_MANAGER:add_event(Event({trigger = 'immediate', blocking = false, blockable = true, func = function () scored_card:juice_up(0.1); return true end}))
            r = SMODS.calculate_individual_effect(effect, scored_card, "xmult", G.GAME.blind.debuff.dec_mult, false, false)
            percent = (percent or 0) + (percent_delta or 0.08)
        end
    end
    return r
end
SMODS.calculate_effect = function(effect, scored_card, from_edition, pre_jokers)
    local r = AKYRS.repetable_fx_calc(effect, scored_card, from_edition, pre_jokers)
    local extratrigs = (scored_card and scored_card.ability and scored_card.ability.akyrs_card_extra_triggers) and scored_card.ability.akyrs_card_extra_triggers or 0
    extratrigs = extratrigs + (scored_card and scored_card.edition and scored_card.edition.akyrs_card_extra_triggers or 0)
    if extratrigs > 0 then
        for i = 1, extratrigs do
            --print("RE-actual-TRIGGERED")
            --[[
            G.E_MANAGER:add_event(Event(
            {trigger = 'before', 
            blocking = true, 
            blockable = true, 
            func = function () 
                scored_card:juice_up(0.1); 
                AKYRS.repetable_fx_calc(effect, scored_card, from_edition, pre_jokers)
                return true
            end}),'base')
            
            ]]
            scored_card:juice_up(0.1); 
            AKYRS.repetable_fx_calc(effect, scored_card, from_edition, pre_jokers)
        end
    end
    return r
end
--[[
local evalCardHook = eval_card
function eval_card(card,context)
    
    local r,s = evalCardHook(card,context)
    local extratrigs = card.ability and card.ability.akyrs_card_extra_triggers or 0
    extratrigs = extratrigs + (card.edition and card.edition.akyrs_card_extra_triggers or 0)
    if extratrigs > 0 then
        for i = 1, extratrigs do
            print("RE-actual-TRIGGERED")
            r,s = evalCardHook(card,context)
        end
    end
    return r,s
end
]]

--[[
local vanillaRanks = {"2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"}
local prevRankMap = {"Ace","2","3","4","5","6","7","8","9","10","Jack","Queen","King"}
AKYRS.RanksPrevSet = {}
for j, k in ipairs(vanillaRanks) do
    AKYRS.RanksPrevSet[k] = SMODS.Ranks[k].prev
    local rankIsAlreadyInThere = false
    for i, v in ipairs(AKYRS.RanksPrevSet[k]) do
        if prevRankMap[i] == v then
            rankIsAlreadyInThere = true
        end
    end
    if not rankIsAlreadyInThere then
        SMODS.Rank:take_ownership(k,{
            prev = {
                unpack(AKYRS.RanksPrevSet[k]),
                prevRankMap[j]
            }
        }, true)
    end
end
]]

local get_blind_amount_hook = get_blind_amount
function get_blind_amount(ante)
    local r = get_blind_amount_hook(ante)
    if G.GAME.akyrs_power_of_x_scaling then
        if Talisman then
            r = to_big(G.GAME.akyrs_power_of_x_scaling):pow(ante)*10
        else
            r = math.pow(G.GAME.akyrs_power_of_x_scaling,ante)*10
        end
    end
    if G.GAME.akyrs_random_scale then
        if Talisman then
            G.GAME.akyrs_blind_random = G.GAME.akyrs_blind_random or r*(pseudorandom(pseudoseed("akyrs_random_scale"),to_number(G.GAME.akyrs_random_scale.min),to_number(G.GAME.akyrs_random_scale.max)))
        else
            G.GAME.akyrs_blind_random = G.GAME.akyrs_blind_random or r*(pseudorandom(pseudoseed("akyrs_random_scale"),G.GAME.akyrs_random_scale.min*r,G.GAME.akyrs_random_scale.max*r))
        end
        r = G.GAME.akyrs_blind_random
    end
    
    return r
end

-- taking over high card so it doesn't do the thing
local highcard_func = SMODS.PokerHands['High Card'].evaluate
SMODS.PokerHand:take_ownership("High Card",{
    evaluate = function (parts, hand)
        if not G.GAME.akyrs_mathematics_enabled then
            return highcard_func(parts,hand)
        end
        return {}
    end
})