local BASE_MULT = 0
local BASE_CROWD_MULT = 2
local BASE_CROWD_AMOUNT = 0

SMODS.Joker {
    key = "crowded",
    unlocked = true,
    discovered = true,
    config = {
        mult = BASE_MULT,
        extra = {
            crowd_mult = BASE_CROWD_MULT,
            crowd_amount = BASE_CROWD_AMOUNT,
      }
    },
    rarity = 1,
    cost = 6,
    loc_txt = {
        name = "Crowded",
        text = {
            "Creates a Crowd card every hand played.",
            "Sell to remove all Crowd cards and draw from deck.",
            "{C:inactive}(Currently {C:mult}+#3#{C:inactive}){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bi_crowd
        return {
            vars = {card.ability.extra.crowd_mult, card.ability.extra.crowd_amount, card.ability.mult}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main == true then
            -- Create the Crowd card 
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.6,
                func = function()
                    local _card = copy_card(context.full_hand[1], nil)
                    _card:set_ability(G.P_CENTERS.m_bi_crowd, nil, true)
                    _card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.hand:emplace(_card)
                    card.ability.extra.crowd_amount = card.ability.extra.crowd_amount + 1
                    card.ability.extra.crowd_mult = card.ability.extra.crowd_mult + 1
                    card.ability.mult = card.ability.extra.crowd_mult * card.ability.extra.crowd_amount
                    _card:start_materialize()
                    return {
                        message = "+ Crowd!"
                    }
                end
            }))

            if card.ability.mult > 0 then
                return {
                    message = "+" .. card.ability.mult .. "!",
                    mult_mod = card.ability.mult
                }
            end

            return;
        end

        -- Remove crowd cards from hand if selling the joker
        if context.selling_self == true then
            for i = 1, #G.hand.cards do
                if (SMODS.has_enhancement(G.hand.cards[i], "m_bi_crowd")) then
                    G.hand.cards[i]:start_dissolve()
                    draw_card(G.deck, G.hand, 90, 'up', nil)
                end
            end
            return
        end

        if context.end_of_round and context.game_over == false then
            -- remove all crowd cards from deck
            for i = 1, #G.playing_cards do
                if (SMODS.has_enhancement(G.playing_cards[i], "m_bi_crowd")) then
                    G.playing_cards[i]:start_dissolve()
                end
            end

            card.ability.extra.crowd_amount = 0
            card.ability.extra.crowd_mult = 2
            card.ability.mult = card.ability.extra.crowd_mult * card.ability.extra.crowd_amount
            return
        end
    end,
}

