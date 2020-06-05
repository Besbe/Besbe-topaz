-----------------------------------
-- Area: Lower Delkfutt's Tower
--  Mob: Goblin Gambler
-----------------------------------
require("scripts/globals/regimes")
-----------------------------------

function onMobDeath(mob, player, isKiller)
    tpz.regime.checkRegime(player, mob, 777, 2, tpz.regime.type.GROUNDS)
end
