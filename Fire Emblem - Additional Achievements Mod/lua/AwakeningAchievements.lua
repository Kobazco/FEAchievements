-- AwakeningAchievements
-- Author: Kobe
-- DateCreated: 11/21/2018 4:46:55 PM
--------------------------------------------------------------
print("AwakeningAchievements.lua has been loaded!");

include("AdditionalAchievementsUtility");

local iShepherd = GameInfoTypes.UNIT_SHEPHERD;
local iRobinYlisse = GameInfoTypes.CIVILIZATION_ROBINYLISSE;
local iRobinFYlisse = GameInfoTypes.CIVILIZATION_ROBINFYLISSE;
local iChromYlisse = GameInfoTypes.CIVILIZATION_CHROM_YLISSE;
local iEmmYlisse = GameInfoTypes.CIVILIZATION_YLISSE;

--You dare Mock the Son of a Shepherd?

function checkShepherdTrain(iPlayer, _, iUnit)
    --if the achievement is not unlocked, and the active player is the player who trained the unit
    if not IsAAUnlocked('AA_FE_SON_OF_SHEPHERD') and iPlayer == Game.GetActivePlayer() then
        --we only need to check for the active player, which is the human player.
        local pPlayer = Players[iPlayer];
        local pUnit = pPlayer:GetUnitByID(iUnit);
        if pUnit:GetUnitType() == iShepherd then
            UnlockAA('AA_FE_SON_OF_SHEPHERD');
        end
    end
end

--Son of a Shepherd: Train a Shepherd Unique Unit.
if not IsAAUnlocked('AA_FE_SON_OF_SHEPHERD') then
    GameEvents.CityTrained.Add(checkShepherdTrain);
end