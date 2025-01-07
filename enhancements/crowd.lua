
SMODS.Enhancement {
    key = "crowd",
    loc_txt = {
        name = "Crowd",
        text = {
            "Gives {C:mult}+2{} Mult",
            "Gains {C:mult}+1{} Mult per Crowd card",
            "Cannot be Played or Discarded"
        }
    },
    discovered = true,
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    overrides_base_rank = true,
    in_pool = function(self)
        return false
    end,
    weight = 9
}