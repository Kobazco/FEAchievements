CREATE TABLE AdditionalAchievements
	( ID INTEGER PRIMARY KEY AUTOINCREMENT,
	Type TEXT UNIQUE,
	Achievopedia TEXT DEFAULT NULL,
	Header TEXT DEFAULT NULL,
	IconAtlas TEXT DEFAULT 'CIV_COLOR_ATLAS',	
	PortraitIndex INTEGER DEFAULT 23,
	ModType TEXT REFERENCES AdditionalAchievements_Mods(TYPE) DEFAULT NULL,
	ModVersion INTEGER DEFAULT 0,
	
	Unlocked BOOLEAN DEFAULT 0,
	LockedIconAtlas TEXT DEFAULT 'CIV_COLOR_ATLAS',
	LockedPortraitIndex INTEGER DEFAULT 23,
	UnlockSound TEXT DEFAULT 'AS2D_INTERFACE_ANCIENT_RUINS',
	PopupDuration INTEGER DEFAULT -1,
	Hidden BOOLEAN DEFAULT 0,
	HiddenBorder BOOLEAN DEFAULT 0,

	RequiredCivWin TEXT DEFAULT NULL,
	RequiredCivLoss TEXT DEFAULT NULL,
	RequiredCivKill TEXT DEFAULT NULL);
/*
Basic Achievement Definition:
Required Columns:
	Type: AchievementType (similair to BuildingType, UnitType, etc.)
	Achievopedia: The description of the Achievement. E.g. Conquer Jerusalem
	Header: The Title of the Achievement. E.g. Deus Vult!
	IconAtlas: The Iconatlas of the achievement (similair to buildings, units, etc.)
	PortraitIndex: The portraitindex of the achievement (similair to buildigns, units, etc.)
	ModType: ModType of the mod that adds this achievement. E.g. MOD_JFDLC
	ModVersion: Version of the mod in which this achievement was added (as an integer). E.g. 5 (for version 5)

The following columns are optional:	
	Unlocked: whether this achievement is unlocked by default. (Defaults to 0, so simply omit this)
	LockedIconAtlas: The IconAtlas of the achievmeent-icon when it's still locked. (defaults to the Questionmark-Icon)
	LockedPortraitIndex:	 The portraitIndex of the achievement-icon when it's still locked.
	UnlockSound: The sound that plays when you unlock this achievement (defaults to the Ancient Ruins/Goody Hut Discovery sound)
	PopupDuration: Duration (in ms) of when this achievement is unlocked. Use -1 for an infinte duration. Use 0 to have the popup not display
	Hidden: Whether this Achievement will be hidden from the Achievopedia (dunno why you'd want this but the functionality is there). Defaults to 0 (false)
	HiddenBorder: If set to 1, this achievement's icon does not have the standard icon border.

The following columns are optional and can be used to add simple achievements to your modded civs easily:
(More complex achievements still require you to use Lua though. See ActualAchievements.lua for examples, as this file uses the same principle)
	RequiredCivWin: The achievement is auto-granted if THE PLAYER wins the game as this civ
	RequiredCivLoss: The achievement is auto-granted if THE PLAYER loses the game as this civ
	RequiredCivKill: The achievement is auto-granted if THE PLAYER eliminates this civ from the game. I.e. captures the civ's last city
*/

CREATE TABLE AdditionalAchievements_ModsRequired
	(AchievementType TEXT REFERENCES AdditionalAchievements(TYPE) DEFAULT NULL,
	ModType TEXT REFERENCES AdditionalAchievements_Mods(TYPE) DEFAULT NULL,
	ModMinVersion INTEGER DEFAULT 0,
	ModMaxVersion INTEGER DEFAULT 1000);
