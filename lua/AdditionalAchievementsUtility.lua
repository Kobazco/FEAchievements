-- AdditionalAchievementsLua
-- Author: Troller0001
-- DateCreated: 11/11/2016 9:06:24 PM
--------------------------------------------------------------
print("AdditionalAchievementsUtility.lua was included into VFS by a file!");

--Opens the ModUserData of Additional Achievements
function OpenAAModUserData()
    --print("Mod user data opened up")
    local iModVersion = 1;
    local sModID = "TRL_Additional_Achievements";
    --global
    modUserData = Modding.OpenUserData(sModID, iModVersion);
end

--===========================================================================

--store the achievements in a lua table so we dont have to check the database each time (prevents lag!)
tAchievements = {}

--Initializes the Achievements Table
--Loops through the database and ModUserData and stores all achievements in the table.
function InitializeAchievementsTable()
    --Open the ModUserData
    OpenAAModUserData();
    --Loop through the Achievements-table
    for row in GameInfo.AdditionalAchievements() do
        --Check the ModUserData and copy the value from there
        tAchievements[row.Type] = modUserData.GetValue(row.Type);
        --if there is nothing to copy (I.e. nil), then we set tAchievements[row.Type] = 0. I.e. the Achievement is still locked
        if tAchievements[row.Type] == nil then
            tAchievements[row.Type] = 0;
            --print((row.Type).." was not yet unlocked");
        end
        --print((row.Type).." has been added to the Lua-table! (Unlocked: "..(tAchievements[row.Type])..")");
    end
end
InitializeAchievementsTable()


--Returns true if a given Achievement is unlocked, returns false otherwise
function IsAAUnlocked(iAchievement)
    if iAchievement ~= nil then
        if tAchievements[iAchievement] == 1 then
            return true;
        end
    else
        print("ERROR: iAchievement in IsAAUnlocked(iAchievement) cannot be nil!");
    end
    return false;
end

--==============================================================================================
--The following functions are related to synching the Achievement-tables between different mods

--[[
The LuaEvents below can be subscribed to (LuaEvent.whatever.Add(function name)) just
like GameEvents (E.g. GameEvents.PlayerDoTurn.Add(function name)).

No idea why you would want to do this, but it's there if you feel like it

Summary of the LuaEvents:
- LuaEvents.EventResetAllAA();                                    Fires whenever a mod resets all achievements
- LuaEvents.EventResetModAA(sModID);                                Fires whenever a mod resets all achievements from a specific mod
- LuaEvents.EventUnlockAA(iAchievement);                            Fires whenever a mod unlocks an achievement
- LuaEvents.EventLockAA(iAchievement);                            Fires whenever a mod locks an achievement
- LuaEvents.EventAchievementTableUpdated(tUpdatedTable);            Fires whenever any of the above happens.

See the code below for more specific details.
--]]

--resets all achievements. WARNING: This CANNOT be undone!
--use the lockachievement function to lock a specific achievement
function ResetAllAA()
    print("Resetting all achievements...");
    for iAchievement,bUnlocked in pairs(tAchievements) do
        if bUnlocked==1 then
            modUserData.SetValue(iAchievement,0);
            print((GameInfo.AdditionalAchievements[iAchievement].Type).." reset in the ModUserData");
        end
    end
    print("Every achievement has been reset!");

    --A mod has reset all achievements, so all other mods need to know this as well (to stay synced!)
    LuaEvents.EventResetAllAA();
    LuaEvents.EventAchievementTableUpdated(tAchievements);
end

--Executes whenever any mod resets all achievements
--Note to Modders: Never call this function; it's called automatically. (Never call ANY SyncSomething function)
function SyncResetAllAA()
    --print("Another mod is resetting all achievements...");
    for iAchievement,bUnlocked in pairs(tAchievements) do
        --only lock it if we had already unlocked it
        if bUnlocked==1 then
            tAchievements[iAchievement] = 0;
            print((GameInfo.AdditionalAchievements[iAchievement].Type).." reset");
        end
    end
    --print("A mod has reset all achievements!");
end
LuaEvents.EventResetAllAA.Add(SyncResetAllAA);


