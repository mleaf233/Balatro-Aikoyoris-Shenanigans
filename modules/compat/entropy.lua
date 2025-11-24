if Entropy then
    local derivative_part_func = SMODS.PokerHandParts.entr_derivative_part.func
    SMODS.PokerHandPart:take_ownership("entr_derivative_part",{
        func = function (hand)
            if AKYRS.should_calculate_word() then
                local normal_calculate = false
                local s = AKYRS.word_hand_combine(hand, #hand)
                if #s == 0 then normal_calculate = true end
                local hand_return, word_data = AKYRS.word_hand_search(s, hand, #hand)
                if #hand_return == 0 then
                    normal_calculate = true
                end
                if normal_calculate then
                    return derivative_part_func(hand)
                else
                    return {}
                end
            end
            return derivative_part_func(hand)
        end
    } )
end