/*
Mods that need to be ENABLED in order for a given achievement to be unlocked. There can be multiple entries per achievement! I.e. it requires >1 mod
	Type: AchievementType. E.g. AA_SETTLE_CAPITAL
	ModType: Mod that this achievement requires to be enabled so that it can be unlocked. E.g. MOD_JFDLC
	ModMinVersion: Minimum version of the mod that is required (as an integer), if any
	ModMaxVersion: Maximum version of the mod that is required (as an integer), if any
			E.g. achievement works for JFDLC in v3 to v5 (inclusive), then use: ModMinVersion: 3, ModMaxVersion 5
			E.g. achievement works for JFDLC in v3 and onwards, then use: ModMinVersion: 3, omit ModMaxVersion (or use ModMaxVersion 1000)
			E.g. achievement works for JFDLC in v5 and before (but not after!), then use: omit ModMinVersion (or use ModMinVersion 0), ModMaxVersion 5
			E.g. achievement works for JFDLC in any version, then use: omit ModMinVersion and ModMaxVersion (or use ModMinVersion 0, ModMaxVersion 1000)
*/

--==========================================================================================================
--Tabs are here as of v2!
CREATE TABLE Achievopedia_Tabs
	(ID INTEGER PRIMARY KEY AUTOINCREMENT,
	Type TEXT UNIQUE NOT NULL DEFAULT NULL,
	Header TEXT DEFAULT NULL,
	Description TEXT DEFAULT NULL,
	AppearsBeforeAll BOOLEAN DEFAULT 0,
	AppearsAfterAll BOOLEAN DEFAULT 0,
	ContainsAllAchievements BOOLEAN DEFAULT 0,
	ContainsUntabbedAchievements BOOLEAN DEFAULT 0);
/*
Basic Tab Definition (they are ordered alphabetically, unless specified differently)
	Type: TabType
	Header: Title of the Tab
	Description: Descripion of the Tab (appears as a small discription at the top of the achievementslist)
	AppearsBeforeAll: Whether this tab appears before other tabs that do not have this column set (defaults to 0)
	AppearsAfterAll: Whether this tab appears after other tabs that do not have this column set (defaults to 0)
	ContainsAllAchievements: Whether this tab contains all achievements (defaults to 0). Omit this column
	ContainsUntabbedAchievements: Whether this tab contains the achievements that have no specified tab (defaults to 0). Omit this column
*/

CREATE TABLE AdditionalAchievements_Tabs
	(AchievementType TEXT REFERENCES AdditionalAchievements(TYPE),  TabType TEXT REFERENCES Achievopedia_Tabs(TYPE) );
/*
Tabs (other than a ContainsAllAchievements-tab) that the achievement appears in. A single achievement can appear in multiple tabs.
	AchievementType: AchievementType
	TabType: The TabType that the given achievement appears in
*/

--=============================================================================================================
--v3 update: Mods now have their own table to avoid repetition
CREATE TABLE AdditionalAchievements_Mods
	(
	ID INTEGER PRIMARY KEY AUTOINCREMENT,
	Type TEXT UNIQUE NOT NULL DEFAULT NULL,
	ModName TEXT DEFAULT NULL,
	ModID TEXT DEFAULT NULL,
	Authors TEXT DEFAULT NULL
	);

/* Basic 'Mod' definition:
Type: Unique identifier for a mod. Eg. MOD_AA
ModName: Name of the Mod. E.g. 'Additional Achievements'
ModID: self-explanatory. E.g. '432bc547-eb05-4189-9e46-232dbde8f09f'
Authors: Authors of the mod, separated by commas E.g. "Troller0001, Troller0002". Not yet used, but might be in future versions
*/

--=============================================================================================================
--Insert AA-mod, CP/VMC-DLL mod, and JFDLC:
INSERT INTO AdditionalAchievements_Mods
		(Type,			ModName,					ModID,						Authors)