--Resets all achievements from a given modID.
--Note to Modders: You can use this function to debug if you add your own achievements, without interfering with your own achievement-data
--WARNING: This cannot be undone
function ResetModAA(sModID)
    print("Resetting all achievements from the mod with ID="..sModID.."...");
    for iAchievement,bUnlocked in pairs(tAchievements) do
        if bUnlocked==1 and GameInfo.AdditionalAchievements[iAchievement].ModID == sModID then
            modUserData.SetValue(iAchievement,0);
            print((GameInfo.AdditionalAchievements[iAchievement].Type).." reset in the ModUserData");
        end
    end
    print("Reset all achievements from the mod with ID="..sModID.."!");
 
    --A mod has reset all events from a specific mod, so all other mods need to know this as well (to stay synced!)
    LuaEvents.EventResetModAA(sModID);
    LuaEvents.EventAchievementTableUpdated(tAchievements);
end

--Fires whenever any mod resets all achievement from a specific mod
--Note to Modders: Never call this function; it's called automatically. (Never call ANY SyncSomething function)
function SyncResetModAA(sModID)
    --print("A mod is resetting all achievements from the mod with ID="..sModID.."...");
    for iAchievement,bUnlocked in pairs(tAchievements) do
        --only lock it if we had already unlocked it
        if bUnlocked==1 and GameInfo.AdditionalAchievements[iAchievement].ModID == sModID then
            tAchievements[iAchievement] = 0;
            print((GameInfo.AdditionalAchievements[iAchievement].Type).." reset");
        end
    end
    --print("A mod has reset all achievements from the mod with ID="..sModID.."!");
end
LuaEvents.EventResetModAA.Add(SyncResetModAA);

--Unlocks a given achievement
--returns false if error or already unlocked, returns true otherwise
function UnlockAA(iAchievement)
    if iAchievement then
        if GameInfo.AdditionalAchievements[iAchievement] == nil then
            print("ERROR: "..iAchievement.." does not exist within Achievements!");
            return false;
        else
            if not IsAAUnlocked(iAchievement) then
                print((GameInfo.AdditionalAchievements[iAchievement].Type).." has been unlocked!");
                modUserData.SetValue(iAchievement,1);
                LuaEvents.EventUnlockAA(iAchievement);
                LuaEvents.EventAchievementTableUpdated(tAchievements);
                return true;
            end
            print((GameInfo.AdditionalAchievements[iAchievement].Type).." was already unlocked!");
            return false;
        end
    end
    print("ERROR: iAchievement in UnlockAA( function(iAchievement)...) may not be nil!");
    return false;
end

--Fires whenever an achievement is unlocked TODO: multiplayer: LuaEvent fires for every player -> need ActivePlayer-check????
--Note to Modders: Never call this function; it's called automatically. (Never call ANY SyncSomething function)
function SyncUnlockAA(iAchievement)
    --print("A mod Unlocked "..iAchievement);
    tAchievements[iAchievement] = 1;
end
LuaEvents.EventUnlockAA.Add(SyncUnlockAA);


--Locks a given achievement;
--returns false if error or already locked, returns true otherwise
function LockAA(iAchievement)
    if iAchievement then
        if GameInfo.AdditionalAchievements[iAchievement] == nil then
            print("ERROR: "..iAchievement.." does not exist within Achievements!");
            return false
        else
            print((GameInfo.AdditionalAchievements[iAchievement].Type).." has been Locked!");
            modUserData.SetValue(iAchievement,0);
            LuaEvents.EventLockAA(iAchievement);
            LuaEvents.EventAchievementTableUpdated(tAchievements);
            return true
        end
    end
    print("ERROR: iAchievement in LockAA( function(iAchievement)...) may not be nil!");
    return false
end

--Fires whenever an achievement is locked
--Note to Modders: Never call this function; it's called automatically. (Never call ANY SyncSomething function)
function SyncLockAA(iAchievement)
    --print("A mod Locked "..iAchievement);
    tAchievements[iAchievement] = 0;
end
LuaEvents.EventLockAA.Add(SyncLockAA);