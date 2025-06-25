AKYRS = SMODS.current_mod

-- i love jonh debugpkus
assert(SMODS.current_mod.lovely, "Lovely patches were not loaded.\nMake sure your mod folder is not nested (there should be a bunch of files in the mod folder and not just another folder).")

assert(SMODS.load_file("./modules/pre.lua"))()
assert(SMODS.load_file("./modules/atlasses.lua"))()
assert(SMODS.load_file("./modules/colours.lua"))()
assert(SMODS.load_file("./modules/fonts.lua"))()
assert(SMODS.load_file("./func/numbers.lua"))()
assert(SMODS.load_file("./func/words/words.lua"))()
assert(SMODS.load_file("./func/word_utils.lua"))()

assert(SMODS.load_file("./modules/utils/misc.lua"))()
assert(SMODS.load_file("./modules/utils/utils_mod.lua"))()
assert(SMODS.load_file("./modules/utils/value_replacement.lua"))()
assert(SMODS.load_file("./modules/custom_minigames/solitaire_card_type.lua"))()
assert(SMODS.load_file("./modules/hooks/general.lua"))() -- misc hook
assert(SMODS.load_file("./modules/hooks/card.lua"))() -- misc hook
assert(SMODS.load_file("./modules/hooks/letter.lua"))() -- for letter & null cards mechanics
assert(SMODS.load_file("./modules/hooks/scoring.lua"))() -- pure scoring
assert(SMODS.load_file("./modules/hooks/debug.lua"))() -- debug
assert(SMODS.load_file("./modules/hooks/ui.lua"))() -- uir

assert(SMODS.load_file("./modules/sounds.lua"))()
assert(SMODS.load_file("./modules/desc.lua"))()
assert(SMODS.load_file("./modules/pseudocard.lua"))()

assert(SMODS.load_file("./modules/custom_minigames/solitaire.lua"))() -- solitaire boss
assert(SMODS.load_file("./modules/custom_minigames/solitaire_ui.lua"))()

assert(SMODS.load_file("./modules/api.lua"))()
assert(SMODS.load_file("./modules/draw_step.lua"))()
assert(SMODS.load_file("./modules/card_attrib.lua"))()
assert(SMODS.load_file("./modules/rarity.lua"))()
assert(SMODS.load_file("./modules/content/alphabet_cards.lua"))()
assert(SMODS.load_file("./modules/content/constellation.lua"))()
assert(SMODS.load_file("./modules/boosters.lua"))()
assert(SMODS.load_file("./modules/stickers.lua"))()
assert(SMODS.load_file("./modules/blinds.lua"))()
assert(SMODS.load_file("./modules/cards.lua"))()
assert(SMODS.load_file("./modules/enchantments.lua"))()
assert(SMODS.load_file("./modules/vouchers.lua"))()
assert(SMODS.load_file("./modules/edition.lua"))()
assert(SMODS.load_file("./modules/ui.lua"))()
assert(SMODS.load_file("./modules/trades.lua"))()
assert(SMODS.load_file("./modules/challenges_ui.lua"))()
assert(SMODS.load_file("./modules/content/jokers.lua"))()
assert(SMODS.load_file("./modules/content/letterjokers.lua"))()

assert(SMODS.load_file("./modules/challenges.lua"))()
assert(SMODS.load_file("./modules/pokerhands.lua"))()

assert(SMODS.load_file("./modules/compat/malverk.lua"))()
assert(SMODS.load_file("./modules/compat/cryptid.lua"))()
assert(SMODS.load_file("./modules/compat/sleeves.lua"))()
assert(SMODS.load_file("./modules/compat/talisman.lua"))()
assert(SMODS.load_file("./modules/compat/jokerdisplay.lua"))()
assert(SMODS.load_file("./modules/compat/cartomancer.lua"))()
assert(SMODS.load_file("./modules/compat/notjustyet.lua"))()
assert(SMODS.load_file("./modules/compat/togasstuff.lua"))()
assert(SMODS.load_file("./modules/compat/partner.lua"))()