VALUES	('MOD_AA',		'TXT_KEY_AA_TITLE',		'TXT_KEY_AA_MODID',			'TXT_KEY_AA_AUTHORS'),
		('MOD_VMCCP',	'TXT_KEY_VMCCP_TITLE',	'TXT_KEY_VMCCP_MODID',		'TXT_KEY_VMCCP_AUTHORS'),
		('MOD_JFDLC',	'TXT_KEY_JFDLC_TITLE',	'TXT_KEY_JFDLC_MODID',		'TXT_KEY_JFDLC_AUTHORS');

--Insert main Tabs + AA-tab
INSERT INTO Achievopedia_Tabs
		(Type,								Header,										Description,										AppearsBeforeAll,	ContainsAllAchievements,		AppearsAfterAll,		ContainsUntabbedAchievements)
VALUES	('TAB_TRL_ADDITIONAL_ACHIEVEMENTS',	'TXT_KEY_AA_TAB_ADDITIONAL_ACHIEVEMENTS',	'TXT_KEY_AA_TAB_ADDITIONAL_ACHIEVEMENTS_DESC',	0,					0,							0,					0),
		('TAB_TRL_LATEST_AA',				'TXT_KEY_AA_TAB_LATEST_ACHIEVEMENTS',		'TXT_KEY_AA_TAB_LATEST_ACHIEVEMENTS_DESC',		0,					0,							0,					0),
		('TAB_OTHER',						'TXT_KEY_AA_TAB_OTHER',						'TXT_KEY_AA_TAB_OTHER_DESC',						0,					0,							1,					1),
		('TAB_ALL',							'TXT_KEY_AA_TAB_ALL',						'TXT_KEY_AA_TAB_ALL_DESC',						1,					1,							0,					0);

--Insert the Achievements
INSERT INTO AdditionalAchievements
		(Type,							Achievopedia,								Header,										IconAtlas,									PortraitIndex,	ModType,		ModVersion)
