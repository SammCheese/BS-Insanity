
SMODS.Enhancement {
    key = "crowd",
    loc_txt = {
        name = "Crowd",
        text = {
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