VALUES	('AA_SETTLE_CAPITAL',			'TXT_KEY_AA_SETTLE_CAPITAL_TEXT',			'TXT_KEY_AA_SETTLE_CAPITAL_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	0,				'MOD_AA',	1),
		('AA_ZERO_CITY_GERMANY',			'TXT_KEY_AA_ZERO_CITY_GERMANY_TEXT',			'TXT_KEY_AA_ZERO_CITY_GERMANY_HEADER',		'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	1,				'MOD_AA',	1),
		('AA_HISTORICALLY_ACCURATE',		'TXT_KEY_AA_HISTORICALLY_ACCURATE_TEXT',		'TXT_KEY_AA_HISTORICALLY_ACCURATE_HEADER',	'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	2,				'MOD_AA',	1),
		--('AA_ASSYRIAN_DRAMA',			'TXT_KEY_AA_ASSYRIAN_DRAMA_TEXT',			'TXT_KEY_AA_ASSYRIAN_DRAMA_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	3,				'MOD_AA',	1),
		--('AA_NO_FREE_STUFF',			'TXT_KEY_AA_NO_FREE_STUFF_TEXT',				'TXT_KEY_AA_NO_FREE_STUFF_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	4,				'MOD_AA',	1),
		('AA_QUIT',						'TXT_KEY_AA_QUIT_TEXT',						'TXT_KEY_AA_QUIT_HEADER',					'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	5,				'MOD_AA',	1),
		--('AA_WHO_NEEDS_UA',			'TXT_KEY_AA_WHO_NEEDS_UA_TEXT',				'TXT_KEY_AA_WHO_NEEDS_UA_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	6,				'MOD_AA',	1),
		('AA_FEMINISM',					'TXT_KEY_AA_FEMINISM_TEXT',					'TXT_KEY_AA_FEMINISM_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	7,				'MOD_AA',	1),
		('AA_MENINISM',					'TXT_KEY_AA_MENINISM_TEXT',					'TXT_KEY_AA_MENINISM_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	8,				'MOD_AA',	1),
		('AA_WET_DREAM',					'TXT_KEY_AA_WET_DREAM_TEXT',					'TXT_KEY_AA_WET_DREAM_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	9,				'MOD_AA',	1),
		('AA_SETTLE_SPAIN',				'TXT_KEY_AA_SETTLE_SPAIN_TEXT',				'TXT_KEY_AA_SETTLE_SPAIN_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	10,				'MOD_AA',	1),
		--('AA_COPY_PASTA',				'TXT_KEY_AA_COPY_PASTA_TEXT',				'TXT_KEY_AA_COPY_PASTA_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	11,				'MOD_AA',	1),
		('AA_SPREAD_SECRET',				'TXT_KEY_AA_SPREAD_SECRET_TEXT',				'TXT_KEY_AA_SPREAD_SECRET_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	12,				'MOD_AA',	1),
		('AA_PACIFIST',					'TXT_KEY_AA_PACIFIST_TEXT',					'TXT_KEY_AA_PACIFIST_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	13,				'MOD_AA',	1),
		('AA_BUSH',						'TXT_KEY_AA_BUSH_TEXT',						'TXT_KEY_AA_BUSH_HEADER',					'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	14,				'MOD_AA',	1),
		('AA_STAND_TOGETHER',			'TXT_KEY_AA_STAND_TOGETHER_TEXT',			'TXT_KEY_AA_STAND_TOGETHER_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	15,				'MOD_AA',	1),
		('AA_CONSTITUTION_COMPLETED',	'TXT_KEY_AA_CONSTITUTION_COMPLETED_TEXT',	'TXT_KEY_AA_CONSTITUTION_COMPLETED_HEADER',	'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	16,				'MOD_AA',	1),
		('AA_GREENPEACE',				'TXT_KEY_AA_GREENPEACE_TEXT',				'TXT_KEY_AA_GREENPEACE_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	17,				'MOD_AA',	1),
		--('AA_SOLAR',					'TXT_KEY_AA_SOLAR_TEXT',						'TXT_KEY_AA_SOLAR_HEADER',					'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	18,				'MOD_AA',	1),
		('AA_HOLIEST_OF_ALL',			'TXT_KEY_AA_HOLIEST_OF_ALL_TEXT',			'TXT_KEY_AA_HOLIEST_OF_ALL_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	19,				'MOD_AA',	1),
		('AA_MASS_PRAYER',				'TXT_KEY_AA_MASS_PRAYER_TEXT',				'TXT_KEY_AA_MASS_PRAYER_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	20,				'MOD_AA',	1),
		--('AA_SEEMINGLY_HAPPY',			'TXT_KEY_AA_SEEMINGLY_HAPPY_TEXT',			'TXT_KEY_AA_SEEMINGLY_HAPPY_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	21,				'MOD_AA',	1),
		--('AA_HERESY',					'TXT_KEY_AA_HERESY_TEXT',					'TXT_KEY_AA_HERESY_HEADER',					'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	22,				'MOD_AA',	1),
		('AA_CANT_RAZE_THIS',			'TXT_KEY_AA_CANT_RAZE_THIS_TEXT',			'TXT_KEY_AA_CANT_RAZE_THIS_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	23,				'MOD_AA',	1),
		('AA_HELPING_HAND',				'TXT_KEY_AA_HELPING_HAND_TEXT',				'TXT_KEY_AA_HELPING_HAND_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	24,				'MOD_AA',	1),
		('AA_LIBERTE',					'TXT_KEY_AA_LIBERTE_TEXT',					'TXT_KEY_AA_LIBERTE_HEADER',					'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	25,				'MOD_AA',	1),
		('AA_DEUS_VULT',					'TXT_KEY_AA_DEUS_VULT_TEXT',					'TXT_KEY_AA_DEUS_VULT_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	26,				'MOD_AA',	1),
		('AA_SNAGGED',					'TXT_KEY_AA_SNAGGED_TEXT',					'TXT_KEY_AA_SNAGGED_HEADER',					'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	27,				'MOD_AA',	1),
		--v2
		('AA_NUKE_THE_WORLD',			'TXT_KEY_AA_NUKE_THE_WORLD_TEXT',			'TXT_KEY_AA_NUKE_THE_WORLD_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	28,				'MOD_AA',	2),
		('AA_NO_EXPECTATIONS',			'TXT_KEY_AA_NO_EXPECTATIONS_TEXT',			'TXT_KEY_AA_NO_EXPECTATIONS_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	29,				'MOD_AA',	2),
		('AA_ALL_YOUR_FRIENDS',			'TXT_KEY_AA_ALL_YOUR_FRIENDS_TEXT',			'TXT_KEY_AA_ALL_YOUR_FRIENDS_HEADER',		'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	30,				'MOD_AA',	2),
		('AA_EVIL_TWIN',					'TXT_KEY_AA_EVIL_TWIN_TEXT',					'TXT_KEY_AA_EVIL_TWIN_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	31,				'MOD_AA',	2),
		('AA_WORLD_WAR',					'TXT_KEY_AA_WORLD_WAR_TEXT',					'TXT_KEY_AA_WORLD_WAR_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	32,				'MOD_AA',	2),
		('AA_CS_BIGGER_THAN_YOU',		'TXT_KEY_AA_CS_BIGGER_THAN_YOU_TEXT',		'TXT_KEY_AA_CS_BIGGER_THAN_YOU_HEADER',		'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	33,				'MOD_AA',	2),
		('AA_CONQUER_ALL',				'TXT_KEY_AA_CONQUER_ALL_TEXT',				'TXT_KEY_AA_CONQUER_ALL_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	34,				'MOD_AA',	2),
		('AA_BIG_CS_ALLY',				'TXT_KEY_AA_BIG_CS_ALLY_TEXT',				'TXT_KEY_AA_BIG_CS_ALLY_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	35,				'MOD_AA',	2),
		('AA_LATE_TECH',					'TXT_KEY_AA_LATE_TECH_TEXT',					'TXT_KEY_AA_LATE_TECH_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	36,				'MOD_AA',	2),
		('AA_MEDIC',						'TXT_KEY_AA_MEDIC_TEXT',						'TXT_KEY_AA_MEDIC_HEADER',					'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	37,				'MOD_AA',	2),
		('AA_ONE_SMALL_STEP',			'TXT_KEY_AA_ONE_SMALL_STEP_TEXT',			'TXT_KEY_AA_ONE_SMALL_STEP_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	38,				'MOD_AA',	2),
		('AA_ANIME',						'TXT_KEY_AA_ANIME_TEXT',						'TXT_KEY_AA_ANIME_HEADER',					'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	39,				'MOD_AA',	2),
		('AA_LITTLE_FRIEND',				'TXT_KEY_AA_LITTLE_FRIEND_TEXT',				'TXT_KEY_AA_LITTLE_FRIEND_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS',	21,				'MOD_AA',	2),
		--v3:
		('AA_LUXURY_LIFE',				'TXT_KEY_AA_LUXURY_LIFE_TEXT',				'TXT_KEY_AA_LUXURY_LIFE_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS_2',	0,				'MOD_AA',	3),
		('AA_FALL_WEISS',				'TXT_KEY_AA_FALL_WEISS_TEXT',				'TXT_KEY_AA_FALL_WEISS_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS_2',	9,				'MOD_AA',	3),
		('AA_WORST_PIRATE',				'TXT_KEY_AA_WORST_PIRATE_TEXT',				'TXT_KEY_AA_WORST_PIRATE_HEADER',			'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS_2',	1,				'MOD_AA',	3),
		('AA_TRADE_AGREEMENT_ENGLAND',	'TXT_KEY_AA_TRADE_AGREEMENT_ENGLAND_TEXT',	'TXT_KEY_AA_TRADE_AGREEMENT_ENGLAND_HEADER',	'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS_2',	12,				'MOD_AA',	3),
		('AA_LACK_OF_CONFIDENCE',		'TXT_KEY_AA_LACK_OF_CONFIDENCE_TEXT',		'TXT_KEY_AA_LACK_OF_CONFIDENCE_HEADER',		'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS_2',	2,				'MOD_AA',	3),
		('AA_MAKE_UP_YOUR_MIND',			'TXT_KEY_AA_MAKE_UP_YOUR_MIND_TEXT',			'TXT_KEY_AA_MAKE_UP_YOUR_MIND_HEADER',		'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS_2',	3,				'MOD_AA',	3),
		('AA_NOT_AS_SCARY_AS_I_LOOK',	'TXT_KEY_AA_NOT_AS_SCARY_AS_I_LOOK_TEXT',	'TXT_KEY_AA_NOT_AS_SCARY_AS_I_LOOK_HEADER',	'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS_2',	4,				'MOD_AA',	3),
		('AA_HOLY_WAR',					'TXT_KEY_AA_HOLY_WAR_TEXT',					'TXT_KEY_AA_HOLY_WAR_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS_2',	5,				'MOD_AA',	3),
		--('AA_ALL_ROAD_LEAD_TO_ROME',		'TXT_KEY_AA_ALL_ROAD_LEAD_TO_ROME_TEXT',		'TXT_KEY_AA_ALL_ROAD_LEAD_TO_ROME_HEADER',	'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS_2',	10,				'MOD_AA',	3),
		('AA_FLYING_HUSSAR',				'TXT_KEY_AA_FLYING_HUSSAR_TEXT',				'TXT_KEY_AA_FLYING_HUSSAR_HEADER',			'EXPANSION2_UNIT_ATLAS',						20,				'MOD_AA',	3),
		('AA_NOT_ENOUGH_ALREADY',		'TXT_KEY_AA_NOT_ENOUGH_ALREADY_TEXT',		'TXT_KEY_AA_NOT_ENOUGH_ALREADY_HEADER',		'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS_2',	6,				'MOD_AA',	3),
		--('AA_ASSASSIN',					'TXT_KEY_AA_ASSASSIN_TEXT',					'TXT_KEY_AA_ASSASSIN_HEADER',				'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS_2',	11,				'MOD_AA',	3),
		('AA_CHRISYMAS_MIRACLE',			'TXT_KEY_AA_CHRISYMAS_MIRACLE_TEXT',			'TXT_KEY_AA_CHRISYMAS_MIRACLE_HEADER',		'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS_2',	7,				'MOD_AA',	3),
		('AA_STEALING_KANGAROOS',		'TXT_KEY_AA_STEALING_KANGAROOS_TEXT',		'TXT_KEY_AA_STEALING_KANGAROOS_HEADER',		'TRL_ADDITIONAL_ACHIEVEMENTS_ICON_ATLAS_2',	8,				'MOD_AA',	3);


------------------------------------------------------------------------------------------

--All Additional Achievements (from this mod) appear in a separate tab.
--All Achievements that do not have an associated tab (other than 'All') will be placed in the 'Other' tab
INSERT INTO AdditionalAchievements_Tabs
		(AchievementType,				TabType)
VALUES	('AA_SETTLE_CAPITAL',			'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_ZERO_CITY_GERMANY',			'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_HISTORICALLY_ACCURATE',		'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_QUIT',						'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_FEMINISM',					'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_MENINISM',					'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_WET_DREAM',					'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_SETTLE_SPAIN',				'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_SPREAD_SECRET',				'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_PACIFIST',					'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_BUSH',						'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_STAND_TOGETHER',			'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_CONSTITUTION_COMPLETED',	'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_GREENPEACE',				'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_HOLIEST_OF_ALL',			'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_MASS_PRAYER',				'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_CANT_RAZE_THIS',			'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_HELPING_HAND',				'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_LIBERTE',					'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_DEUS_VULT',					'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_SNAGGED',					'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		--v2 achievements;
		('AA_NUKE_THE_WORLD',			'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_NO_EXPECTATIONS',			'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_ALL_YOUR_FRIENDS',			'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_EVIL_TWIN',					'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_WORLD_WAR',					'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_CS_BIGGER_THAN_YOU',		'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_CONQUER_ALL',				'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_BIG_CS_ALLY',				'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_LATE_TECH',					'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_MEDIC',						'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_ONE_SMALL_STEP',			'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_ANIME',						'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_LITTLE_FRIEND',				'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		--v3 achievements;
		('AA_LUXURY_LIFE',				'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_FALL_WEISS',				'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_WORST_PIRATE',				'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_TRADE_AGREEMENT_ENGLAND',	'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_LACK_OF_CONFIDENCE',		'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_MAKE_UP_YOUR_MIND',			'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_NOT_AS_SCARY_AS_I_LOOK',	'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_HOLY_WAR',					'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_FLYING_HUSSAR',				'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_NOT_ENOUGH_ALREADY',		'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_CHRISYMAS_MIRACLE',			'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		('AA_STEALING_KANGAROOS',		'TAB_TRL_ADDITIONAL_ACHIEVEMENTS'),
		--the achievemetns added in the latest version of AA (v3 currently) also appear in another tab:
		('AA_LUXURY_LIFE',				'TAB_TRL_LATEST_AA'),
		('AA_FALL_WEISS',				'TAB_TRL_LATEST_AA'),
		('AA_WORST_PIRATE',				'TAB_TRL_LATEST_AA'),
		('AA_TRADE_AGREEMENT_ENGLAND',	'TAB_TRL_LATEST_AA'),
		('AA_LACK_OF_CONFIDENCE',		'TAB_TRL_LATEST_AA'),
		('AA_MAKE_UP_YOUR_MIND',			'TAB_TRL_LATEST_AA'),
		('AA_NOT_AS_SCARY_AS_I_LOOK',	'TAB_TRL_LATEST_AA'),
		('AA_HOLY_WAR',					'TAB_TRL_LATEST_AA'),
		('AA_FLYING_HUSSAR',				'TAB_TRL_LATEST_AA'),
		('AA_NOT_ENOUGH_ALREADY',		'TAB_TRL_LATEST_AA'),
		('AA_CHRISYMAS_MIRACLE',			'TAB_TRL_LATEST_AA'),
		('AA_STEALING_KANGAROOS',		'TAB_TRL_LATEST_AA');


--A Chrisymas Miracle requires JFDLC to play (which requires VMC/CP DLL). This information is used in the UI
INSERT INTO AdditionalAchievements_ModsRequired
		(AchievementType,				ModType)
VALUES	('AA_CHRISYMAS_MIRACLE',			'MOD_JFDLC'),
		('AA_CHRISYMAS_MIRACLE',			'MOD_VMCCP');
		--TODO: stealing kangaroos australia

----------------------------------------------------------------
--Achievements that need a hidden border so their icons don't look awful:	 
UPDATE AdditionalAchievements
SET HiddenBorder = 1
WHERE Type IN (	'AA_GREENPEACE',		'AA_CS_BIGGER_THAN_YOU',		'AA_BIG_CS_ALLY',
				'AA_ANIME',			'AA_CHRISYMAS_MIRACLE',		'AA_STEALING_KANGAROOS');



/*
INSERT INTO Achievopedia_Tabs
		(Type,				Header,					Description)
VALUES	('TAB_TRL_DUMMY_1',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_2',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_3',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_4',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_5',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_6',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_7',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_8',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_9',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_10',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_11',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_12',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_13',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_14',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_15',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_16',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_17',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_18',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_19',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC'),
		('TAB_TRL_DUMMY_20',	'TXT_KEY_AA_TAB_DUMMY',	'TXT_KEY_AA_TAB_DUMMY_DESC');

*/
		