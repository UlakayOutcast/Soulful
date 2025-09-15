
local SOULFUL_VERSION = "0.63"
local function COLOR_GREY(text) if text then return "|caa88aa88"..text.."|r";end;end;
local function COLOR_BLACK(text) if text then return "|c00000000"..text.."|r";end;end;
local function COLOR_WHITE(text) if text then return "|cffffffff"..text.."|r";end;end;
local function COLOR_RED(text) if text then return "|cffff222a"..text.."|r";end;end;
local function COLOR_ORANGE(text) if text then return "|cffff8000"..text.."|r";end;end;
local function COLOR_YELLOW(text) if text then return "|cffffff00"..text.."|r";end;end;
local function COLOR_GREEN(text) if text then return "|cff1fba1f"..text.."|r";end;end;
local function COLOR_HUNTER(text) if text then return "|cffabd473"..text.."|r";end;end;
local function COLOR_GREEN2(text) if text then return "|cff00ff00"..text.."|r";end;end;
local function COLOR_BLUE(text) if text then return "|cff0070de"..text.."|r";end;end;
local function COLOR_PINK(text) if text then return "|c00FF23CC"..text.."|r";end;end 
local function COLOR_TURQUOISE(text) if text then return "|cff00ff99"..text.."|r";end;end; --бирюзовый
local function COLOR_VIOLET(text) if text then return "|cffff00ff"..text.."|r";end;end; --фиолетовый
local function COLOR_DISABLED(text) if text then return "|cffaaaaaa"..text.."|r";end;end;
local function COLOR_DISABLED2(text) if text then return "|cff666666"..text.."|r";end;end;
local COLOR_TANK = COLOR_BLUE;
local COLOR_HEALER = COLOR_GREEN;
local COLOR_DAMAGE = COLOR_RED;
local function Yes_No(tog)
	if tog then return COLOR_GREEN2("On");else return COLOR_GREEN2("Off");end;
end;

local function Info_Print(msg,r,g,b,frame,id)
	if (not r) then r = 0.8; end; if (not g) then g = 0.4; end; if (not b) then b = 0.8; end;
	if ( DEFAULT_CHAT_FRAME ) then 	DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b, id);end;
end;

local function SCM(tex, arg, name) SendChatMessage(tex,arg,DEFAULT_CHAT_FRAME.editBox.languageID,name); end;

function Message_Counter()
	local count,ix=0;for ix=1,999 do if RECEIVED_MESSAGES[ix] then count=count+1;else return count;end;end;
end;
function Message_Read()
	local count,ix=0;for ix=1,999 do if RECEIVED_MESSAGES[ix] then Info_Print("AMSG:"..RECEIVED_MESSAGES[ix],0,0.4,0.8);count=count+1;else return count;end;end;
end;
function Message_Clear()
	local count,ix=0;for ix=1,999 do if RECEIVED_MESSAGES[ix] then RECEIVED_MESSAGES[ix]=nil;count=count+1;else return count;end;end;
end;

local Answer = {};
local ToTheName = {};
local Text = {};
local Action = {};
local Emote = {};
local FromTheName = {};
local MTimer = {};
local AventTimers = {};
local AuraHarmfulTimers = {};
local AFK,AFKOnTimer,AFKOffTimer=false,0,0;
local Oom=0;

function Soulful_OnLoad()
	-- this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	this:RegisterEvent("PLAYER_LEVEL_UP");
	this:RegisterEvent("CHAT_MSG_TEXT_EMOTE");
	this:RegisterEvent("COMBAT_TEXT_UPDATE");
	this:RegisterEvent("UNIT_COMBAT");
	this:RegisterEvent("CHAT_MSG_SAY");
	this:RegisterEvent("CHAT_MSG_PARTY");
	this:RegisterEvent("CHAT_MSG_WHISPER");
	this:RegisterEvent("UNIT_AURA");
	this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	
	if not SOULFUL_CONFIG then SOULFUL_CONFIG = {}; end;
	if not SOULFUL_CONFIG["reaction"] then SOULFUL_CONFIG["reaction"] = true; end;
	if not SOULFUL_CONFIG["action"] then SOULFUL_CONFIG["action"] = true; end;
	if not SOULFUL_CONFIG["action factor"] then SOULFUL_CONFIG["action factor"] = 1; end;
	if not SOULFUL_CONFIG["language"] then SOULFUL_CONFIG["language"] = "EN"; end;
	if not SOULFUL_CONFIG["language auto"] then SOULFUL_CONFIG["language auto"] = true; end;
	if not SOULFUL_CONFIG["debug"] then SOULFUL_CONFIG["debug"] = 0; end;
	
	
	if not SOULFUL_CONFIG["counter"] then SOULFUL_CONFIG["counter"] = false; end;
	if not SOULFUL_CONFIG["counter"] then SOULFUL_CONFIG["counter_name"] = false; end;
	
	if not SOULFUL_CONFIG["autonutor"] then SOULFUL_CONFIG["autonutor"] = true; end;
	if not SOULFUL_CONFIG["autonutor_rp"] then SOULFUL_CONFIG["autonutor_rp"] = false; end;
	if not SOULFUL_CONFIG["autonutor_info"] then SOULFUL_CONFIG["autonutor_info"] = 0; end;
	if not SOULFUL_CONFIG["autonutor_save"] then SOULFUL_CONFIG["autonutor_save"] = true; end;
	if not SOULFUL_CONFIG["calculator"] then SOULFUL_CONFIG["calculator"] = true; end;
	SOULFUL_CONFIG["roll"] = -1;
	if not RECEIVED_MESSAGES then RECEIVED_MESSAGES = {}; end;
	if not Count then Count=0;end;
	local ix=0;
	while(ix<200) do 
		Answer[ix]=nil;
		ToTheName[ix]=nil;
		Action[ix]=nil;
		Emote[ix]=nil;
		FromTheName[ix]=nil;
		MTimer[ix]=nil;
		AventTimers[ix]=0;
		ix=ix+1;
	end;
	
	SlashCmdList["SOULFUL"] = Soulful_CommandHandler;
	SLASH_SOULFUL1 = "/soulful";
	SLASH_SOULFUL2 = "/sf";
	
	Info_Print("Soulful ".. COLOR_GREEN2(SOULFUL_VERSION) .." loaded. /sf");
end;

function Soulful_Reset_cfg(cmd)
	SOULFUL_CONFIG = {};
	SOULFUL_CONFIG["reaction"] = true;
	SOULFUL_CONFIG["action"] = true;
	SOULFUL_CONFIG["action factor"] = 1;
	SOULFUL_CONFIG["language"] = "EN";
	SOULFUL_CONFIG["language auto"] = true;
	SOULFUL_CONFIG["debug"] = 0;
	SOULFUL_CONFIG["counter"] = false;
	SOULFUL_CONFIG["counter_name"] = false;
	SOULFUL_CONFIG["autonutor"] = true;
	SOULFUL_CONFIG["autonutor_rp"] = false;
	SOULFUL_CONFIG["autonutor_info"] = 0;
	SOULFUL_CONFIG["autonutor_save"] = true;
	SOULFUL_CONFIG["calculator"] = true;
	SOULFUL_CONFIG["roll"] = -1;
	RECEIVED_MESSAGES = {};
	Count=0;
	local ix=0;while(ix<200) do 
		Answer[ix]=nil;
		ToTheName[ix]=nil;
		Action[ix]=nil;
		Emote[ix]=nil;
		FromTheName[ix]=nil;
		MTimer[ix]=nil;
		AventTimers[ix]=0;
		ix=ix+1;
	end;
	Info_Print("Soulful settings reset.");
end;

function Soulful_CommandHandler(cmd)
    if cmd then 
		cmd=string.lower(cmd);
		if string.len(cmd)==0 then Soulful_Cmd_Info();end;
        if string.find(cmd,"help") then Soulful_Cmd_Help();end;
        if string.find(cmd,"reset") then Soulful_Reset_cfg();end;
		if string.find(cmd,"reaction") then 
			SOULFUL_CONFIG["reaction"] = not SOULFUL_CONFIG["reaction"];
			if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Реакция: "..Yes_No(SOULFUL_CONFIG["reaction"])); end;
			if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Reaction: "..Yes_No(SOULFUL_CONFIG["reaction"])); end;
		end;
		if string.find(cmd,"action") and not string.find(cmd,"reaction") then 
			cmd=string.gsub(cmd,"(action)(%s*)","");
			if tonumber(cmd)==nil then 
				SOULFUL_CONFIG["action"] = not SOULFUL_CONFIG["action"];
			else 
				SOULFUL_CONFIG["action factor"] = tonumber(cmd);
			end;
			if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Действие: "..Yes_No(SOULFUL_CONFIG["action"]).." | Factor: "..COLOR_GREEN2(SOULFUL_CONFIG["action factor"])); end;
			if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Action: "..Yes_No(SOULFUL_CONFIG["action"]).." | Factor: "..COLOR_GREEN2(SOULFUL_CONFIG["action factor"])); end;
		end;
		if string.find(cmd,"language") then 
			cmd=string.gsub(cmd,"(language)(%s*)","");
			if cmd == "ru" then SOULFUL_CONFIG["language"] = "RU"; end;
			if cmd == "en" then SOULFUL_CONFIG["language"] = "EN"; end;
			if cmd == "auto" then SOULFUL_CONFIG["language auto"] = not SOULFUL_CONFIG["language auto"]; end;
			if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Язык: "..COLOR_GREEN2(SOULFUL_CONFIG["language"])..",".." Авто язык: "..Yes_No(SOULFUL_CONFIG["language auto"])); end;
			if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Language: "..COLOR_GREEN2(SOULFUL_CONFIG["language"])..",".." Auto language: "..Yes_No(SOULFUL_CONFIG["language auto"])); end;
		end;
		if string.find(cmd,"debug") then 
			cmd=string.gsub(cmd,"(debug)(%s*)","");
			if tonumber(cmd) then 
				if tonumber(cmd)>0 then 
					SOULFUL_CONFIG["debug"]=tonumber(cmd);
				else 
					SOULFUL_CONFIG["debug"]=0;
				end;
			else 
				if SOULFUL_CONFIG["debug"] == 0 then SOULFUL_CONFIG["debug"]=1; else SOULFUL_CONFIG["debug"]=0; end;
			end;
			Info_Print("Debug: "..COLOR_GREEN(SOULFUL_CONFIG["debug"]));
		end;
		-- if string.sub(cmd, 1, 6) == "renew" then CastSpellByName("Renew"); end;
		
		if string.find(cmd,"autonutor") then 
		
			-- if string.find(string.gsub(cmd,"(autonutor)(%s+)",""),"%w")==nil then 
			if string.find(string.gsub(cmd,"(autonutor)(%s*)",""),"%w")==nil then 
				SOULFUL_CONFIG["autonutor"] = not SOULFUL_CONFIG["autonutor"];
				if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Автоответчик: "..Yes_No(SOULFUL_CONFIG["autonutor"])); end;
				if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Autonutor: "..Yes_No(SOULFUL_CONFIG["autonutor"])); end;
			else 
				if string.find(cmd,"help") then 
					if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Помощь: "); end;
					if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Help: "); end;
				end;
				local temp=tonumber(string.sub(cmd, string.len(cmd), string.len(cmd)));
				if temp then 
					if temp>=0 and temp<=2 then 
						-- SOULFUL_CONFIG["autonutor_info"] = tonumber(string.sub(string.len(cmd)+1));
						SOULFUL_CONFIG["autonutor_info"] = temp;
						if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Автоответчик инфо: "..COLOR_GREEN2(SOULFUL_CONFIG["autonutor_info"])); end;
						if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Autonutor info: "..COLOR_GREEN2(SOULFUL_CONFIG["autonutor_info"])); end;
					end;
				end;
				if string.find(cmd,"save") then 
					SOULFUL_CONFIG["autonutor_save"] = not SOULFUL_CONFIG["autonutor_save"];
					if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Автоответчик сохранение сообщений: "..Yes_No(SOULFUL_CONFIG["autonutor_save"])); end;
					if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Autonutor save messages: "..Yes_No(SOULFUL_CONFIG["autonutor_save"])); end;
				end;
				if string.find(cmd,"count") then 
					if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Автоответчик сообщения: "..COLOR_GREEN2(Message_Counter()).." сообщений."); end;
					if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Autonutor messages: "..COLOR_GREEN2(Message_Counter()).." messages."); end;
				end;
				if string.find(cmd,"read") then 
					if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Автоответчик сообщения: "..COLOR_GREEN2(Message_Read()).." сообщений."); end;
					if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Autonutor messages: "..COLOR_GREEN2(Message_Read()).." messages."); end;
				end;
				if string.find(cmd,"clear") then 
					if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Автоответчик сообщения: "..COLOR_GREEN2(Message_Clear()).." messages delete."); end;
					if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Autonutor messages: "..COLOR_GREEN2(Message_Clear()).." messages delete."); end;
				end;
				if string.find(cmd,"rp") then 
					SOULFUL_CONFIG["autonutor_rp"] = not SOULFUL_CONFIG["autonutor_rp"];
					if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Автоответчик РП: "..Yes_No(SOULFUL_CONFIG["autonutor_rp"])); end;
					if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Autonutor RP: "..Yes_No(SOULFUL_CONFIG["autonutor_rp"])); end;
				end;
			end;
		end;
		
		if string.find(cmd,"calc") then 
			SOULFUL_CONFIG["calculator"] = not SOULFUL_CONFIG["calculator"];
			if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Калькулятор: "..Yes_No(SOULFUL_CONFIG["calculator"])); end;
			if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Calculator: "..Yes_No(SOULFUL_CONFIG["calculator"])); end;
		end;
		if string.find(cmd,"roll") or string.find(cmd,"rnd") then
			local number=string.gsub(cmd,"[^%d]","");
			if tonumber(number) then 
				number=tonumber(number);
			else 
				number=30;
			end;
			SOULFUL_CONFIG["roll"]=number;
			if SOULFUL_CONFIG["language"] == "RU" then  SCM(COLOR_HUNTER("Запись бросков включена: ")..COLOR_GREEN2(SOULFUL_CONFIG["roll"])..COLOR_HUNTER(" секунд. ")..COLOR_HUNTER("Сделайте roll или rnd для участия."),"say");end;
			if SOULFUL_CONFIG["language"] == "EN" then  SCM(COLOR_HUNTER("Recording of rolls is on: ")..COLOR_GREEN2(SOULFUL_CONFIG["roll"])..COLOR_HUNTER(" seconds. ")..COLOR_HUNTER("Do a roll or rnd to participate."),"say");end;
			RollReset();
		end;
		
	else 
		Info_Print("no cmd");
    end;
end;

function Soulful_Cmd_Info()
	if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Soulful! v."..COLOR_GREEN2(SOULFUL_VERSION).." Параметры и их состояния"); end;
	if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Soulful! v."..COLOR_GREEN2(SOULFUL_VERSION).." Parameters and their states"); end;
	if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Реакция: "..Yes_No(SOULFUL_CONFIG["reaction"])); end;
	if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Reaction: "..Yes_No(SOULFUL_CONFIG["reaction"])); end;
	if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Действие: "..Yes_No(SOULFUL_CONFIG["action"]).." | Factor: "..COLOR_GREEN2(SOULFUL_CONFIG["action factor"])); end;
	if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Action: "..Yes_No(SOULFUL_CONFIG["action"]).." | Factor: "..COLOR_GREEN2(SOULFUL_CONFIG["action factor"])); end;
	if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Язык: "..COLOR_GREEN2(SOULFUL_CONFIG["language"]).." | Авто язык: "..Yes_No(SOULFUL_CONFIG["language auto"])); end;
	if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Language: "..COLOR_GREEN2(SOULFUL_CONFIG["language"]).." | Auto language: "..Yes_No(SOULFUL_CONFIG["language auto"])); end;
	
	if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Автоответчик:"..Yes_No(SOULFUL_CONFIG["autonutor"]).." | инфо:"..COLOR_GREEN2(SOULFUL_CONFIG["autonutor_info"]).." | сохранение сообщений:"..Yes_No(SOULFUL_CONFIG["autonutor_save"]).." | RP:"..Yes_No(SOULFUL_CONFIG["autonutor_rp"])); end;
	if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Autonutor:"..Yes_No(SOULFUL_CONFIG["autonutor"]).." | info:"..COLOR_GREEN2(SOULFUL_CONFIG["autonutor_info"]).." | save messages:"..Yes_No(SOULFUL_CONFIG["autonutor_save"]).." | RP:"..Yes_No(SOULFUL_CONFIG["autonutor_rp"])); end;
	
	if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Используй: /sf help - Для отображения команд."); end;
	if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Use: /sf help - To display commands."); end;
end;
function Soulful_Cmd_Help()
	if SOULFUL_CONFIG["language"] == "RU" then Info_Print("Используй:"); end;
	if SOULFUL_CONFIG["language"] == "RU" then Info_Print(" /sf help - чтобы увидеть это, /sf language RU или EN: переключает язык. /sf language auto: переключает автоматическое определение языка окружения."); end;
	if SOULFUL_CONFIG["language"] == "RU" then Info_Print(" /sf reaction - переключает ответ на эмоцию. /sf action - переключает высказывание или эмоцию в действие. /sf action число - устанавливает коэфицеент срабатывания."); end;
	if SOULFUL_CONFIG["language"] == "RU" then Info_Print(" /sf autonutor - включает/выключает Autonutor, /sf autonutor info [number] - переключает отображение информации о полученном сообщении Autonutor (0-выкл., 1-алерт, 2-сообщение). /sf autonutor RP"); end;
	if SOULFUL_CONFIG["language"] == "RU" then Info_Print(" /sf autonutor save - Переключает сохранение сообщений, /sf autonutor count - Количество записанных сообщений, /sf autonutor read - Чтение записанных сообщений, /sf autonutor clear - Удаление записанных сообщений."); end;
	if SOULFUL_CONFIG["language"] == "RU" then Info_Print(" /sf calc - Turn on or off the retaliatory calculator (1+1)."); end;
	if SOULFUL_CONFIG["language"] == "EN" then Info_Print("Use:"); end;
	if SOULFUL_CONFIG["language"] == "EN" then Info_Print(" /sf help - to see this, /sf language RU or EN: Switches the language. /sf language auto: Toggles the automatic detection of the environment language."); end;
	if SOULFUL_CONFIG["language"] == "EN" then Info_Print(" /sf reaction - turns it for a response to an emotion, /sf action - turns it for say or emotion in action. /sf action number - Sets the triggering factor."); end;
	if SOULFUL_CONFIG["language"] == "EN" then Info_Print(" /sf autonutor - switches on/off Autonutor, /sf autonutor info [number] - switches the display of information about the received Autonutor message (0-off, 1-alert, 2-message). /sf autonutor RP"); end;
	if SOULFUL_CONFIG["language"] == "EN" then Info_Print(" /sf autonutor save - switches the saving messages, /sf autonutor count - The number of recorded messages, /sf autonutor read - Read recorded messages, /sf autonutor clear - Delete recorded messages."); end;
	if SOULFUL_CONFIG["language"] == "EN" then Info_Print(" /sf calc - Turn on or off the retaliatory calculator (1+1)."); end;
end;

local function GotBuff(name,target) 
    if not target then target = "player" end;
	local tex,cnt;
	for ix = 1,32 do 
		tex,cnt = UnitBuff(target,ix);
		if not tex then return end;
		if strfind(tex,name) then return cnt end;
	end;
end;
local function GotDebuff(name,target) 
    if not target then target = "target" end;
    local tex,cnt 
    for ix = 1,32 do 
      tex,cnt = UnitDebuff(target,ix) 
      if not tex then return end;
      if strfind(tex,name) then return cnt end;
    end;
end;

local function ActSpell(spell,rank,sw) 
	local ix,spellName,spellRank=192;
	while(ix>0) do 
		if ix==0 then return nil;
		else 
			spellName,spellRank=GetSpellName(ix,"spell");
			if spellName==spell and (spellRank==rank or rank==nil) then 
				if sw==0 then return ix;end;
				if sw==1 then return GetSpellCooldown(ix,"spell");end;
				if sw==2 then return spellRank;end;
				if sw=="self" then 
					if rank then CastSpellByName(spell.."("..rank..")",1)
					else CastSpellByName(spell,1);end;
				end;
				if sw==nil then 
					if GetSpellCooldown(ix,"spell")==0 then CastSpell(ix,"spell");return ix;end;
				end;
			end;
			ix=ix-1;
		end;
	end;
end;
-- function BlastSurge() local ix=AventTimers[80];AventTimers[80]=0; return ix; end;


local Count,SecondsCounter,TimerM,EmotionDelayAnswerTimer,TextDelayAnswerTimer,ActDelayAnswerTimer=0,0,0,0,0,0; local RollTimer=0;
function Soulful_OnUpdate() 
	if GetTime() >= SecondsCounter then SecondsCounter=GetTime()+1;
		-- DEFAULT_CHAT_FRAME:AddMessage("Temp1 = "..Temp1)
		-- Temp1=0;
		while(Count) do 
			if Answer[Count] or Text[Count] or Action[Count] then break;
			else if Count<100 then Count=Count+1; else Count=0;break;end;
			end;
		end;
			-- if Count==100 then Count=0;end;
			-- while(not Answer[Count] and not Text[Count] and not Action[Count]) do Count=Count+1; else break;end;
		if Answer[Count] then 
			
			if Answer[Count]~="say" and Answer[Count]~="yell" and Answer[Count]~="emote" and Answer[Count]~="party"  
			and Answer[Count]~="afksay" and Answer[Count]~="afkyell" and Answer[Count]~="afkemote" and Answer[Count]~="afkwhisper" 
			and Answer[Count]~="cast" and Answer[Count]~="act" and Answer[Count]~="Call Pet" 
			and EmotionDelayAnswerTimer>=8 then EmotionDelayAnswerTimer=0;
				DoEmote(Answer[Count],ToTheName[Count]);
				Answer[Count]=nil;ToTheName[Count]=nil;
			else 
				EmotionDelayAnswerTimer=EmotionDelayAnswerTimer+math.random(2,6);
			end;
			
			if Text[Count] and TextDelayAnswerTimer>=8 then TextDelayAnswerTimer=0;
				if Answer[Count]=="say" and Text[Count] then SCM(Text[Count],"SAY");end;
				if Answer[Count]=="yell" and Text[Count] then SCM(Text[Count],"YELL");end;
				if Answer[Count]=="emote" and Text[Count] then SCM(Text[Count],"EMOTE");end;
				if Answer[Count]=="party" and Text[Count] then SCM(Text[Count],"PARTY");end;
				if Answer[Count]=="whisper" and Text[Count] then SCM(Text[Count],"WHISPER",ToTheName[Count]);end;
				if Answer[Count]=="afksay" and Text[Count] then SetCVar("AutoClearAFK",0); SCM(Text[Count],"SAY"); SetCVar("AutoClearAFK",1);end;
				if Answer[Count]=="afkyell" and Text[Count] then SetCVar("AutoClearAFK",0); SCM(Text[Count],"YELL"); SetCVar("AutoClearAFK",1);end;
				if Answer[Count]=="afkemote" and Text[Count] then SetCVar("AutoClearAFK",0); SCM(Text[Count],"EMOTE"); SetCVar("AutoClearAFK",1);end;
				if Answer[Count]=="afkwhisper" and Text[Count] then SetCVar("AutoClearAFK",0); SCM(Text[Count],"WHISPER",ToTheName[Count]); SetCVar("AutoClearAFK",1);end;
				Answer[Count]=nil;ToTheName[Count]=nil;Text[Count]=nil;
			else 
				TextDelayAnswerTimer=TextDelayAnswerTimer+math.random(2,4);
			end;
			
			if Action[Count] and ActDelayAnswerTimer>=1 then ActDelayAnswerTimer=0;
				if Answer[Count]=="act" then 
					-- if Answer[Count]=="Call Pet" and  UnitExists("pet") then DoEmote("pat","pet");end;
					-- if Action[Count] then ActSpell(ToTheName[Count], Action[Count]);end;
						
					if Action[Count]=="follow" then FollowByName(ToTheName[Count]);end;
					-- if Action[Count]=="wait" then FollowByName("0");end;
					
					-- if Action[Count]=="Renew" then 
						-- TargetByName(ToTheName[Count]);
						-- RunMacro("/script CastSpellByName('Renew')");
						-- ClearTarget();
				-- end;
				end;
				Answer[Count]=nil;ToTheName[Count]=nil;Action[Count]=nil;
			else 
				ActDelayAnswerTimer=ActDelayAnswerTimer+1;
			end;
			
		end;
		-- if Action[Count] then ActSpell(ToTheName[Count], Action[Count]);end;
		
		local ix=0;
		while (ix < 100) do 
			if MTimer[ix] then 
				if MTimer[ix] > 0 then 
					-- MTimer[ix]=MTimer[ix]-1;
					MTimer[ix]=MTimer[ix]-math.random(1,2);
				else 
					Emote[ix]=nil;FromTheName[ix]=nil;
					Answer[Count]=nil;ToTheName[Count]=nil;
					Text[Count]=nil;Action[Count]=nil;
					MTimer[ix]=nil;
				end;
			end;
			ix=ix+1;
		end;
		
		
		-- Timer=tonumber(string.format("%.0f",GetTime()));
		-- DEFAULT_CHAT_FRAME:AddMessage("SecondsCounter = "..Timer2)
		-- System --
		if AFKOnTimer>0 then AFKOnTimer=AFKOnTimer-1;end; if AFKOnTimer<0 then AFKOnTimer=0; end;
		if AFKOffTimer>0 then AFKOffTimer=AFKOffTimer-1;end; if AFKOffTimer<0 then AFKOffTimer=0; end;
		-- AventTimers --
		local ix=0;
		while(ix<200) do 
			if AventTimers[ix]<0 then AventTimers[ix]=0; end;
			if AventTimers[ix]>0 then AventTimers[ix]=AventTimers[ix]-1;end;
			ix=ix+1;
		end;
		
		--Oom
		if SOULFUL_CONFIG["action"] then 
			if not GotBuff("Ability_Rogue_FeignDeath","player") 
			and UnitClass("player")~="Warrior" and UnitClass("player")~="Rogue" and UnitCreatureType("player")~="Beast" 
			then 
				if Oom==2 and UnitMana("player") > UnitManaMax("player")*0.35 then Oom=0; end;
				if UnitExists("party1") then 
					if Oom==0 then 
						if UnitClass("player")=="Mage" then 
							if UnitMana("player") < UnitManaMax("player")*0.01 then Oom=1; end;
						else 
							if UnitMana("player") < UnitManaMax("player")*0.1 then Oom=1; end;
						end;
					end;
					if Oom==1 then Oom=2;
						-- local rnd=math.random(1,2);
						-- if rnd==1 then DoEmote("oom",0);end;
						-- if rnd==2 then 
							if SOULFUL_CONFIG["language"] =="RU" then SCM("У меня закончилась мана!","say");end;
							-- if SOULFUL_CONFIG["language"] =="RU" then SCM("У меня закончилась мана!","party");end;
							if SOULFUL_CONFIG["language"] =="EN" then SCM("I'm out of mana!","say");end;
							-- if SOULFUL_CONFIG["language"] =="EN" then SCM("I'm out of mana!","party");end;
						-- end;
					end;
				end;
			end;
		end;
		
		if SOULFUL_CONFIG["roll"]>0 then 
			SOULFUL_CONFIG["roll"]=SOULFUL_CONFIG["roll"]-1;
		else 
			if SOULFUL_CONFIG["roll"]==0 then SOULFUL_CONFIG["roll"]=-1; RollEnd(); end;
		end;
	end;
end;

function Up_Array(emo, nam, ans, tar, tex, act) 
	if emo and nam then --print("emo="..emo);print("nam="..nam.."|tar="..tar);
		local ix=0; local sw=1; local player=GetUnitName("player"); local temp=""; 
		if tar == GetUnitName("player") then 
			if UnitExists("target") then tar=GetUnitName("target");end;
		end; 
		if emo~=0 then 
			while (ix < 100) do 
				if Emote[ix] and FromTheName[ix] then 
					if strfind(Emote[ix],emo) and (nam == FromTheName[ix] or player == FromTheName[ix]) then 
						sw=0;break;
					end;
				end;
				ix=ix+1;
			end;
		end;
		if sw == 1 then 
			ix=0;
			while(ix<100) do 
				if Emote[ix] or FromTheName[ix] or Answer[ix] or ToTheName[ix] or Text[ix] or Action[ix] or MTimer[ix] then 
					ix=ix+1;
				else 
					Emote[ix]=emo;
					if emo~=0 and nam == player then 
					-- if nam == player then 
						FromTheName[ix]=tar;
					else 
						FromTheName[ix]=nam;
						Answer[ix]=ans;
						ToTheName[ix]=tar;
					end;
					Text[ix]=tex;
					Action[ix]=act;
					-- if not tex and not act then 
					if not act then 
						MTimer[ix]=60;
					end;
					break;
				end;
			end;
		end;
	end;
end;

function Soulful_OnEvent(event, arg1)
	local msg; local rnd=0; local ix=0; local temp; local chat=0; local sex=0; local tar=0; local db=0;
	
	if event == "CHAT_MSG_SYSTEM" then 
		
		if strfind(arg1,"You are now AFK: Away from Keyboard") or strfind(arg1,"You are now DND: Do not Disturb") then AFK=true; db=1;
			if AFKOnTimer==0 then 
				rnd=math.random(1,6);
				if rnd==1 then DoEmote("stare",0);end;
				if rnd==2 then DoEmote("talkq",0);end;
				if rnd==3 then DoEmote("bored",0);end;
				if rnd==4 then DoEmote("tired",0);end;
				if rnd==5 then DoEmote("sleep",0);end;
				if rnd==6 then DoEmote("brb",0);end;
			end;
			AFKOnTimer=AFKOnTimer+120;AFKOffTimer=AFKOffTimer+10;
		end;
		if strfind(arg1,"You are no longer AFK.") or strfind(arg1,"You are no longer marked DND") then AFK=false; db=1;
			if AFKOffTimer==0 then 
				rnd=math.random(1,4);
				if rnd==1 then DoEmote("yawn",0);end;
				if rnd==2 then DoEmote("blink",0);end;
				if rnd==3 then DoEmote("bounce",0);end;
				if rnd==4 then DoEmote("work",0);end;
			end;
			AFKOffTimer=AFKOffTimer+120;AFKOnTimer=AFKOnTimer+10;
		end;
		
		-- if strfind(arg1,"Quest accepted: ") then 
			-- rnd=math.random(1,5);
			-- if rnd==1 then DoEmote("stare",0);end;
			-- if rnd==2 then DoEmote("talkq",0);end;
		-- end;
		-- if strfind(arg1," completed.") then 
			-- rnd=math.random(1,5);
			-- if rnd==1 then DoEmote("stare",0);end;
			-- if rnd==2 then DoEmote("talkq",0);end;
		-- end;
		-- if strfind(arg1,"Discovered ") then 
			-- rnd=math.random(1,5);
			-- if rnd==1 then DoEmote("stare",0);end;
			-- if rnd==2 then DoEmote("talkq",0);end;
		-- end;
	end;
		
	
-- без цели = charge, openfire
-- /panic /паника
-- /ponder /думать
-- /scared /испуг
-- /shoo /кыш
-- /wink /подмигнуть
-- /wrath /возмездие
-- /bashful /застенчивость
-- /golfclap /равнодушно
-- /ponder /думать
-- /confused /смущение
-- /lavish /слава
-- /doom /кара
-- happy 
	
	-- arg1 = Message received
	-- arg2 = Author
	-- arg3 = Language (or nil if universal, like messages from GM) (always seems to be an empty string; argument may have been kicked because whispering in non-standard language doesn't seem to be possible [any more?])
	-- arg6 = status (like "DND" or "GM")
	-- arg7 = (number) message id (for reporting spam purposes?) (default: 0)
	-- arg8 = (number) unknown (default: 0)
	-- arg11 = Chat lineID used for reporting the chat message.
	-- arg12 = Sender GUID
	if (event == "CHAT_MSG_SAY" or event == "CHAT_MSG_PARTY") and SOULFUL_CONFIG["language auto"] == true then 
	
		if strfind(arg1,"а") or strfind(arg1,"б") or strfind(arg1,"в") or strfind(arg1,"г") or strfind(arg1,"д") or strfind(arg1,"е") or strfind(arg1,"ё") or strfind(arg1,"ж") or strfind(arg1,"з") or strfind(arg1,"и") or strfind(arg1,"к") 
		or strfind(arg1,"л") or strfind(arg1,"м") or strfind(arg1,"н") or strfind(arg1,"о") or strfind(arg1,"п") or strfind(arg1,"р") or strfind(arg1,"с") or strfind(arg1,"т") or strfind(arg1,"у") or strfind(arg1,"ф") or strfind(arg1,"х") 
		or strfind(arg1,"ц") or strfind(arg1,"ч") or strfind(arg1,"ш") or strfind(arg1,"щ") or strfind(arg1,"ъ") or strfind(arg1,"ы") or strfind(arg1,"ь")or strfind(arg1,"э")or strfind(arg1,"ю")or strfind(arg1,"я")
		then 
			SOULFUL_CONFIG["language"] = "RU"
		end;
		
		if strfind(arg1,"a") or strfind(arg1,"b") or strfind(arg1,"c") or strfind(arg1,"d") or strfind(arg1,"e") or strfind(arg1,"f") or strfind(arg1,"g") or strfind(arg1,"h") or strfind(arg1,"i") or strfind(arg1,"j") or strfind(arg1,"k") 
		or strfind(arg1,"l") or strfind(arg1,"m") or strfind(arg1,"n") or strfind(arg1,"o") or strfind(arg1,"p") or strfind(arg1,"q") or strfind(arg1,"r") or strfind(arg1,"s") or strfind(arg1,"t") or strfind(arg1,"u") or strfind(arg1,"v") 
		or strfind(arg1,"w") or strfind(arg1,"x") or strfind(arg1,"y") or strfind(arg1,"z") 
		then 
			SOULFUL_CONFIG["language"] = "EN"
		end;
		
	end;
	
	-- CHAT_MSG_TEXT_EMOTE
	-- arg1 = Message that was sent/received
	-- arg2 = Name of the player who sent the message
	-- arg11 = Chat lineID used for reporting the chat message.
	-- arg12 = Sender GUID
	if not AFK and event == "CHAT_MSG_TEXT_EMOTE" and SOULFUL_CONFIG["reaction"] then db=1;
		-- if arg2 == GetUnitName("player") then 
			-- if UnitExists("target") then tar=GetUnitName("target");else tar=arg2;end;
			-- Up_Array(arg1, arg2, nil, tar);
		-- end;
		-- Up_Array(эмоция, от кого, ответ, кому, эмо текст, действие) 
		if 1 then 
		if strfind(arg1," wave") and not strfind(arg1,"goodbye") and (strfind(arg1," you") or strfind(arg1,"You ")) then 
			Up_Array("wave", arg2, "wave", arg2); 
			-- Up_Array("greet", arg2, "", arg2);
		end;
		if strfind(arg1," greet") and ((strfind(arg1," you") or strfind(arg1,"You ")) or strfind(arg1,"everyone")) then 
			Up_Array("greet", arg2, "hello", arg2); 
			-- Up_Array("wave", arg2, "", arg2);
		end;
		-- if strfind(arg1," hails  you.") or strfind(arg1,"You hail") and not strfind(arg1," those around you.") then 
		if strfind(arg1," hail") and (strfind(arg1," you") or strfind(arg1,"You ")) then 
			Up_Array("hail", arg2, "hail", arg2);
		end;
		if strfind(arg1," hugs ") and (strfind(arg1," you.") or strfind(arg1,"You ")) or strfind(arg1," needs a hug!") then 
			Up_Array("hug", arg2, "hug", arg2);
		end;
		if strfind(arg1,"salutes") and (strfind(arg1," you.") or strfind(arg1,"You ")) then 
			Up_Array("salute", arg2, "salute", arg2);
		end;
		if strfind(arg1," goodbye") and ((strfind(arg1," you") or strfind(arg1,"You ")) or strfind(arg1,"everyone")) then 
			Up_Array("goodbye", arg2, "bye", arg2);
		end;
		if strfind(arg1," dance") then 
			if strfind(arg1," you") then 
				rnd=math.random(1,2);
				if rnd==1 then Up_Array("dance", arg2, "bashful", arg2);end;
				if rnd==2 then Up_Array("dance", arg2, "dance", arg2);end;
			else 
				if strfind(arg1,"bursts") then 
					rnd=math.random(1,2);
					if rnd==1 then Up_Array("dance", arg2, "applaud", arg2);end;
					if rnd==2 then Up_Array("dance", arg2, "smile", arg2);end;--look
				end;
			end;
		end;
		if strfind(arg1," thanks you.") then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("thanks", arg2, "welcome", arg2);end;
			if rnd==2 then Up_Array("thanks", arg2, "nod", arg2);end;
		end;
		if strfind(arg1," flirt") and (strfind(arg1," you") or strfind(arg1,"You ")) then 
			Up_Array("flirt", arg2, "bashful", arg2);
		end;
		if strfind(arg1," loves ") and (strfind(arg1," you") or strfind(arg1,"You ")) then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("love", arg2, "bashful", arg2);end;
			if rnd==1 then Up_Array("love", arg2, "confused", arg2);end;
			if rnd==2 then Up_Array("love", arg2, "love", 0);end;
		end;
		if strfind(arg1," bow ") and (strfind(arg1," you") or strfind(arg1,"You ")) then 
			Up_Array("bow", arg2, "bow", arg2);
		end;
		if strfind(arg1," flexes at you. Oooooh so strong!") or strfind(arg1,"You flex") then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("flex", arg2, "peer", arg2);end;
			if rnd==2 then Up_Array("flex", arg2, "flex", arg2);end;
		end;
		if strfind(arg1," kneel ") and (strfind(arg1," you") or strfind(arg1,"You ")) then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("", arg2, "", arg2);end;
			if rnd==2 then Up_Array("", arg2, "", arg2);end;
		end;
		if strfind(arg1," laugh") and (strfind(arg1," you") or strfind(arg1,"You ")) then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("laugh", arg2, "wink", arg2);end;
			if rnd==2 then Up_Array("laugh", arg2, "laugh", arg2);end;
		end;
		if strfind(arg1," point at you.") then --points over yonder.
			if rnd==1 then Up_Array("point", arg2, "peer", arg2);end;
		end;
		-- if strfind(arg1,"blows you a kiss.") or strfind(arg1,"You blow a kiss to ") then 
		if strfind(arg1," you a kiss.") or strfind(arg1,"You blow ") then 
			rnd=math.random(1,4);
			if rnd==1 then Up_Array("kiss", arg2, "blush", arg2);end;
			if rnd==2 then Up_Array("kiss", arg2, "bashful", arg2);end;
			if rnd==3 then Up_Array("kiss", arg2, "emote", arg2, "skillfully dodges an air kiss.");end;
			if rnd==4 then Up_Array("kiss", arg2, "kiss", arg2);end;
			
		end;
		if strfind(arg1," pats ") and (strfind(arg1," you") or strfind(arg1,"You ")) then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("pat", arg2, "confused", arg2);end;
			if rnd==2 then Up_Array("pat", arg2, "glad", arg2);end;
		end;
		if strfind(arg1," cry.") then 
			Up_Array("cry", arg2, "soothe", arg2);
		end;
		if strfind(arg1," cries on your shoulder") then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("cry", arg2, "comfort", arg2);end;
			if rnd==2 then Up_Array("cry", arg2, "calm", arg2);end;
		end;
		if strfind(arg1,"bite") then 
			if strfind(arg1," you") then 
				rnd=math.random(1,2);
				if rnd==1 then Up_Array("bite", arg2, "slap", arg2);end;
				if rnd==2 then Up_Array("bite", arg2, "bite", arg2);end;
			else Up_Array("bite", arg2, "puzzled", arg2);
			end;
		end;
		if strfind(arg1,"slap") then 
			if strfind(arg1," slaps you across the face") then 
				rnd=math.random(1,2);
				if rnd==1 then Up_Array("slap", arg2, "slap", arg2);end;
				if rnd==2 then Up_Array("slap", arg2, "slap", arg2);end;
			-- else Up_Array("bite", arg2, "puzzled", arg2);
			end;
		end;
		if strfind(arg1," begs") then 
			if strfind(arg1," you") then 
				rnd=math.random(1,2);
				if rnd==1 then Up_Array("beg", arg2, "peon", arg2);end;
				if rnd==2 then Up_Array("beg", arg2, "pity", arg2);end;
			else Up_Array("beg", arg2, "mock", arg2);
			end;
		end;
		if strfind(arg1," cheers at you") or strfind(arg1,"You cheer!") then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("cheer", arg2, "cheer", 0);end;
			if rnd==2 then Up_Array("cheer", arg2, "smile", arg2);end;
		end;
		if strfind(arg1," applauds") and (strfind(arg1," you") or strfind(arg1,"You ")) then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("applauds", arg2, "thanks", arg2);end;
			if rnd==2 then Up_Array("applauds", arg2, "curtsey", arg2);end;
		end;
		if strfind(arg1," congratulate") and (strfind(arg1," you") or strfind(arg1,"You ")) then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("congratulate", arg2, "thanks", arg2);end;
			if rnd==2 then Up_Array("congratulate", arg2, "curtsey", arg2);end;
		end;
		if strfind(arg1," joke") and not strfind(arg1,"to") then 
			rnd=math.random(1,4);
			if rnd==1 then Up_Array("joke", arg2, "smile", 0);end;
			if rnd==2 then Up_Array("joke", arg2, "giggle", 0);end;
			if rnd==3 then Up_Array("joke", arg2, "guffaw", 0);end;
			if rnd==4 then Up_Array("joke", arg2, "laugh", 0);end;
		end;
		if strfind(arg1," talk") and (strfind(arg1," you") or strfind(arg1,"You ")) then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("talk", arg2, "listen", arg2);end;
			if rnd==2 then Up_Array("talk", arg2, "talk", arg2);end;
		end;
		if strfind(arg1," meow") and (strfind(arg1," you") or strfind(arg1,"You ")) then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("puzzled", arg2, "puzzled", arg2);end;
			if rnd==2 then Up_Array("shoo", arg2, "shoo", arg2);end;
			if rnd==3 then Up_Array("pat", arg2, "pat", arg2);end;
		end;
		
		if strfind(arg1," flee") then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("flee", arg2, "panic", 0);end;
			if rnd==2 then Up_Array("flee", arg2, "scared", 0);end;
		end;
		if strfind(arg1," incoming") then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("incoming", arg2, "panic", 0);end;
			if rnd==2 then Up_Array("incoming", arg2, "scared", 0);end;
		end;
		if strfind(arg1," asks you to wait") then 
			-- rnd=math.random(1,2);
			-- if rnd==1 then Up_Array("incoming", arg2, "panic", 0);end;
			-- if rnd==2 then Up_Array("incoming", arg2, "scared", 0);end;
		end;
		
		if strfind(arg1," farts ") then 
			if strfind(arg1," you") then 
				rnd=math.random(1,2);
				if rnd==1 then Up_Array("fart", arg2, "insult", arg2);end;
				if rnd==2 then Up_Array("fart", arg2, "fart", arg2);end;
			else 
				rnd=math.random(1,2);
				if rnd==1 then Up_Array("fart", arg2, "smell", 0);end;
				if rnd==2 then Up_Array("fart", arg2, "frown", arg2);end;
			end;
		end;
		
		if strfind(arg1," spits ") then 
			if strfind(arg1," on you") then 
				rnd=math.random(1,2);
				if rnd==1 then Up_Array("spit", arg2, "insult", arg2);end;
				if rnd==2 then Up_Array("spit", arg2, "spit", arg2);end;
			else Up_Array("spit", arg2, "frown", arg2);
			end;
		end;
		if strfind(arg1," rude") then 
			if strfind(arg1," you") 
			then Up_Array("rude", arg2, "insult", arg2);
			else Up_Array("rude", arg2, "frown", arg2);
			end;
		end;
		if strfind(arg1,"picks his nose and shows it to") then 
			if strfind(arg1," you") 
			then Up_Array("picks his nose and shows it to", arg2, "insult", arg2);
			else Up_Array("picks his nose and shows it to", arg2, "frown", arg2);
			end;
		end;
		if strfind(arg1," Cluck, Cluck, Chicken!") then 
			if strfind(arg1," you") then 
				rnd=math.random(1,2);
				if rnd==1 then Up_Array("chicken", arg2, "insult", arg2);end;
				if rnd==2 then Up_Array("chicken", arg2, "chicken", arg2);end;
			else 
				rnd=math.random(1,2);
				if rnd==1 then Up_Array("chicken", arg2, "boggle", arg2);end;
				if rnd==2 then Up_Array("chicken", arg2, "chuckle", arg2);end;
			end;
		end;
		if strfind(arg1," licks ") and not strfind(arg1," licks her lips.") then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("lick", arg2, "chuckle", arg2);end;
			if rnd==2 then Up_Array("lick", arg2, "confused", arg2);end;
		end;
		if strfind(arg1," tickles you.  Hee hee!") then 
			Up_Array("tickle", arg2, "giggle", arg2);
		end;
		if strfind(arg1," orders you to open fire") and not strfind(arg1,"You ") then 
			Up_Array("openfire", arg2, "roar", 0);
		end;
		if strfind(arg1," nods at you") then 
			Up_Array("nod", arg2, "nod", arg2);
			-- DoEmote("nod",arg2);
		end;
		if strfind(arg1," yawn ") then 
			-- Up_Array("nod", arg2, "nod", arg2);
			if math.random(1,2)==1 then Up_Array("yawn", arg2, "yawn", arg2); end;
		end;
		
		if strfind(arg1," make some dramatic moves with his hands in air") then 
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("dramatic", arg2, "applaud", arg2);end;
			if rnd==2 then Up_Array("dramatic", arg2, "wonder", arg2);end;
		end;
		
		if strfind(arg1," tells you to attack ") then 
			arg1=string.gsub(arg1,arg2,"");arg1=string.gsub(arg1,"(tells you to attack)","");arg1=string.gsub(arg1,"[%s%.]","");
			rnd=math.random(1,2);
			if rnd==1 then Up_Array("attacktarget", arg2, "roar", arg1);end;
			if rnd==2 then Up_Array("attacktarget", arg2, "charge", arg2);end;
		end;
		
		end;
		
		-- lick
		
		--==--
		--==--
		
		-- if strfind(arg1," follow") and not strfind(arg1,"You ") then 
			-- Up_Array("follow", arg2, "nod", arg2, "", "follow");
		-- end;
		-- if strfind(arg1,"wait") and not strfind(arg1,"You ") then 
			-- Up_Array("wait", arg2, "nod", arg2, "", "wait");
		-- end;
		
		-- if strfind(arg1,"healing") then 
			-- Up_Array("healing", arg2, "nod", arg2, "", "heal");
		-- end;
		
	end;
	
	
	if event == "PLAYER_LEVEL_UP" then 
	-- Fired when a player levels up.
	-- arg1 - New player level. Note that UnitLevel("player") will most likely return an incorrect value when called in this event handler or shortly after, so use this value.
	-- arg2 - Hit points gained from leveling.
	-- arg3 - Mana points gained from leveling.
	-- arg4 - Talent points gained from leveling. Should always be 1 unless the player is between levels 1 to 9.
	-- arg5 - arg9 - Attribute score increases from leveling. Strength (5) / Agility (6) / Stamina (7) / Intellect (8) / Spirit (9).
		-- print("arg1-"..arg1.."|arg2-"..arg2.."|arg3-"..arg3.."|arg4-"..arg4.."|arg5-"..arg5.."|arg6-"..arg6.."|arg7-"..arg7.."|arg8-"..arg8.."|arg9-"..arg9)
		rnd=math.random(1,4);
		-- if rnd==0 then 
			-- if UnitSex("player")==2 then sex="стал";end; if UnitSex("player")==3 then sex="стала";end;
			-- local start, ending, strength, agility, stamina, intellect, spirit = "Я ", "но мой путь еще не окончен","","","","";
			-- if arg5>0 then strength="сильнее, ";end;
			-- if arg6>0 then agility="быстрее, ";end;
			-- if arg7>0 then stamina="выносливее, ";end;
			-- if arg8>0 then intellect="умнее, ";end;
			-- if arg9>0 then spirit="мудрее, ";end;
			-- Up_Array(arg1, arg2, "say", arg2, start..sex..strength..agility..stamina..intellect..spirit..ending);
		-- end;
		if rnd==1 then 
			Up_Array("LEVEL_UP", arg2, "emote", arg2, "learns more and more the verity and becomes wiser.") --"player" всё больше познаёт истину и становится мудрее.
		end;
		if rnd==2 then Up_Array("LEVEL_UP", arg2, "flex", 0)end;
		if rnd==3 then Up_Array("LEVEL_UP", arg2, "happy", 0)end;
		if rnd==4 then Up_Array("LEVEL_UP", arg2, "dance", 0)end;
		-- if arg5>0 then Up_Array("strength", GetUnitName("player"), "flex", 0)end;--roar lavish knuckles
		-- if arg6>0 then Up_Array("agility", GetUnitName("player"), "curtsey", 0)end;
		-- if arg7>0 then Up_Array("stamina", GetUnitName("player"), "growl", 0)end;
		-- if arg8>0 then Up_Array("intellect", GetUnitName("player"), "talkq", 0)end;
		-- if arg9>0 then Up_Array("spirit", GetUnitName("player"), "happy", 0)end;
	end;
	
	local factor=SOULFUL_CONFIG["action factor"];
	
	
	-- if event == "COMBAT_TEXT_UPDATE" and strfind(arg1,"AURA_START") and strfind(arg2,"Bloodrage") then local Bloodrage=1;end;
	-- if event == "COMBAT_TEXT_UPDATE" and strfind(arg1,"AURA_END") and strfind(arg2,"Bloodrage") then local Bloodrage=0;end;
	-- UNIT_COMBAT
	-- Fired when an npc or player participates in combat and takes damage
	-- arg1	-- the UnitID of the entity
	-- arg2	-- Action,Damage,etc (e.g. HEAL, DODGE, BLOCK, WOUND, MISS, PARRY, RESIST, ...)
	-- arg3	-- Critical/Glancing indicator (e.g. CRITICAL, CRUSHING, GLANCING)
	-- arg4	-- The numeric damage
	-- arg5	-- Damage type in numeric value (1 - physical; 2 - holy; 4 - fire; 8 - nature; 16 - frost; 32 - shadow; 64 - arcane)
	if not AFK and event == "UNIT_COMBAT" and SOULFUL_CONFIG["action"] then  
		-- Common -- 
		if (arg1=="player" and arg2=="WOUND") and not GotBuff("Spell_Fire_Incinerate") then 
			db=1;
			if math.random(1+(AventTimers[2]+AventTimers[1])/factor) <= 1 then 
				-- if tonumber(arg4) > math.random(UnitHealthMax("player")*0.015, UnitHealthMax("player")*0.033) and tonumber(arg4) <= UnitHealthMax("player")*0.033 then 
				if tonumber(arg4) > math.random(UnitHealthMax("player")*0.015, UnitHealthMax("player")*0.033) and tonumber(arg4) <= UnitHealthMax("player")*0.033 and arg3~="CRITICAL" then 
					rnd=math.random(1,2);
					if rnd==1 then 
						DoEmote("scratch",0);--/groan /стон 
					end;
					if rnd==2 then 
						if SOULFUL_CONFIG["language"] =="RU" then SCM("Просто царапина.");end;
						if SOULFUL_CONFIG["language"] =="EN" then SCM("Just a scratch.");end;
					end;
					AventTimers[2]=AventTimers[2]+120;AventTimers[1]=AventTimers[1]+5;
				end;
				if tonumber(arg4) > math.random(UnitHealthMax("player")*0.033, UnitHealthMax("player")*0.1) and tonumber(arg4) <= UnitHealthMax("player")*0.1 then 
					rnd=math.random(1,2);
					if rnd==1 then 
						DoEmote("frown",0);
					end;
					if rnd==2 then 
						if SOULFUL_CONFIG["language"] =="RU" then SCM("Ай..");end;
						if SOULFUL_CONFIG["language"] =="EN" then SCM("Ouch..");end;
					end;
					AventTimers[2]=AventTimers[2]+60;AventTimers[1]=AventTimers[1]+5;
				end;
				if tonumber(arg4) > math.random(UnitHealthMax("player")*0.1, UnitHealthMax("player")) then 
					rnd=math.random(1,2);
					if rnd==1 then
						DoEmote("groan",0);--/groan /стон 
						-- if SOULFUL_CONFIG["language"] =="RU" then SCM("стискивает зубы от того, что испытывает сильную боль.","emote");end;
						-- if SOULFUL_CONFIG["language"] =="EN" then SCM("clenches his teeth from what is experiencing severe pain.","emote");end;
					end;
					if rnd==2 then 
						if SOULFUL_CONFIG["language"] =="RU" then SCM("Ай.. больно.");end;
						if SOULFUL_CONFIG["language"] =="EN" then SCM("Ouch.. It hurts.");end;
					end;
					AventTimers[2]=AventTimers[2]+30;AventTimers[1]=AventTimers[1]+5;
				end;
			end;
			AventTimers[1]=AventTimers[1]+2;
			
			if UnitHealth("player")>0 and UnitHealth("player") <= UnitHealthMax("player")*0.25 and math.random(UnitHealth("player")) <= UnitHealthMax("player")*0.1 and math.random(1+(AventTimers[3]+AventTimers[1])/factor) <= 1 then --/bleed /кровотечение --/blood /кровь
				rnd=math.random(1,5);
				if rnd==1 then DoEmote("healme",0); end;
				if rnd==2 then DoEmote("helpme",0); end;
				if rnd==3 then 
					if UnitSex("player")==2 then sex="ранен";end; if UnitSex("player")==3 then sex="ранена";end;
					if SOULFUL_CONFIG["language"] =="RU" then SCM("Я "..sex..", мне нужна помощь!");end;
					if SOULFUL_CONFIG["language"] =="EN" then SCM("I'm wounded, I need help!");end;
				end;
				if rnd==4 then 
					if SOULFUL_CONFIG["language"] =="RU" then SCM("Помогите, убивают!");end;
					if SOULFUL_CONFIG["language"] =="EN" then SCM("Help, I'm being killed!");end;
				end;
				if rnd==5 then 
					if SOULFUL_CONFIG["language"] =="RU" then SCM("истекает кровью и, похоже, скоро умрет.","emote");end;
					if SOULFUL_CONFIG["language"] =="EN" then SCM("is bleeding and seems to be dying soon.","emote");end;
				end;
				AventTimers[3]=AventTimers[3]+30;AventTimers[1]=AventTimers[1]+5;
			end;
		end;
		
		--ABSORB
		if arg1=="player" and arg2=="WOUND" and (arg3=="ABSORB" or arg3=="SPELL_ABSORBED") and not GotBuff("Spell_Shadow_GatherShadows","player") and math.random(1+(4+AventTimers[4]+AventTimers[1])/factor) <= 1 then 
			db=1;
			rnd=math.random(1,2);
			if rnd==1 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("игнорирует урон.","emote");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("ignores damage.","emote");end;
			end;
			if rnd==2 then 
				if UnitSex("player")==2 then sex="неуязвим!";end; if UnitSex("player")==3 then sex="неуязвима!";end;
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Я "..sex);end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("I am invulnerable!");end;
			end;
			AventTimers[4]=AventTimers[4]+600;AventTimers[1]=AventTimers[1]+5;
		end;
		if arg1=="target" and (arg3=="ABSORB" or arg3=="SPELL_ABSORBED") and UnitIsEnemy("player","target")==true and not GotBuff("Spell_Shadow_GatherShadows","player") and math.random(1+(4+AventTimers[5]+AventTimers[1])/factor) <= 1 then 
			db=1;
			rnd=math.random(1,2);
			if rnd==1 then 
				DoEmote("threat");
			end;
			if rnd==2 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Я не могу пробиться через его защиту."..sex);end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("I can't get through his defenses.");end;
			end;
			AventTimers[5]=AventTimers[5]+600;AventTimers[1]=AventTimers[1]+5;
		end;
		
		--DODGE and MISS
		if arg1=="player" and arg2=="DODGE" and math.random(1+(4+AventTimers[6]+AventTimers[1])/factor) <= 1 then db=1;
			rnd=math.random(1,2);
			if rnd==1 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("уклоняется от удара.","emote");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("dodges the blow.","emote");end;
			end;
			if rnd==2 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Ты промахнулся, мазила!");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("You missed, muff!");end;
			end;
			AventTimers[6]=AventTimers[6]+30;AventTimers[1]=AventTimers[1]+5;
		end;
		if arg1=="player" and (arg2=="MISS" or arg2=="SPELL_MISS") and math.random(1+(4+AventTimers[7]+AventTimers[1])/factor) <= 1 then db=1;
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Ты промахнулся, мазила!");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("You missed, muff!");end;
			AventTimers[7]=AventTimers[7]+30;AventTimers[1]=AventTimers[1]+5;
		end;
		-- if arg1=="target" and arg2=="MISS" and math.random(1+(4+AventTimers[8]+AventTimers[1])/factor) <= 1 then --db=1;
			-- rnd=math.random(1,2);
			-- if rnd==1 then 
				-- DoEmote("mad"); --snarl
			-- end;
			-- if rnd==2 then 
				-- if UnitSex("player")==2 then sex="промахнулся.";end; if UnitSex("player")==3 then sex="промахнулась!!";end;
				-- if SOULFUL_CONFIG["language"] =="RU" then SCM("Проклятье, я "..sex);end;
				-- if SOULFUL_CONFIG["language"] =="EN" then SCM("Damn it, I missed.");end;
			-- end;
			-- AventTimers[8]=AventTimers[8]+30;AventTimers[1]=AventTimers[1]+5;
		-- end;
		
		if arg1=="player" and (arg2=="PARRY" or arg2=="BLOCK") and math.random(1+(4+AventTimers[9]+AventTimers[1])/factor) <= 1 then db=1;
			rnd=math.random(1,2);
			if rnd==1 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("отражает удар.","emote");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("deflects blow.","emote");end;
			end;
			if rnd==2 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Моя защита великолепна!");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("My defense is great!");end;
			end;
			AventTimers[9]=AventTimers[9]+30;AventTimers[1]=AventTimers[1]+5;
		end;
		
		--SPELL_RESISTED
		if arg1=="player" and (arg2=="RESIST" or arg2=="SPELL_RESISTED") and math.random(1+(4+AventTimers[10]+AventTimers[1])/factor) <= 1 then db=1;
			rnd=math.random(1,2);
			if rnd==1 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("сопротивляется магии.","emote");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("resists magic.","emote");end;
			end;
			if rnd==2 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Мое сопротивление идеально!");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("My resistance is perfect!");end;
			end;
			AventTimers[10]=AventTimers[10]+30;AventTimers[1]=AventTimers[1]+5;
		end;
		-- if arg1=="target" and arg2=="RESIST" and UnitIsEnemy("player","target")==true and math.random(1+(4+AventTimers[10]+AventTimers[1])/factor) <= 1 then db=1;
			-- rnd=math.random(1,2);
			-- if rnd==1 then 
				-- DoEmote("frown");
			-- end;
			-- if rnd==2 then 
				-- if SOULFUL_CONFIG["language"] =="RU" then SCM("Перестань сопротивляться и дай мне спокойно тебя убить!");end;
				-- if SOULFUL_CONFIG["language"] =="EN" then SCM("Stop resisting and let me kill you in peace!");end;
			-- end;
			-- AventTimers[10]=AventTimers[10]+30;AventTimers[1]=AventTimers[1]+5;
		-- end;
		
	end;
	
	-- COMBAT_TEXT_UPDATE
	-- arg1 = Combat message type. Known values include "DAMAGE", "SPELL_DAMAGE", "DAMAGE_CRIT", "HEAL", "PERIODIC_HEAL", "HEAL_CRIT",
	--        "MISS", "DODGE", "PARRY", "BLOCK", "RESIST", "SPELL_RESISTED", "ABSORB", "SPELL_ABSORBED", "MANA", "ENERGY", "RAGE", "FOCUS",
	--        "SPELL_ACTIVE", "COMBO_POINTS", "AURA_START", "AURA_END", "AURA_START_HARMFUL", "AURA_END_HARMFUL", "HONOR_GAINED", and "FACTION".
	-- arg2 = For damage, power gain and honor gains, this is the amount taken/gained. For heals, this is the healer name. 
	--        For auras, the aura name. For block/resist/absorb messages where arg3 is not nil (indicating a partial block/resist/absorb) 
	--        this is the amount taken. For faction gain, this is the faction name. For the SPELL_ACTIVE message, the name of the spell 
	--        (abilities like Overpower and Riposte becoming active will trigger this message).
	-- arg3 = For heals, the amount healed. For block/resist/absorb messages, this is the amount blocked/resisted/absorbed, 
	--        or nil if all damage was avoided. For faction gain, the amount of reputation gained.
	if not AFK and event == "COMBAT_TEXT_UPDATE" and SOULFUL_CONFIG["action"] then  
		-- msg={
				-- "surrounds itself with shadow energy.",
				-- "Darkest shadows, shelter me.",
				-- "Aero Kelor Bregor"
			-- };chatType={
				-- "emote",
				-- "say",
				-- "say"
			-- };
			-- rnd=math.random(getn(msg));SCM(msg[rnd],chatType[rnd]);
		
		
		if arg1=="HEAL" and math.random(1+UnitHealthMax("player")) <= UnitHealthMax("player")-UnitHealthMax("player")+tonumber(arg3) 
		and UnitHealth("player") <= UnitHealthMax("player")-UnitHealthMax("player")/5 
		and math.random(1+(AventTimers[8]+AventTimers[1])/factor) <= 1 then db=1;
			if arg2 ~= GetUnitName("player") then 
				rnd=math.random(1,2);
				if rnd==1 then Up_Array("heal", arg2, "thanks", arg2);end;
				if rnd==2 then 
					if SOULFUL_CONFIG["language"] =="RU" then SCM("Спасибо за исцеление, "..arg2..".");end;
					if SOULFUL_CONFIG["language"] =="EN" then SCM("Thank you for healing, "..arg2..".");end;
				end;
			else 
				-- DoEmote("happy",0);
			end;
			AventTimers[8]=AventTimers[8]+30;AventTimers[1]=AventTimers[1]+5;
		end;
		
		-- if arg1=="PERIODIC_HEAL" and arg2=="player" then db=1;
		if arg1=="PERIODIC_HEAL" then db=1;
			
		end;
		if arg1=="MANA" then db=1; end;
		
		--Fishing
		
		if arg1=="SPELL_CAST" and arg2=="Fishing" and math.random(1+(4+AventTimers[11])/factor) <= 1 then db=1;
				rnd=math.random(1,14);
				if rnd>=1 and rnd<=2 then DoEmote("blink",0);end;
				if rnd>=3 and rnd<=4 then DoEmote("stare",0);end;
				if rnd>=5 and rnd<=6 then DoEmote("bored",0);end;
				if rnd>=7 and rnd<=8 then DoEmote("talkq",0);end;
			if SOULFUL_CONFIG["language"] =="RU" then 
				if rnd==9 and rnd<=10 then SCM("пристально смотрит на поплавок, ожидая действий.","emote");end;
				if rnd==11 then SCM("Эх... Было бы неплохо, если бы я мог поймать золотую рыбку и попросить ее сделать мне сотый уровень.");end;
				if rnd==12 then SCM("Эх... было бы неплохо, если бы я мог поймать золотую рыбку и попросить ее дать мне миллион золотых монет.");end;
				if rnd==13 then SCM("Эх... Было бы неплохо, если бы я мог поймать золотую рыбку и попросить ее дать мне меч тысячи истин.");end;
				if rnd==14 then SCM("Ловись рыбка, большая и маленькая, но лучше большая... ну хоть какая нибудь.");end;
			end;
			if SOULFUL_CONFIG["language"] =="EN" then 
				if rnd==9 and rnd<=10 then SCM("stares intently at the float, waiting for any of its action.","emote");end;
				if rnd==11 then SCM("Eh... it would be nice if I could catch a goldfish and ask it to make me a hundredth level.");end;
				if rnd==12 then SCM("Eh... it would be nice if I could catch a goldfish and ask it to give me a million gold coins.");end;
				if rnd==13 then SCM("Eh... it would be nice if I could catch a goldfish and ask it to give me the sword of a thousand truths.");end;
				if rnd==14 then SCM("Catch a fish, big and small, but preferably a big one... Well, at least somehow.");end;
			end;
			AventTimers[11]=AventTimers[11]+30;
		end;
		
		-- Buff/Debuff
		if 1 then 
		
		if arg1=="AURA_START_HARMFUL" and (arg2=="Chilled" or arg2=="Frostbolt" or arg2=="Frost Nova" or arg2=="Frost Shock" or arg2=="Frostbolt Volley" or arg2=="Geyser" 
		or arg2=="Freeze") and AventTimers[51] == 0 then db=1;AventTimers[51]=60;
			rnd=math.random(1,3);
			if rnd==1 then DoEmote("cold",0);end;
			if rnd==2 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Брр.. Холодрыга.");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("Brr.. It's so cold.");end;
			end;
			if rnd==3 then 
				
				if SOULFUL_CONFIG["language"] =="RU" then if UnitSex("player")==2 then SCM("Ммм.. я замёрз.");end; if UnitSex("player")==3 then SCM("Ммм.. я замёрзла.");end; end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("Mmm .. I froze.");end;
			end;
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Chilled" or arg2=="Frostbolt" or arg2=="Frost Nova" or arg2=="Frost Shock" or arg2=="Frostbolt Volley" or arg2=="Geyser" 
		or arg2=="Freeze") then db=1;--AventTimers[51]=0;
			-- SCM("","yell");
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Fear" or arg2=="Terrify" or arg2=="Intimidating Shout" or arg2=="Terrifying Screech" or arg2=="Psychic Scream" 
		or arg2=="Terrifying Howl" or arg2=="Howl of Terror" or arg2=="Repulsive Gaze" or arg2=="Intimidating Shout" or arg2=="Intimidating Roar") and AventTimers[52] == 0 then db=1;AventTimers[52]=30;
			rnd=math.random(1,4);
			if rnd==1 then DoEmote("scared",0);end;
			if rnd==2 then DoEmote("panic",0);end;
			if rnd==2 then DoEmote("fear",0);end;
			if rnd==4 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Ааа.. спасите-помогите.");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("Aaa.. Save, help.");end;
			end;
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Fear" or arg2=="Terrify" or arg2=="Intimidating Shout" or arg2=="Terrifying Screech" or arg2=="Psychic Scream" 
		or arg2=="Terrifying Howl" or arg2=="Howl of Terror" or arg2=="Repulsive Gaze" or arg2=="Intimidating Shout" or arg2=="Intimidating Roar") then db=1;--AventTimers[52]=0;
			-- SCM("","yell");
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Dominate Mind" or arg2=="Domination" or arg2=="Possess" or arg2=="Cause Insanity" or arg2=="Arugal's Curse" or arg2=="Poison Mind") and AventTimers[53] == 0 then db=1;AventTimers[53]=30;
			rnd=math.random(1,3);
			if rnd==1 then DoEmote("roar",0);end;--DoEmote("roar",0);
			if rnd==2 then DoEmote("train",0);end;
			if rnd==3 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Ща кому то втащу!");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("Now I'm going to hit someone!");end;
			end;
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Dominate Mind" or arg2=="Domination" or arg2=="Possess" or arg2=="Cause Insanity" or arg2=="Arugal's Curse" or arg2=="Poison Mind") then db=1;--AventTimers[53]=0;
			rnd=math.random(1,2);
			if rnd==1 then DoEmote("ponder",0);end;
			if rnd==2 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("И что это было?!");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("And what was it?!");end;
			end;
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Sleep" or arg2=="Druid's Slumber" or arg2=="Naralex's Nightmare" or arg2=="Crystalline Slumber" 
		or arg2=="Dreamless Sleep" or arg2=="Deep Sleep" or arg2=="Deep Slumber" or arg2=="Sleepy" or arg2=="Asleep") and AventTimers[54] == 0 then db=1;AventTimers[54]=30;
			rnd=math.random(1,2);
			if rnd==1 then DoEmote("sleep",0);end;
			if rnd==2 then SCM("Zzz");end;
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Sleep" or arg2=="Druid's Slumber" or arg2=="Naralex's Nightmare" or arg2=="Crystalline Slumber" 
		or arg2=="Dreamless Sleep" or arg2=="Deep Sleep" or arg2=="Deep Slumber" or arg2=="Sleepy" or arg2=="Asleep") then db=1;--AventTimers[54]=0;
			DoEmote("stand",0);DoEmote("yawn",0);
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Silence" or arg2=="Sonic Burst") and AventTimers[55] == 0 then db=1;AventTimers[55]=15;
			SCM("...");SFMute=true;
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Silence" or arg2=="Sonic Burst") then db=1;--AventTimers[55]=0;
			DoEmote("sigh",0);SFMute=nil;
		end;
		if arg1=="AURA_START_HARMFUL" and arg2=="Shield Bash" and AventTimers[55] == 0 then db=1;AventTimers[67]=30;
			if SOULFUL_CONFIG["language"] =="RU" then SCM("Проклятье, заклинание прервано!");end;
			if SOULFUL_CONFIG["language"] =="EN" then SCM("Damn, the spell is interrupted!");end; --Damn it, the spell has been broken!
		end;
		if arg1=="AURA_END_HARMFUL" and arg2=="Shield Bash" then db=1;AventTimers[55]=0;
			DoEmote("sigh",0);
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Polymorph" or arg2=="Curse of the Plague Rat") and AventTimers[56] == 0 then db=1;AventTimers[56]=30;
			if SOULFUL_CONFIG["language"] =="RU" then SCM("Бееее");end;
			if SOULFUL_CONFIG["language"] =="EN" then SCM("Beeee");end;
			
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Polymorph" or arg2=="Curse of the Plague Rat") then db=1;--AventTimers[56]=0;
			-- SCM("","say");
		end;
		if arg1=="AURA_START_HARMFUL" and arg2=="Hex" and AventTimers[57] == 0 then db=1; AventTimers[57]=30;
			if SOULFUL_CONFIG["language"] =="RU" then SCM("Кваак");end;
			if SOULFUL_CONFIG["language"] =="EN" then SCM("Croak");end;
		end;
		if arg1=="AURA_END_HARMFUL" and arg2=="Hex" then db=1;--AventTimers[57]=0;
			-- SCM("","say");
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Hammer of Justice" or arg2=="Stun" or arg2=="War Stomp" or arg2=="Paralyzing Poison" or arg2=="Crusader's Hammer" 
		or arg2=="Backhand" or arg2=="Smite Stomp" or arg2=="Ground Tremor" or arg2=="Fist of Ragnaros" or arg2=="Summon Shardlings" or arg2=="Petrify" 
		or arg2=="Soul Drain" or arg2=="Sacrifice" or arg2=="Burning Winds" or arg2=="Stun Bomb" or arg2=="Charge" or arg2=="Cowering Roar") and AventTimers[58] == 0 then db=1;AventTimers[58]=30;
			SCM("(*_*)");
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Hammer of Justice" or arg2=="Stun" or arg2=="War Stomp" or arg2=="Paralyzing Poison" or arg2=="Crusader's Hammer" 
		or arg2=="Backhand" or arg2=="Smite Stomp" or arg2=="Ground Tremor" or arg2=="Fist of Ragnaros" or arg2=="Summon Shardlings" or arg2=="Petrify" 
		or arg2=="Soul Drain" or arg2=="Sacrifice" or arg2=="Burning Winds" or arg2=="Stun Bomb" or arg2=="Charge" or arg2=="Cowering Roar") then db=1;--AventTimers[58]=0;
			-- SCM("","say");
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Crystal Gaze" or arg2=="Crystal Flash" or arg2=="Gouge" or arg2=="Enchanting Lullaby") and AventTimers[59] == 0 then db=1;AventTimers[59]=30;
			SCM("(#_#)");
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Crystal Gaze" or arg2=="Crystal Flash" or arg2=="Gouge" or arg2=="Enchanting Lullaby") then db=1;--AventTimers[59]=0;
			-- SCM("","say");
		end
		--Poison Яд
		if arg1=="AURA_START_HARMFUL" and (arg2=="Poison" or arg2=="Acid Splash" or arg2=="Venom Spit" or arg2=="Poison Bolt" or arg2=="Slowing Poison" 
		or arg2=="Maggot Goo" or arg2=="Creeper Venom" or arg2=="Barbed Sting" or arg2=="Deadly Poison" or arg2=="Leech Poison" or arg2=="Venom Sting" 
		or arg2=="Poisonous Stab" or arg2=="Toxic Saliva" or arg2=="Localized Toxin" or arg2=="Parasite" or arg2=="Noxious Catalyst" or arg2=="Weak Poison" 
		or arg2=="Poisoned Harpoon" or arg2=="Putrid Bile") and AventTimers[60] == 0 then db=1;AventTimers[60]=30;
			rnd=math.random(1,3);
			if rnd==1 then DoEmote("belch",0);end;
			if rnd==2 then SCM("(~_~)");end;
			if rnd==3 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Чёрт, меня отравили.");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("Damn, I've been poisoned.");end;
			end;
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Poison" or arg2=="Acid Splash" or arg2=="Venom Spit" or arg2=="Poison Bolt" or arg2=="Slowing Poison" 
		or arg2=="Maggot Goo" or arg2=="Creeper Venom" or arg2=="Barbed Sting" or arg2=="Deadly Poison" or arg2=="Leech Poison" or arg2=="Venom Sting" 
		or arg2=="Poisonous Stab" or arg2=="Toxic Saliva" or arg2=="Localized Toxin" or arg2=="Parasite" or arg2=="Noxious Catalyst" or arg2=="Weak Poison" 
		or arg2=="Poisoned Harpoon" or arg2=="Putrid Bite") then db=1;--AventTimers[60]=0;
			-- SCM("","say");
		end;
		--Infected / Disease
		if arg1=="AURA_START_HARMFUL" and (arg2=="Infected Bite" or arg2=="Infected Wound" or arg2=="Maggot Slime" or arg2=="Putrid Enzyme" or arg2=="Wandering Plague" 
		or arg2=="Irradiated" or arg2=="Decayed Agility" or arg2=="Tetanus" or arg2=="Plague Cloud" or arg2=="Ghoul Plague" or arg2=="Black Rot" or arg2=="Decayed Strengh" 
		or arg2=="Volatile Infection" or arg2=="Dark Sludge") and AventTimers[60] == 0 then db=1;AventTimers[60]=30;
			rnd=math.random(1,3);
			if rnd==1 then DoEmote("cough",0);end;
			if rnd==2 then SCM("(&_&)");end;
			if rnd==3 then 
				if SOULFUL_CONFIG["language"] =="RU" then 
					if UnitSex("player")==2 then sex="болен";end; if UnitSex("player")==3 then sex="больна";end;SCM("Кхк кхе.. Я "..sex..".");
				end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("Khe, khe.. I'm sick.");end;
			end;
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Infected Bite" or arg2=="Infected Wound" or arg2=="Maggot Slime" or arg2=="Putrid Enzyme" or arg2=="Wandering Plague" 
		or arg2=="Irradiated" or arg2=="Decayed Agility" or arg2=="Tetanus" or arg2=="Plague Cloud" or arg2=="Ghoul Plague" or arg2=="Black Rot" or arg2=="Decayed Strengh" 
		or arg2=="Volatile Infection" or arg2=="Dark Sludge") then db=1;AventTimers[60]=0;
			-- SCM("","say");
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Ink Spray" or arg2=="Smoke Bomb" or arg2=="Sling Dirt" or arg2=="Steam Jet" or arg2=="Blinding Sand") and AventTimers[61] == 0 then db=1;--AventTimers[61]=30;
			rnd=math.random(1,2);
			if rnd==1 then SCM("(-_-)");end;
			if rnd==2 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Ааа.. мои глаза, я ослеп.");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("Aaa.. my eyes, I'm blind.");end;
			end;
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Ink Spray" or arg2=="Smoke Bomb" or arg2=="Sling Dirt" or arg2=="Steam Jet" or arg2=="Blinding Sand") then db=1;--AventTimers[61]=0;
			rnd=math.random(1,2);
			if rnd==1 then SCM("(o_o)");end;
			if rnd==2 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Фух.. я снова вижу.");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("Phew.. I see again.");end;
			end;
			-- SCM("","say");
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Lash" or arg2=="Shield Slam" or arg2=="Knockdown" or arg2=="Snap Kick" or arg2=="Swoop") then db=1;--AventTimers[62]=30;
			rnd=math.random(1,2);
			if rnd==1 then DoEmote("frown",0);end;
			if rnd==2 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Ауч..");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("Doh..");end;
			end;
		end;
		if arg1=="AURA_END_HARMFUL" and  (arg2=="Lash" or arg2=="Shield Slam" or arg2=="Knockdown" or arg2=="Snap Kick" or arg2=="Swoop") then db=1;--AventTimers[62]=0;
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Dropped Weapon" or arg2=="Disarm") then db=1;AventTimers[63]=30;
			DoEmote("frown",0);
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Dropped Weapon" or arg2=="Disarm") then db=1;--AventTimers[63]=0;
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Web" or arg2=="Hooked Net" or arg2=="Enveloping Web" or arg2=="Entangling Roots" or arg2=="Web Explosion") then db=1;AventTimers[64]=30;
			rnd=math.random(1,2);
			if rnd==1 then SCM("puzzled.","emote");end;
			if rnd==2 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Чёрт, Я не могу сдвинуться.");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("Damn, I can't move.");end;
			end;
			
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Web" or arg2=="Hooked Net" or arg2=="Enveloping Web" or arg2=="Entangling Roots" or arg2=="Web Explosion") then db=1;--AventTimers[64]=0;
			-- SCM("","say");
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Dazed" or arg2=="Thunderclap" or arg2=="Tendon Rip" or arg2=="Mind Tremor") then db=1;AventTimers[65]=30;
			DoEmote("frown",0);
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Dazed" or arg2=="Thunderclap" or arg2=="Tendon Rip" or arg2=="Mind Tremor") then db=1;--AventTimers[65]=0;
			-- SCM("","say");
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Dissolve Armor" or arg2=="Unholy Curse" or arg2=="Demoralizing Shout" or arg2=="Corrosive Ooze") then db=1;AventTimers[66]=30;
			DoEmote("frown",0);
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Dissolve Armor" or arg2=="Demoralizing Shout" or arg2=="Corrosive Ooze") then db=1;--AventTimers[66]=0;
			-- SCM("","say");
		end;
		--Cursed Проклятье --Aural Shock
		if arg1=="AURA_START_HARMFUL" and (arg2=="Aural Shock" or arg2=="Curse of Tongue" or arg2=="Haunting Spirits" or arg2=="Curse of Blood" or arg2=="Arugal's Gift" 
		or arg2=="Curse of Weakness" or arg2=="Curse of Mending" or arg2=="Banshee Curse" or arg2=="Shrink" or arg2=="Curse of Tuten'kash" or arg2=="Curse of the Firebrand" 
		or arg2=="Curse of Blood" or arg2=="Curse of the Darkmaster" or arg2=="Wailing Dead" or arg2=="Wailing Dead" or arg2=="Curse of the Plague Rat") then db=1;AventTimers[68]=30;
			rnd=math.random(1,2);
			if rnd==1 then DoEmote("frown",0);end;--SCM("frown","emote");
			if rnd==2 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Чёрт, Меня прокляли.");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("Damn, I've been cursed.");end;
			end;
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Aural Shock" or arg2=="Curse of Tongue" or arg2=="Haunting Spirits" or arg2=="Curse of Blood" or arg2=="Arugal's Gift" 
		or arg2=="Curse of Weakness" or arg2=="Curse of Mending" or arg2=="Banshee Curse" or arg2=="Shrink" or arg2=="Curse of Tuten'kash" or arg2=="Curse of the Firebrand" 
		or arg2=="Curse of Blood" or arg2=="Curse of the Darkmaster" or arg2=="Wailing Dead" or arg2=="Wailing Dead" or arg2=="Curse of the Plague Rat") then db=1;--AventTimers[68]=0;
			-- SCM("","say");
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Rend") then db=1;AventTimers[69]=30;
			DoEmote("bleed",0);
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Rend") then db=1;--AventTimers[69]=0;
			-- SCM("","say");
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Banish") and AventTimers[71] == 0 then db=1;AventTimers[71]=30;
			SCM("(8_8)");
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Banish") then db=1;--AventTimers[71]=0;
			-- SCM("","say");
		end;
		if arg1=="AURA_START_HARMFUL" and (arg2=="Burning Winds" or arg2=="Immolate" or arg2=="Immolation Trap Effect" or arg2=="Aeltalor Flameshard") and AventTimers[71] == 0 then db=1;AventTimers[71]=30;
			rnd=math.random(1,2);
			if rnd==1 then SCM("is slowly turning to charcoal.","emote");end;
			if rnd==2 then 
				if SOULFUL_CONFIG["language"] =="RU" then SCM("Ааа.. моя жопа горит.");end;
				if SOULFUL_CONFIG["language"] =="EN" then SCM("Aaa...my ass is on fire.");end;
			end;
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Burning Winds" or arg2=="Immolate" or arg2=="Immolation Trap Effect" or arg2=="Aeltalor Flameshard") then db=1;--AventTimers[71]=0;
			-- SCM("","say");
		end;
		
		if arg1=="AURA_START_HARMFUL" and UnitClass("player")~="Warlock" and arg2=="Soulstone Resurrection" and AventTimers[72] == 0 then db=1;AventTimers[72]=30;
			rnd=math.random(1,2);
			if rnd==1 then DoEmote("happy",0);end;
			if rnd==2 then SCM("gained a bonus life.","emote");end;
			
		end;
		if arg1=="AURA_END_HARMFUL" and UnitClass("player")~="Warlock" and arg2=="Soulstone Resurrection" then db=1;--AventTimers[72]=0;
			rnd=math.random(1,2);
			if rnd==1 then DoEmote("frown",0);end;
			if rnd==2 then SCM("lost his bonus life.","emote");end;
		end;
		
		if arg1=="AURA_START" and AventTimers[73] == 0 
		and ( (UnitClass("player")~="Druid" and (arg2=="Mark of the Wild" or arg2=="Gift of the Wild" or arg2=="Thorns"))
		or (UnitClass("player")~="Priest" and (arg2=="Power Word: Fortitude" or arg2=="Prayer of Fortitude" or arg2=="Divine Spirit"))
		or (UnitClass("player")~="Paladin" and (arg2=="Blessing of Might" or arg2=="Greater Blessing of Might" or arg2=="Blessing of Wisdom" or arg2=="Greater Blessing of Wisdom" or arg2=="Blessing of Kings" or arg2=="Greater Blessing of Kings" or arg2=="Blessing of Sanctuary" or arg2=="Greater Blessing of Sanctuary"))
		or (UnitClass("player")~="Mage" and (arg2=="Arcane Intellect" or arg2=="Arcane Brilliance"))
		or (UnitClass("player")~="Warlock" and (arg2=="Unending Breath"))
		)
		then db=1;--AventTimers[73]=5;
			rnd=math.random(1,2);
			if rnd==1 then DoEmote("happy",0);end;
			if rnd==2 then 
				if SOULFUL_CONFIG["language"] == "RU" then SCM("Ооо.. Спасибо за "..arg2.." бафф.","say"); end;
				if SOULFUL_CONFIG["language"] == "EN" then SCM("Ohh.. Thanks for the "..arg2.." buff.","say"); end;
			end;
		end;
		if arg1=="AURA_END" and AventTimers[73] == 0 
		and ( (UnitClass("player")~="Druid" and (arg2=="Mark of the Wild" or arg2=="Gift of the Wild" or arg2=="Thorns"))
		or (UnitClass("player")~="Priest" and (arg2=="Power Word: Fortitude" or arg2=="Prayer of Fortitude" or arg2=="Divine Spirit" or arg2=="Shadow Protection"))
		or (UnitClass("player")~="Paladin" and (arg2=="Blessing of Might" or arg2=="Greater Blessing of Might" or arg2=="Blessing of Wisdom" or arg2=="Greater Blessing of Wisdom" or arg2=="Blessing of Kings" or arg2=="Greater Blessing of Kings" or arg2=="Blessing of Sanctuary" or arg2=="Greater Blessing of Sanctuary"))
		or (UnitClass("player")~="Mage" and (arg2=="Arcane Intellect" or arg2=="Arcane Brilliance"))
		or (UnitClass("player")~="Warlock" and (arg2=="Unending Breath"))
		)
		then db=1;--AventTimers[73]=5;
			-- rnd=math.random(1,2);
			-- if rnd==1 then DoEmote("frown",0);end;
			-- if rnd==2 then 
				-- if SOULFUL_CONFIG["language"] == "RU" then SCM("Мой бафф "..arg2.." пропал :(","say"); end;
				-- if SOULFUL_CONFIG["language"] == "EN" then SCM("My buff "..arg2.." is gone :(","say"); end;
			-- end;
			if UnitExists("party1") then 
				if SOULFUL_CONFIG["language"] == "RU" then SCM("Мой бафф "..arg2.." пропал :(","say"); end;
				if SOULFUL_CONFIG["language"] == "EN" then SCM("My buff "..arg2.." is gone :(","say"); end;
			else 
				DoEmote("frown",0);
			end;
		end;
		
		if arg1=="AURA_START" and arg2=="Rallying Cry of the Dragonslayer" and AventTimers[74] == 0 then db=1;--AventTimers[73]=30;
			rnd=math.random(1,3);
			if rnd==1 then DoEmote("roar",0);end;
			if rnd==2 then DoEmote("happy",0);end;
			if rnd==3 then DoEmote("cheer",0);end;
			if rnd==4 then 
				if SOULFUL_CONFIG["language"] == "RU" then SCM("Ооо.. "..arg2.." бафф.","say"); end;
				if SOULFUL_CONFIG["language"] == "EN" then SCM("Ohh.. "..arg2.." buff.","say"); end;
			end;
		end;
		if arg1=="AURA_END" and arg2=="Rallying Cry of the Dragonslayer" then db=1;--AventTimers[74]=0;
			rnd=math.random(1,2);
			if rnd==1 then DoEmote("frown",0);end;
			if rnd==2 then DoEmote("sad",0);end;
			if rnd==3 then 
				if SOULFUL_CONFIG["language"] == "RU" then SCM("Мой бафф "..arg2.." пропал :(","say"); end;
				if SOULFUL_CONFIG["language"] == "EN" then SCM("My buff "..arg2.." is gone :(","say"); end;
			end;
		end;

		if arg1=="AURA_START_HARMFUL" and (arg2=="Omen of Clarity" or arg2=="Thorns" or arg2=="Mark of the Wild" or arg2=="Abolish Poison") then db=1;
			
		end;
		if arg1=="AURA_END_HARMFUL" and (arg2=="Omen of Clarity" or arg2=="Thorns" or arg2=="Mark of the Wild" or arg2=="Abolish Poison") then db=1;
			
		end;
		
		
		end;
		
		-- Trinket --
		if 1 then 
		
		-- if arg1=="AURA_START_HARMFUL" and arg2=="Gnomish Death Ray" and UnitExists("target") then db=1;
			-- if SOULFUL_CONFIG["language"] =="RU" then 
				-- rnd=math.random(1,2);
				-- if rnd==1 then SCM("готовится распылить "..GetUnitName("target")..".","emote");DoEmote("chuckle","target");end;
				-- if rnd==2 then SCM("Готовся умереть "..GetUnitName("target").."..ух ха ха ха..");DoEmote("guffaw","target");end;
			-- end;
			-- if SOULFUL_CONFIG["language"] =="EN" then 
				-- rnd=math.random(1,2);
				-- if rnd==1 then SCM("prepares to disintegrate "..GetUnitName("target")..".","emote");DoEmote("chuckle","target");end;
				-- if rnd==2 then SCM("Get ready to die "..GetUnitName("target").."..uh ha ha ha..");DoEmote("guffaw","target");end;
			-- end;
			-- AventTimers[1]=AventTimers[1]+5;
		-- end;
		-- if arg1=="AURA_END_HARMFUL" and arg2=="Gnomish Death Ray" and UnitExists("target") then db=1;
			-- if SOULFUL_CONFIG["language"] =="RU" then 
				-- rnd=math.random(1,2);
				-- if rnd==1 then SCM("выпускает яркий луч из руки в сторону "..GetUnitName("target")..".","emote");end;
				-- if rnd==2 then DoEmote("openfire");end;
			-- end;
			-- if SOULFUL_CONFIG["language"] =="EN" then 
				-- rnd=math.random(1,2);
				-- if rnd==1 then SCM("releases a bright beam from his hand in the direction of "..GetUnitName("target")..".","emote");end;
				-- if rnd==2 then DoEmote("openfire");end;
			-- end;
		-- end;
		if arg1=="AURA_END_HARMFUL" and arg2=="Goblin Dragon Gun" then db=1;
			if SOULFUL_CONFIG["language"] =="RU" then 
				rnd=math.random(1,3);
				if rnd==1 then SCM("извергает пламя из своих рук.","emote");end;
				if rnd==2 then SCM("Гори ублюдок","emote");end;
				if rnd==3 then DoEmote("openfire");end;
			end;
			if SOULFUL_CONFIG["language"] =="EN" then 
				rnd=math.random(1,3);
				if rnd==1 then SCM("erupts the flame from its hands.","emote");end;
				if rnd==2 then SCM("Burn the bastards!","emote");end;
				if rnd==3 then DoEmote("openfire");end;
			end;
		end;
		if arg1=="AURA_START_HARMFUL" and arg2=="Devilsaur Fury" and UnitExists("target") then db=1;
			if SOULFUL_CONFIG["language"] =="RU" then 
				rnd=math.random(1,2);
				if rnd==1 then  end;
				if rnd==2 then  end;
			end;
			if SOULFUL_CONFIG["language"] =="EN" then 
				rnd=math.random(1,2);
				if rnd==1 then  end;
				if rnd==2 then  end;
			end;
			AventTimers[1]=AventTimers[1]+5;
		end;
		
		end;
		
		-- Racial --
		if 1 then 
		
		if arg1=="AURA_START" and arg2=="Quel'dorei Meditation" then db=1;
			if SOULFUL_CONFIG["language"] =="RU" then 
				rnd=math.random(1,4);
				if rnd==1 then DoEmote("roar",0);end;
				if rnd==2 then SCM("закручивает вокруг себя вихрь, собирая энергию из окружающей среды.","emote");end;
				if rnd==3 then SCM("Трах-тибидох");end;
				if rnd==4 then SCM("Кручу верчу, наеб@ть всех хочу.");end;
			end;
			if SOULFUL_CONFIG["language"] =="EN" then 
				rnd=math.random(1,2);
				if rnd==1 then DoEmote("roar",0);end;
				if rnd==2 then SCM("twists a whirlwind around her, collecting energy from the environment.","emote");end;
			end;
		end;
		if arg1=="AURA_START" and arg2=="Sun's Embrace" then db=1;
			-- DoEmote("raise",0);
		end;
		if arg1=="AURA_END" and arg2=="Sun's Embrace" then db=1;
			
		end;
		if arg1=="AURA_START" and arg2=="Elune's Grace" and math.random(1+AventTimers[174]+AventTimers[101]) then db=1;
			if SOULFUL_CONFIG["language"] =="RU" then 
				rnd=math.random(1,2);
				if rnd==1 then SCM("получает благословение Elune.","emote");end;
				if rnd==2 then SCM("Элуна, благослови меня!");end;
			end;
			if SOULFUL_CONFIG["language"] =="EN" then 
				rnd=math.random(1,2);
				if rnd==1 then SCM("gets Elune's blessing.","emote");end;
				if rnd==2 then SCM("Elune, bless me!");end;
			end;
			AventTimers[174]=AventTimers[174]+5;AventTimers[101]=AventTimers[101]+5;
		end;
		if arg1=="AURA_END" and arg2=="Elune's Grace" then db=1;
			
		end;
		if arg1=="AURA_START" and arg2=="Shadowmeld" and AventTimers[104]<=0 then db=1;
			if SOULFUL_CONFIG["language"] =="RU" then SCM("сливается с тенями.","emote");end;
			if SOULFUL_CONFIG["language"] =="EN" then SCM("merges with shadows.","emote");end;
			AventTimers[104]=10;
		end;
		if arg1=="AURA_END" and arg2=="Shadowmeld" and AventTimers[104]<=0 then db=1;
			DoEmote("pounce",0);
			AventTimers[104]=10;
		end;
		
		end;
		
		-- UnitClass --
		if 1 then 
		
		if UnitClass("player")=="Warlock" then 
			-- if arg1=="AURA_START" and arg2=="Drain Soul" and math.random(1+AventTimers[181]+AventTimers[101]) == 1 and UnitExists("target") then 
				-- if GotBuff("Spell_Shadow_Haunting","player") and GotDebuff("Spell_Shadow_Haunting","target") then db=1;
					-- if SOULFUL_CONFIG["language"] =="RU" then 
						-- rnd=math.random(1,5);
						-- if rnd==1 then SCM("пожирает душу "..GetUnitName("target")..".","emote");end;
						-- if rnd==2 then SCM("Твоя душа моя, "..GetUnitName("target")..".");end;
						-- if rnd==3 then SCM("Я вырву твою душу "..GetUnitName("target").." и скормлю демонам.");end;
						-- if rnd==4 then SCM(GetUnitName("target")..", ты пополнишь мою коллекцию душь.");end;
							-- -- Shaza-kiel! = Surrender your soul!
						-- if rnd==5 then SCM("Shaza-kiel!");end;-- Shaza-kiel! = Surrender your soul!
					-- end;
					-- if SOULFUL_CONFIG["language"] =="EN" then 
						-- rnd=math.random(1,5);
						-- if rnd==1 then SCM("devours the soul of "..GetUnitName("target")..".","emote");end;
						-- if rnd==2 then SCM("You r soul is mine, "..GetUnitName("target")..".");end;
						-- if rnd==3 then SCM("I will tear out your soul "..GetUnitName("target").." and feed the demon.");end;
						-- if rnd==4 then SCM(GetUnitName("target")..", you will replenish my collection of souls.");end;
							-- -- Shaza-kiel! = Surrender your soul!
						-- if rnd==5 then SCM("Shaza-kiel!");end;-- Shaza-kiel! = Surrender your soul!
					-- end;
					-- AventTimers[181]=AventTimers[181]+60;AventTimers[101]=AventTimers[101]+30;
				-- end;
			-- end;
			-- if arg1=="AURA_END" and arg2=="Drain Soul" then db=1;end;
			
			-- if arg1=="HEAL" and arg2==GetUnitName("player") and math.random(1+(AventTimers[182]+AventTimers[101])/factor) == 1 and UnitExists("target") then 
				-- if GotDebuff("Spell_Shadow_LifeDrain02","target") then db=1;
					-- if SOULFUL_CONFIG["language"] =="RU" then 
						-- rnd=math.random(1,10);
						-- if rnd==1 then SCM("выкачивает жизнь из "..GetUnitName("target")..".","emote");end;
						-- if rnd==2 then SCM("Я выпью твою жизнь до последней капли, "..GetUnitName("target")..".");end;
						-- if rnd==3 then SCM("Отдай мне, "..GetUnitName("target")..", свою жизнь.");end;
						-- if rnd==4 then SCM(GetUnitName("target")..", Я пожру тебя, медленно.");end;
						-- if rnd==5 then SCM("A-rul shach kigon.");end;-- = I will eat your heart
					-- end;
					-- if SOULFUL_CONFIG["language"] =="EN" then 
						-- rnd=math.random(1,10);
						-- if rnd==1 then SCM("siphons life out of "..GetUnitName("target")..".","emote");end;
						-- if rnd==2 then SCM("I will drink your health to the last drop, "..GetUnitName("target")..".");end;
						-- if rnd==3 then SCM("Give me, "..GetUnitName("target")..", your life.");end;
						-- if rnd==4 then SCM(GetUnitName("target")..", I will devour you, slowly.");end;
						-- if rnd==5 then SCM("A-rul shach kigon.");end;-- = I will eat your heart
					-- end;
					-- AventTimers[182]=AventTimers[182]+60;AventTimers[101]=AventTimers[101]+30;
				-- end;
			-- end;
			if arg1=="MANA" and arg2==GetUnitName("player") and DMTimer<=0 and UnitExists("target") then 
				if GotDebuff("Spell_Shadow_SiphonMana","target") then 
					if math.random()<0.5 then 
						SCM("siphons energy from "..GetUnitName("target"),"emote");
					else 
						-- SCM(COLOR_BLUE("I will drink all your energy, "..GetUnitName("target")));
						SCM("I will drink all your energy, "..GetUnitName("target"));
					end;
					DMTimer=10+5*math.random(4);
				end;
			end;
			
			if arg1=="AURA_START" and arg2=="Health Funnel" and math.random(1+(AventTimers[183]+AventTimers[101])/factor) == 1 then db=1;
				if SOULFUL_CONFIG["language"] =="RU" then 
					rnd=math.random(1,3);
					if rnd==1 then SCM("делится своей жизнью с "..GetUnitName("pet")..".","emote");end;
					if rnd==2 then SCM("Возьми мою кров - "..GetUnitName("pet") .." и уничтожь моих врагов.");end;
					if rnd==3 then SCM("Achor she-ki.");end;
				end;
				if SOULFUL_CONFIG["language"] =="EN" then 
					rnd=math.random(1,3);
					if rnd==1 then SCM("shares his life with "..GetUnitName("pet")..".","emote");end;
					if rnd==2 then SCM("Take my blood - "..GetUnitName("pet") .." and destroy my enemies.");end;
					if rnd==3 then SCM("Achor she-ki.");end;
				end;
				AventTimers[183]=AventTimers[183]+60;AventTimers[101]=AventTimers[101]+30;
			end;
			if arg1=="AURA_END" and arg2=="Health Funnel" then db=1;end;
			
			if arg1=="AURA_START" and arg2=="Demon Armor" and math.random(1+(AventTimers[182]+AventTimers[101])/factor) == 1 then db=1;
				if SOULFUL_CONFIG["language"] =="RU" then 
					rnd=math.random(1,3);
					if rnd==1 then SCM("окружает себя теневой энергией.","emote");end;
					if rnd==2 then SCM("Темнейшие тени, укровйте меня.");end;
					if rnd==3 then SCM("Ered'ruin.");end;-- = doomguard
				end;
				if SOULFUL_CONFIG["language"] =="EN" then 
					rnd=math.random(1,3);
					if rnd==1 then SCM("surrounds itself with shadow energy.","emote");end;
					if rnd==2 then SCM("Darkest shadows, shelter me.");end;
					if rnd==3 then SCM("Ered'ruin.");end;-- = doomguard
				end;
				AventTimers[182]=AventTimers[182]+60;AventTimers[101]=AventTimers[101]+30;
			end;
			if arg1=="AURA_END" and arg2=="Demon Armor" then db=1;end;
			
			if arg1=="AURA_START" and arg2=="Hellfire" and math.random(1+(AventTimers[182]+AventTimers[101])/factor) == 1 then db=1;
				if SOULFUL_CONFIG["language"] =="RU" then 
					rnd=math.random(1,5);
					if rnd==1 then SCM("вспыхивает ярким пламенем и сжигает все вокруг.","emote");end;
					if rnd==2 then SCM("Иммолейт Импрувед!","yell");end;
					if rnd==3 then SCM("Я сожгу вас всех дотла!");end;
					if rnd==4 then SCM("Dalektharu il dask daku.");end;
					if rnd==5 then DoEmote("roar",0);end;
				end;
				if SOULFUL_CONFIG["language"] =="EN" then 
					rnd=math.random(1,5);
					if rnd==1 then SCM("bursts a bright flame and burns everything around it.","emote");end;
					if rnd==2 then SCM("Immolate Improved!","yell");end;
					if rnd==3 then SCM("I will burn you all to the ground!");end;
					if rnd==4 then SCM("Dalektharu il dask daku.");end;
					if rnd==5 then DoEmote("roar",0);end;
				end;
				AventTimers[182]=AventTimers[182]+60;AventTimers[101]=AventTimers[101]+30;
			end;
			
			if arg1=="SPELL_CAST" and arg2=="Summon Imp" then db=1;
				if SOULFUL_CONFIG["language"] =="RU" then 
					rnd=math.random(1,3)
					if rnd==1 then SCM("открывает портал, и из него выходит маленький сердитый чертенок.","emote");end;
					if rnd==2 then SCM("Иди сюда, мерзкий маленький дьявол!");end;
					if rnd==3 then SCM("Anach kyree.");end;-- = Miserable insect
				end;
				if SOULFUL_CONFIG["language"] =="EN" then 
					rnd=math.random(1,3)
					if rnd==1 then SCM("opens the portal and a small angry imp comes out of it.","emote");end;
					if rnd==2 then SCM("Come here, a crapy nasty little devil!");end;
					if rnd==3 then SCM("Anach kyree.");end;-- = Miserable insect
				end;
			end;
			if arg1=="SPELL_CAST" and arg2=="Summon Voidwalker" then db=1;
				if SOULFUL_CONFIG["language"] =="RU" then 
					rnd=math.random(1,3);
					if rnd==1 then SCM("открывает портал, и из него выходит существо, созданное из пустоты.","emote");end;
					if rnd==2 then SCM("Приди и покрой меня, существо пустоты.");end;
					if rnd==3 then SCM("Zenn ruin.");end;-- = Void, Darkness Guard
				end;
				if SOULFUL_CONFIG["language"] =="EN" then 
					rnd=math.random(1,3);
					if rnd==1 then SCM("opens a portal and out of it comes a creature created from the void.","emote");end;
					if rnd==2 then SCM("Come and cover me, a void creature.");end;
					if rnd==3 then SCM("Zenn ruin.");end;-- = Void, Darkness Guard
				end;
			end;
			if arg1=="SPELL_CAST" and arg2=="Summon Succubus" then db=1;
				if SOULFUL_CONFIG["language"] =="RU" then 
					rnd=math.random(1,3);
					if rnd==1 then SCM("открывает портал, и из него выходит соблазнительный суккуб.","emote");end;
					if rnd==2 then SCM("Иди, детка, поиграй с ними.");end;
					if rnd==3 then SCM("Katra zil shukil.");end;-- = Suffer and perish
				end;
				if SOULFUL_CONFIG["language"] =="EN" then 
					rnd=math.random(1,3);
					if rnd==1 then SCM("opens the portal, and a seductive succubus comes out of it.","emote");end;
					if rnd==2 then SCM("Go baby, play with them.");end;
					if rnd==3 then SCM("Katra zil shukil.");end;-- = Suffer and perish
				end;
			end;
			if arg1=="SPELL_CAST" and arg2=="Summon Felhunter" then db=1;
				if SOULFUL_CONFIG["language"] =="RU" then 
					rnd=math.random(1,3);
					if rnd==1 then SCM("открывает портал, и из него выходит гончая скверны.","emote");end;
					if rnd==2 then SCM("Ко мне, мальчик, иди сюда!");end;
					if rnd==3 then SCM("Gor'om haguul.");end;-- = Meddling dog
				end;
				if SOULFUL_CONFIG["language"] =="EN" then 
					rnd=math.random(1,3);
					if rnd==1 then SCM("opens the portal, and a fel hound comes out of it.","emote");end;
					if rnd==2 then SCM("Come on boy, come here!");end;
					if rnd==3 then SCM("Gor'om haguul.");end;-- = Meddling dog
					-- if rnd==4 then DoEmote("pat","pet");end;
				end;
			end;
			if arg1=="AURA_START" and arg2=="Summon Felsteed" and math.random(1+3/factor)<=1 then db=1;
				SCM("Kone'm Ruluu.");
			end;
			if arg1=="AURA_END" and arg2=="Summon Felsteed" and math.random(1+3/factor)<=1 then db=1;
				SCM("Kon'ag Srulil.");
			end;
			
		end;
		
		if UnitClass("player")=="Priest" then 
			
			-- if arg1=="AURA_START" and arg2=="Inner Fire" and math.random(1+AventTimers[171]+AventTimers[101]) == 1 then db=1;
				-- rnd=math.random(1,3);
				-- if SOULFUL_CONFIG["language"] =="RU" then 
					-- if rnd==1 then SCM("освещается ярким резонирующим светом.","emote");end;
					-- if rnd==2 then 
						-- if GotBuff("Shadowform","player") then SCM("Тьма, дай мне силу!");
						-- else 
							-- if UnitRace("player")=="Night Elf" then SCM("Элуна, дай мне силу!");else SCM("Свет, дай мне силу!");end;
						-- end;
					-- end;
					-- if rnd==3 then 
						-- if GotBuff("Shadowform","player") then SCM("Да укроет меня мрак!");
						-- else 
							-- if UnitRace("player")=="Night Elf" then SCM("Да защитит меня свет Элуны!");else SCM("Да защитит меня Свет!");end;
						-- end;
					-- end;
					-- if rnd==4 then 
						-- if GotBuff("Shadowform","player") then SCM("Да прольётся мрак!");
						-- else 
							-- if UnitRace("player")=="Night Elf" then SCM("Да прольётся свет Элуны!");else SCM("Да прольётся свет!");end;
						-- end;
					-- end;
				-- end;
				-- if SOULFUL_CONFIG["language"] =="EN" then 
					-- if rnd==1 then SCM("is illuminated by a bright resonating light.","emote");end;
					-- if rnd==2 then 
						-- if GotBuff("Shadowform","player") then SCM("Darkness, give me strength!");
						-- else 
							-- if UnitRace("player")=="Night Elf" then SCM("Elune, give me power!");else SCM("Light, give me power!");end;
						-- end;
					-- end;
					-- if rnd==3 then 
						-- if GotBuff("Shadowform","player") then SCM("May darkness shelter me!");
						-- else 
							-- if UnitRace("player")=="Night Elf" then SCM("May the light of Elune protect me!");else SCM("May the Light protect me!");end;
						-- end;
					-- end;
					-- if rnd==4 then 
						-- if GotBuff("Shadowform","player") then SCM("Let darkness fall!");
						-- else 
							-- if UnitRace("player")=="Night Elf" then SCM("Let the light of Elune shine!");else SCM("Let the light shine!");end;
						-- end;
					-- end;
				-- end;
				-- AventTimers[171]=AventTimers[171]+5;AventTimers[101]=AventTimers[101]+5;
			-- end;
			if arg1=="AURA_START" and arg2=="Inner Fire" and math.random(1+AventTimers[171]+AventTimers[101]) == 1 then db=1;
				if SOULFUL_CONFIG["language"] =="RU" then 
					if GotBuff("Shadowform","player") then 
						msg={"затеняется резонирующим тьмой.","Свет, дай мне силу!","Да защитит меня свет!","Да прольётся свет!"};
						chat={"emote","say","say","say"};
					else 
						if UnitRace("player")=="Night Elf" then 
							msg={"освещается ярким резонирующим светом.","Элуна, дай мне силу!","Да защитит меня свет Элуны!","Да прольётся свет Элуны!"};
							chat={"emote","say","say","say"};
						else 
							msg={"освещается ярким резонирующим светом.","Тьма, дай мне силу!","Да укроет меня мрак!","Да прольётся мрак!"};
							chat={"emote","say","say","say"};
						end;
					end;
				end;
				if SOULFUL_CONFIG["language"] =="EN" then 
					if GotBuff("Shadowform","player") then 
						msg={"louse is shaded by resonating darkness.","Darkness, give me strength!","May darkness shelter me!","Let darkness fall!"};
						chat={"emote","say","say","say"};
					else 
						if UnitRace("player")=="Night Elf" then 
							msg={"is illuminated by a bright resonating light.","Elune, give me power!","May the light of Elune protect me!","Let the light of Elune shine!"};
							chat={"emote","say","say","say"};
						else 
							msg={"is illuminated by a bright resonating light.","Light, give me power!","May the Light protect me!","Let the light shine!"};
							chat={"emote","say","say","say"};
						end;
					end;
				end;
				rnd=math.random(getn(msg)); SendChatMessage(msg[rnd],chat[rnd]);
				AventTimers[171]=AventTimers[171]+5;AventTimers[101]=AventTimers[101]+5;
			end;
			
			if arg1=="AURA_START" and arg2=="Fade" and math.random(1+AventTimers[172]+AventTimers[101]) == 1 then db=1;
				rnd=math.random(1,6);
				if rnd==1 then DoEmote("shoo",0);end;
				if rnd==2 then DoEmote("fart",0);end;
				if rnd>3 and SOULFUL_CONFIG["language"] =="RU" then 
					if rnd==3 then SCM("тсс.. Меня здесь нет.");end;
					if rnd==4 then SCM("Не бейте меня, у меня семья и дети!");end;
					if UnitExists("party1") then ix=ix+1;end; if UnitExists("party2") then ix=ix+1;end; if UnitExists("party3") then ix=ix+1;end; if UnitExists("party4") then ix=ix+1;end; if ix>0 then ix=math.random(ix);end;temp=GetUnitName("party"..ix);
					if rnd==5 then if ix>0 then SCM("Это "..temp.." назвал тебя дураком, не я.");else DoEmote("shoo",0);end;end;--SCM("Это он назвал тебя дураком, не я.");end;end;
					if rnd==6 then if ix>0 then SCM("Я тут не причём, это "..temp.." тебя пнул.");else DoEmote("shoo",0);end;end;--SCM("Я тут ни при чем, он тебя пнул.");end;end;
				end;
				if rnd>3 and SOULFUL_CONFIG["language"] =="EN" then 
					if rnd==3 then SCM("tss.. I'm not here..");end;
					if rnd==4 then SCM("Don't hit me, I have a family and children!");end;
					if UnitExists("party1") then ix=ix+1;end; if UnitExists("party2") then ix=ix+1;end; if UnitExists("party3") then ix=ix+1;end; if UnitExists("party4") then ix=ix+1;end; if ix>0 then ix=math.random(ix);end;temp=GetUnitName("party"..ix);
					if rnd==5 then if ix>0 then SCM("It was "..temp.." who called you a fool, not me.");else DoEmote("shoo",0);end;end;--SCM("He's the one who called you a fool, not me.");end;end;
					if rnd==6 then if ix>0 then SCM("I don't have anything to do with it, it was "..temp.." who kicked you.");else DoEmote("shoo",0);end;end;--SCM("I don't have anything to do with it, he kicked you.");end;end;
				end;
				AventTimers[172]=AventTimers[172]+5;AventTimers[101]=AventTimers[101]+5;
			end;
			if arg1=="AURA_START" and arg2=="Shadowform" and math.random(1+AventTimers[173]+AventTimers[101]) then db=1;
				AventTimers[173]=AventTimers[173]+5;AventTimers[101]=AventTimers[101]+5;
			end;
			
			if arg1=="AURA_END" and (arg2=="Inner Fire" or arg2=="Fade" or arg2=="Shadowform") then db=1;
			end;
			if arg1=="SPELL_CAST" and arg2=="Lighwell" then db=1;
				-- rnd=math.random(1,2);
				-- if rnd==1 then 
					-- SCM("","emote");
				-- end;
				-- if rnd==2 then 
					-- if math.random()<0.5 then SCM("");
					-- else SCM();
					-- end;
				-- end;
			end;
			
		end;
			
		if UnitClass("player")=="Rogue" then 
			
			if arg1=="AURA_START" and (arg2=="Stealth" or arg2=="Vanish") then db=1;
				if SOULFUL_CONFIG["language"] =="RU" then 
					rnd=math.random(1,4);
					if rnd==1 then SCM("сливается с тенями.","emote");end;
					-- if rnd==2 then if UnitExists("target")and UnitIsEnemy("player","target") then DoEmote("chuckle","target");else DoEmote("chuckle",0);end;end;
					-- if rnd==3 then SCM(COLOR_YELLOW("хе-хе. Я как бы есть, но меня нет."));end;
				end;
				if SOULFUL_CONFIG["language"] =="EN" then 
					rnd=math.random(1,4);
					if rnd==1 then SCM("merges with shadows.","emote");end;
					-- if rnd==2 then if UnitExists("target")and UnitIsEnemy("player","target") then DoEmote("chuckle","target");else DoEmote("chuckle",0);end;end;
					-- if rnd==3 then SCM(COLOR_YELLOW("heh he. I kind of am and I'm not there."));end;
				end;
			end;
			if arg1=="AURA_START" and arg2=="Sprint" then db=1;
				rnd=math.random(1,2);
				if rnd==1 then DoEmote("flee",0);end;
				if rnd==2 and SOULFUL_CONFIG["language"] =="RU" then SCM("стремительно убегает, сверкая пятками.","emote");end;
				if rnd==2 and SOULFUL_CONFIG["language"] =="EN" then SCM("is rapidly running away, only the heels sparkling.","emote");end;
				if rnd==3 and SOULFUL_CONFIG["language"] =="RU" then SCM("Ты меня не догонишь, хе-хе..");end;
				if rnd==3 and SOULFUL_CONFIG["language"] =="EN" then SCM("You won't catch up with me he he..");end;
			end;
			if arg1=="AURA_START" and arg2=="Evasion" then db=1;
				rnd=math.random(1,3);
				if rnd==1 then DoEmote("dance",0);end;
				if rnd==2 and SOULFUL_CONFIG["language"] =="RU" then SCM("делает пируэты и виртуозно уклоняется.","emote");end;
				if rnd==2 and SOULFUL_CONFIG["language"] =="EN" then SCM("does pirouettes and masterfully dodges.","emote");end;
				if rnd==3 and SOULFUL_CONFIG["language"] =="RU" then SCM("Ха-ха.. Попробуй ударить меня, мазила.");end;
				if rnd==3 and SOULFUL_CONFIG["language"] =="EN" then SCM("HaHA.. try to hit me, muff.");end;
			end;
			if arg1=="AURA_END" and arg2=="Evasion" then DoEmote("sigh",0);db=1;
			end;
			if arg1=="AURA_START" and arg2=="Blade Flurry" and math.random(1+AventTimers[151]+AventTimers[151])==1 then db=1;
				AventTimers[151]=AventTimers[151]+300;AventTimers[101]=AventTimers[101]+5;
				rnd=math.random(1,8);
				if rnd==1 then DoEmote("roar",0);end;
				if rnd==2 then 
					if SOULFUL_CONFIG["language"] =="RU" then SCM("виртуозно выполняет движения своим оружием.","emote");end;
					if SOULFUL_CONFIG["language"] =="EN" then SCM("makes masterful movements with his weapons.","emote");end;
				end;
				if rnd==3 then 
					if SOULFUL_CONFIG["language"] =="RU" then SCM("Я покромсаю вас всех!");end;
					if SOULFUL_CONFIG["language"] =="EN" then SCM("I'll cut you all up!");end;
				end;
				if rnd==4 then 
					if SOULFUL_CONFIG["language"] =="RU" then 
						if UnitRace("player")=="Human" then SCM("Сейчас я ваши морды разобью!");end;
						if UnitRace("player")=="NightElf" then SCM("Элуна дай мне силу!");end;
						if UnitRace("player")=="Dwarf" then SCM("Отведай Громобоя!");end; --За Каз Модан
						if UnitRace("player")=="Gnome" then SCM("Запускаю протокол зачистки!");end; --Отведуй ярости гнома! --ГНОМОБАНДА!
						if UnitRace("player")=="High Elf" then SCM("За Кель'Талас!");end;
						
						if UnitRace("player")=="Orc" then SCM("Кровь и гром!");end;
						if UnitRace("player")=="Troll" then SCM("Твой Лоа уже не поможет!");end;
						if UnitRace("player")=="Tauren" then SCM("Отведай мооой гнев!");end;
						if UnitRace("player")=="Undead" then SCM("Встретимся на том свете!");end;
						if UnitRace("player")=="Goblin" then SCM("Для вас двойная цена!");end;
					end;
					if SOULFUL_CONFIG["language"] =="EN" then 
						if UnitRace("player")=="Human" then SCM("Now I will break your faces!");end;
						if UnitRace("player")=="NightElf" then SCM("Elune give me strength!");end;
						if UnitRace("player")=="Dwarf" then SCM("Taste the Thunderbolt!");end; --For Khaz Modan!
						if UnitRace("player")=="Gnome" then SCM("Launching the cleanup protocol!");end; --Taste the rage of the Gnome! --GNOMEGANg!
						if UnitRace("player")=="High Elf" then SCM("Bandu Thoribas!");end; --For Kel'Talas!
						
						if UnitRace("player")=="Orc" then SCM("Blood and thunder!");end;
						if UnitRace("player")=="Troll" then SCM("Your Loa can't help you anymore!");end;
						if UnitRace("player")=="Tauren" then SCM("Taste moo wrath!");end;
						if UnitRace("player")=="Undead" then SCM("I'll see you in the beyond the veil!");end;
						if UnitRace("player")=="Goblin" then SCM("Double the price for you!");end;
					end;
				end;
			end;
			if arg1=="AURA_START" and arg2=="Ghostly Strike" then db=1;
				rnd=math.random(1,6);
				-- if rnd==1 then DoEmote("dance",0);end;
				if rnd==2 then 
					if SOULFUL_CONFIG["language"] =="RU" then SCM("делает сальто назад.","emote");end;
					if SOULFUL_CONFIG["language"] =="EN" then SCM("does a backflip.","emote");end;
				-- if rnd==3 then 
					-- if SOULFUL_CONFIG["language"] =="RU" then SCM("Хопа..");end;
					-- if SOULFUL_CONFIG["language"] =="EN" then SCM("Hopa..");
				end;
			end;
			if arg1=="AURA_END" and (arg2=="Stealth" or arg2=="Vanish" or arg2=="Sprint" or arg2=="Blade Flurry" or arg2=="Ghostly Strike") then db=1;
			end;
			
		end;
		
		if UnitClass("player")=="Druid" then 
			
			if arg1=="AURA_START" and math.random(1+AventTimers[161]+AventTimers[161])==1 and (arg2=="Cat Form" or arg2=="Bear Form") then db=1;
				-- if math.random(1,10)==1 then DoEmote("bite",0); end;
				DoEmote("bite",0);
				AventTimers[161]=AventTimers[161]+300;AventTimers[101]=AventTimers[101]+5;
			end;
			if arg1=="AURA_START" and arg2=="Prowl" then db=1;
				
			end;
			if arg1=="AURA_START" and arg2=="Travel Form" then db=1;
				
			end;
			if arg1=="AURA_START" and arg2=="Aquatic Form" then db=1;
				
			end;
			if arg1=="AURA_END" and (arg2=="Cat Form" or arg2=="Bear Form" or arg2=="Travel Form" or arg2=="Aquatic Form" or arg2=="Prowl") then db=1;
				
			end;
			if arg1=="AURA_START" and (arg2=="Tiger's Fury") then db=1;
				-- DoEmote("roar",0);
			end;
			if arg1=="AURA_END" and arg2=="Tiger's Fury" then db=1;end;
			if arg1=="AURA_START" and (arg2=="Blood Frenzy") then db=1;
				-- DoEmote("roar",0);
			end;
			if arg1=="AURA_END" and arg2=="Blood Frenzy" then db=1;end;
			if arg1=="AURA_START" and (arg2=="Innervate") then db=1;
				rnd=math.random(1,2);
				if rnd==1 then DoEmote("calm",0);end;
				if rnd==2 then 
					if SOULFUL_CONFIG["language"] =="RU" then SCM("входит в состояние транса и восполняет своё энергию.","emote");end;
					if SOULFUL_CONFIG["language"] =="EN" then SCM("enters a trance state and replenishes its energy.","emote");end;
				end;
			end;
			if arg1=="AURA_END" and arg2=="Innervate" then db=1;end;
			-- if arg1=="AURA_START" and (arg2=="Tranquility") then db=1;
				-- rnd=math.random(1,2);
				-- if rnd==1 then DoEmote("pray",0);end;
				-- if rnd==2 then 
					-- if SOULFUL_CONFIG["language"] =="RU" then SCM("взывает к силам природы, успакаивает и исцеляет всех вокруг.","emote");end;
					-- if SOULFUL_CONFIG["language"] =="EN" then SCM("appeals to the forces of nature, soothes and heals everyone around him.","emote");end;
				-- end;
			-- end;
			if arg1=="AURA_START" and arg2=="Clearcasting" then db=1;
				if SOULFUL_CONFIG["roar"] == true then DoEmote("roar",0); end;
			end;
			if arg1=="AURA_END" and arg2=="Clearcasting" then db=1;end;
			
		end;
		
		if UnitClass("player")=="Hunter" then 
			
			if arg1=="SPELL_CAST" and arg2=="Call Pet" then db=1;
				rnd=math.random(2,2);
				-- if rnd==1 then Up_Array("Call Pet", "pet", "Call Pet", "pet");end;
				-- DoEmote("pat","pet");
				if SOULFUL_CONFIG["language"] =="RU" then 
					-- if rnd==1 then SCM("Ко мне, "..GetUnitName("pet")..". Хорошая "..UnitCreatureFamily("pet"));end;
					if rnd==2 then SCM("зовёт своего верного спутника.","emote");end;
				end;
				if SOULFUL_CONFIG["language"] =="EN" then 
					-- if rnd==1 then SCM("Come to me "..GetUnitName("pet")..". Good "..UnitCreatureFamily("pet"));end;
					if rnd==2 then SCM("calls out to his faithful companion.","emote");end;
				end;
			end;
			if arg1=="AURA_END" and arg2==""  then db=1;
				
			end;
			if arg1=="AURA_START" and arg2=="Deterrence" then db=1;
				DoEmote("dance",0);
				-- rnd=math.random(1,2);
				-- if rnd==1 then DoEmote("dance",0);end;
				-- if rnd==2 then DoEmote("shimmy",0);end;
			end;
			if arg1=="AURA_END" and arg2=="Deterrence" then db=1;
				DoEmote("stand",0);
			end;
			
			if arg1=="AURA_START" and arg2=="Eagle Eye" then db=1;
				rnd=math.random(1,3);
				if rnd==1 then DoEmote("stare",0);end;
				if rnd==2 then DoEmote("peer",0);end;
				if SOULFUL_CONFIG["language"] =="RU" then 
					-- if rnd==2 then SCM("делает сальто назад.","emote");end;
					if rnd==3 then SCM("Такс.. посмотрим..");end;
				end;
				if SOULFUL_CONFIG["language"] =="EN" then 
					-- if rnd==2 then SCM("does a backflip.","emote");end;
					if rnd==3 then SCM("So with .. let's see ..");end;
				end;
				--SCM("Такс.. посмотрим..");
			end;
			if arg1=="AURA_END" and arg2=="Eagle Eye" then db=1;end;
			
			if arg1=="AURA_START" and (arg2=="Quick Strikes" or arg2=="Rapid Fire")then db=1;
				rnd=math.random(1+2,5/factor);
				-- if rnd==1 then DoEmote("train",0);end;
				if rnd==2 then DoEmote("snarl",0);end;--roar
				if SOULFUL_CONFIG["language"] =="RU" then 
					if rnd==3 then SCM("впадает в неистовство.","emote");end;
				end;
				if SOULFUL_CONFIG["language"] =="EN" then 
					if rnd==3 then SCM("goes into a frenzy.","emote");end;
				end;
			end;
			if arg1=="AURA_END" and (arg2=="Quick Strikes" or arg2=="Rapid Fire") then db=1;end;
			
			if arg1=="AURA_START" and arg2=="Aspect of the Wolf" then db=1;
				DoEmote("growl",0);
			end;
			if arg1=="AURA_END" and arg2=="Aspect of the Wolf" then db=1;end;
			
			if arg1=="AURA_START" and (arg2=="Aspect of the Hawk" or arg2=="Aspect of the Monkey" or arg2=="Aspect of the Cheetah" or arg2=="Aspect of the Beast") then db=1;
				
			end;
			if arg1=="AURA_END" and (arg2=="Aspect of the Hawk" or arg2=="Aspect of the Monkey" or arg2=="Aspect of the Cheetah" or arg2=="Aspect of the Beast") then db=1;
				
			end;
			
			if arg1=="AURA_START" and arg2=="Tame Beast" then db=1;
				
			end;
			if arg1=="AURA_END" and arg2=="Aspect of the Wolf" then db=1;end;
			
			if arg1=="SPELL_ACTIVE" and (arg2=="Mongoose Bite" or arg2=="Counterattack") then db=1;end;
			
			-- if GotBuff("Ability_Hunter_MendPet","pet") then db=1;
				-- if SOULFUL_CONFIG["language"] =="RU" then 
					-- rnd=math.random(1,2);
					-- if rnd==1 then SCM("гладит "..GetUnitName("pet")..".".."Молодец "..UnitCreatureFamily("unit"),"emote");end;
					-- if rnd==2 then SCM("Живи "..UnitCreatureFamily("unit")..", живи.");end;
				-- end;
				-- if SOULFUL_CONFIG["language"] =="EN" then 
					-- rnd=math.random(1,5);
					-- if rnd==1 then SCM("petting a "..GetUnitName("pet")..".".."Good "..UnitCreatureFamily("pet")..".","emote");end;
					-- if rnd==2 then SCM("Live  "..UnitCreatureFamily("unit")..", live.");end;
				-- end;
				-- AventTimers[191]=AventTimers[191]+60;AventTimers[101]=AventTimers[101]+30;
			-- end;
			
		end;
		
		if UnitClass("player")=="Paladin" then 
			if arg1=="AURA_START" and (arg2=="Seal of the Crusader" or arg2=="Seal of the Command") then db=1;
				-- for ix=1,99 do 
					-- if IsAttackAction(ix)then if not IsCurrentAction(ix) then DoEmote("growl",0);end;end;
				-- end;
			end;
			if arg1=="AURA_END" and (arg2=="Seal of the Crusader" or arg2=="Seal of the Command") then db=1;end;
			
			if arg1=="AURA_START" and arg2=="Seal of Righteousness" then db=1;
				-- for ix=1,96 do 
					-- if IsAttackAction(ix)then if not IsCurrentAction(ix) then 
						-- rnd=math.random(2);
						-- if rnd==1 then DoEmote("raise",0);end;
						-- if rnd==2 then 
							-- if SOULFUL_CONFIG["language"] =="RU" then SCM("концентрирует свет в своей руке.","emote");end;
							-- if SOULFUL_CONFIG["language"] =="EN" then SCM("concentrates the light in hand.","emote");end;
						-- end;
					-- end;end;
				-- end;
			end;
			if arg1=="AURA_END" and arg2=="Seal of Righteousness" then db=1;end;
			
			if arg1=="AURA_START" and arg2=="Summon Warhorse" then db=1;end;
			if arg1=="AURA_END" and arg2=="Summon Warhorse" then db=1;end;
		
			if arg1=="AURA_START" and arg2=="Divine Shield" then db=1;end;
			if arg1=="AURA_END" and arg2=="Divine Shield" then db=1;end;
			
			-- if arg1=="AURA_START" and arg2=="Blessing of Protection" then db=1;end;
			-- if arg1=="AURA_END" and arg2=="Blessing of Protection" then db=1;end;
		end;
		
		if UnitClass("player")=="Mage" then 
			if arg1=="AURA_START" and arg2=="Blink" then db=1;
				rnd=math.random(9);
				if rnd==1 then SCM("Blink","say");end;
				-- if rnd>=2 and rnd<=3 then DoEmote("charge",0);end;
				if rnd>=4 and rnd<=9 then 
					if SOULFUL_CONFIG["language"] =="RU" then SCM("мерцает.","emote");end;
					if SOULFUL_CONFIG["language"] =="EN" then SCM("flickers.","emote");end;
				end;
			end;
			if arg1=="AURA_END" and arg2=="Blink" then db=1;end;
			
		end;
		
		if UnitClass("player")=="Warrior" then 
			if arg1=="RAGE" then
				local _,_,_,_,IC=GetTalentInfo(1,4);IC=IC*5;
				local _,_,_,_,IB=GetTalentInfo(3,1);
				if (tonumber(arg2)==9+IC or tonumber(arg2)==12+IC or (tonumber(arg2)==15+IC and IB~=2)) then db=1;
					rnd=math.random(10);
					if rnd>=1 and rnd<=1 then DoEmote("Train",0);end;
					if rnd>=2 and rnd<=10 then DoEmote("Charge",0);end;
				end;
			end;
			
			if arg1=="AURA_START" and strfind(arg2,"Bloodrage") then db=1;
				rnd=math.random(6);
				if rnd>=1 and rnd<=2 then DoEmote("snarl",0);end;
				if rnd>=3 and rnd<=6 then DoEmote("snarl",0);end;
			end;
			if arg1=="AURA_END" and strfind(arg2,"Bloodrage") then db=1;end;
			
			if arg1=="AURA_START" and strfind(arg2,"Berserke") then db=1;
				-- rnd=math.random(6);
				-- if rnd>=1 and rnd<=2 then DoEmote("Roar",0);end;
				-- if rnd>=3 and rnd<=6 then DoEmote("Roar",0);end;
			end;
			if arg1=="AURA_END" and strfind(arg2,"Berserker") then db=1;end;
			
			if arg1=="AURA_START" and strfind(arg2,"Battle Shout") then db=1;
				rnd=math.random(6);
				if rnd>=1 and rnd<=2 then DoEmote("Growl",0);end;
				if rnd>=3 and rnd<=6 then DoEmote("Growl",0);end;
			end;
			if arg1=="AURA_END" and strfind(arg2,"Battle Shout") then db=1;end;
			
			if arg1=="AURA_START" and strfind(arg2,"Berserker Rage") then db=1;
				-- rnd=math.random(6);
				-- if rnd>=1 and rnd<=2 then DoEmote("Roar",0);end;
				-- if rnd>=3 and rnd<=6 then DoEmote("Roar",0);end;
			end;
			if arg1=="AURA_END" and strfind(arg2,"Berserker Rage") then db=1;end;
			
			if arg1=="AURA_START" and strfind(arg2,"Flurry") then db=1;
				-- rnd=math.random(6);
				-- if rnd>=1 and rnd<=2 then DoEmote("Roar",0);end;
				-- if rnd>=3 and rnd<=6 then DoEmote("Roar",0);end;
			end;
			if arg1=="AURA_END" and strfind(arg2,"Flurry") then db=1;end;
			
			if arg1=="AURA_START" and strfind(arg2,"Last Stand") then db=1;
				rnd=math.random(6);
				if rnd>=1 and rnd<=2 then DoEmote("Roar",0);end;
				if rnd>=3 and rnd<=6 then DoEmote("Roar",0);end;
			end;
			if arg1=="AURA_END" and strfind(arg2,"Last Stand") then db=1;end;
			
			if arg1=="AURA_START_HARMFUL" and strfind(arg2,"Death Wish") then db=1;
				rnd=math.random(6);
				if rnd>=1 and rnd<=2 then DoEmote("Roar",0);end;
				if rnd>=3 and rnd<=6 then DoEmote("Roar",0);end;
			end;
			if arg1=="AURA_END_HARMFUL" and strfind(arg2,"Death Wish") then db=1;end;
			
		end;
		
		if arg1=="AURA_START" and arg2=="Evocation" then db=1;
			if SOULFUL_CONFIG["language"] =="RU" then 
				rnd=math.random(2,4);
				if rnd==1 then DoEmote("roar",0);end;
				if rnd==2 then SCM("закручивает вокруг себя вихрь, собирая энергию из окружающей среды.","emote");end;
				if rnd==3 then SCM("Трах-тибидох");end;
				if rnd==4 then SCM("Кручу верчу, наеб@ть всех хочу.");end;
			end;
			if SOULFUL_CONFIG["language"] =="EN" then 
				rnd=math.random(2,4);
				if rnd==1 then DoEmote("roar",0);end;
				-- if rnd==3 then SCM("Bang-tibidoh.");end;
				if rnd>=2 and rnd<=4 then SCM("twists a whirlwind around her, collecting energy from the environment.","emote");end;
			end;
		end;
		if arg1=="AURA_END" and arg2=="Evocation" then db=1;
			-- DoEmote("raise",0);
		end;
		
		end;--end class
		
	end;
	
	
	-- SendChatMessage("\124caa88aa88".."Darkest shadows, shelter me.".."\124r","SAY");
	if AFK and SOULFUL_CONFIG["reaction"] and ((event == "CHAT_MSG_TEXT_EMOTE" and (strfind(arg1," you ") or strfind(arg1," you."))) or (event == "CHAT_MSG_SAY" and strfind(arg1,GetUnitName("player")))) then db=1;
		rnd=math.random(0,9);
		if rnd==0 then Up_Array("afkemote", arg2, "stare", 0)end;
		if rnd==1 then Up_Array("afkemote", arg2, "drool", 0)end;
		if rnd==2 then Up_Array("afkemote", arg2, "nosepick", 0)end;
		if rnd==3 then Up_Array("afkemote", arg2, "silly", 0)end;
		if rnd==4 then Up_Array("afkemote", arg2, "talkq", 0)end;
		if rnd==5 then 
			if SOULFUL_CONFIG["language"]=="RU" then Up_Array("afkemote", arg2, "afksay", arg2, "Извини, "..arg2..", но я сейчас не могу ответить тебе, так как тот, кто контролирует меня, сейчас отсутствует.") end;
			if SOULFUL_CONFIG["language"]=="EN" then Up_Array("afkemote", arg2, "afksay", arg2, "Sorry, "..arg2..", but I can't answer you right now, as whoever controls me is not there right now.") end;
			-- Up_Array(arg1, arg2, "afksay", arg2, "Sorry, "..arg2..", but I can't answer you right now, as whoever controls me is not there right now.") --Извини, arg2, но я сейчас не могу ответить тебе, так как тот, кто контролирует меня, сейчас отсутствует.
		end;
		if rnd==6 then 
			if UnitSex("player")==2 then sex="she";end; if UnitSex("player")==3 then sex="he";end;
			Up_Array("afkemote", arg2, "afkemote", arg2, "cannot answer "..arg2..", as "..sex.." is engaged in something important.") --не может ответить arg2, так как он/она занимается чем то важным.
		end;
		if rnd==7 then 
			Up_Array("afkemote", arg2, "afkemote", arg2, "does not pay attention to "..arg2) --не обращает внимания на arg2
		end;
		if rnd==8 then 
			Up_Array("afkemote", arg2, "afkemote", arg2, "pretends not to notice "..arg2) --делает вид, что не замечает arg2
		end;
		if rnd==9 then 
			Up_Array("afkemote", arg2, "afkemote", arg2, "turns away from "..arg2.." and continues to go about his business.") --отворачивается от arg2 и продолжает заниматься своими делами.
		end;
	end;
	
	--QUESTION-- /script local msg=Questions()SendChatMessage(msg[1],"SAY")
	if not AFK and strfind(arg1,"questions you.") then 
		msg=Questions();local says="";
		if SOULFUL_CONFIG["language"] =="RU" then says="говорит: ";end;
		if SOULFUL_CONFIG["language"] =="EN" then says="says: ";end;
		if msg[1] then Up_Array(0, 0, "emote", arg2, says..msg[1]);end;
		if msg[2] then Up_Array(0, 0, "emote", arg2, says..msg[2]);end;
		if msg[3] then Up_Array(0, 0, "emote", arg2, says..msg[3]);end;
		if msg[4] then Up_Array(0, 0, "emote", arg2, says..msg[4]);end;
	end;
	
	--AUTONUTOR--
	if (AFK or SOULFUL_CONFIG["autonutor_rp"]) and event=="CHAT_MSG_WHISPER" and SOULFUL_CONFIG["autonutor"] then Autonutor(arg1, arg2); end;
	--Calculator--
	if not AFK and (event=="CHAT_MSG_SAY" or event=="CHAT_MSG_WHISPER") and SOULFUL_CONFIG["calculator"] then Calculator(arg1, arg2, event); end;
	
	if not AFK and (event=="CHAT_MSG_SAY" or event=="CHAT_MSG_WHISPER") and SOULFUL_CONFIG["roll"]>=1 then RollEntry (arg1, arg2, event); end;
	if not AFK and (event=="CHAT_MSG_SAY" or event=="CHAT_MSG_WHISPER") and SOULFUL_CONFIG["roll"]==-1 then RollSay(arg1, arg2, event); end;
	
	if event=="CHAT_MSG_SAY" and strfind(arg1,"start roll") and SOULFUL_CONFIG["roll"]==-1 then 
		local number=string.gsub(arg1,"[^%d]","");
		if tonumber(number) then 
			number=tonumber(number);
		else 
			number=30;
		end;
		SOULFUL_CONFIG["roll"]=number;
		if SOULFUL_CONFIG["language"] == "RU" then  SCM(COLOR_HUNTER("Запись бросков включена: ")..COLOR_GREEN2(SOULFUL_CONFIG["roll"])..COLOR_HUNTER(" секунд. ")..COLOR_HUNTER("Сделайте roll или rnd для участия."),"say");end;
		if SOULFUL_CONFIG["language"] == "EN" then  SCM(COLOR_HUNTER("Recording of rolls is on: ")..COLOR_GREEN2(SOULFUL_CONFIG["roll"])..COLOR_HUNTER(" seconds. ")..COLOR_HUNTER("Do a roll or rnd to participate."),"say");end;
		RollReset();
	end;
	
	--COMMANDS--
	local SFcmd=string.lower(arg1);
	if (event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_SAY") and string.find(SFcmd,"soulful") then 
		SFcmd=string.gsub(SFcmd,"(soulful)(%s*)","");
		if string.find(SFcmd,"reset") then Soulful_Reset_cfg();end;
		if string.find(SFcmd,"reaction") then SOULFUL_CONFIG["reaction"] = not SOULFUL_CONFIG["reaction"];end;
		if string.find(SFcmd,"action") and not string.find(SFcmd,"reaction") then 
			SFcmd=string.gsub(SFcmd,"(action)(%s*)","");
			if tonumber(SFcmd)==nil then 
				SOULFUL_CONFIG["action"] = not SOULFUL_CONFIG["action"];
			else 
				SOULFUL_CONFIG["action factor"] = tonumber(SFcmd);
			end;
		end;
		if string.find(SFcmd,"language") then 
			SFcmd=string.gsub(SFcmd,"(language)(%s*)","");
			if SFcmd == "ru" then SOULFUL_CONFIG["language"] = "RU";end;
			if SFcmd == "en" then SOULFUL_CONFIG["language"] = "EN";end;
			if SFcmd == "auto" then SOULFUL_CONFIG["language auto"] = not SOULFUL_CONFIG["language auto"];end;
		end;
		if string.find(SFcmd,"chicken") then DoEmote("chicken");end;
	end;
	
	-- debug
	if event == "CHAT_MSG_SAY" and SOULFUL_CONFIG["action"] then db=1; end;
	if event == "CHAT_MSG_PARTY " and SOULFUL_CONFIG["action"] then db=1; end;
		
	-- UNIT_COMBAT
	-- Fired when an npc or player participates in combat and takes damage
	-- arg1	-- the UnitID of the entity
	-- arg2	-- Action,Damage,etc (e.g. HEAL, DODGE, BLOCK, WOUND, MISS, PARRY, RESIST, ...)
	-- arg3	-- Critical/Glancing indicator (e.g. CRITICAL, CRUSHING, GLANCING)
	-- arg4	-- The numeric damage
	-- -- arg5	-- Damage type in numeric value (1 - physical; 2 - holy; 4 - fire; 8 - nature; 16 - frost; 32 - shadow; 64 - arcane)
	-- arg5	-- Damage type in numeric value (0 - physical(hit,lose); ? - holy; 2 - fire; ? - nature; 16 - frost; ? - shadow; ? - arcane; 3 - nature(disease))
	if event == "UNIT_COMBAT" and SOULFUL_CONFIG["action"] then 
		
		if arg1=="player" or arg1=="pet" 
		or arg1=="party1" or arg1=="party2" or arg1=="party3" or arg1=="party4" or arg1=="party5" 
		or arg1=="raid1" or arg1=="raid2" or arg1=="raid3" or arg1=="raid4" or arg1=="raid5" 
		or arg1=="partypet1" or arg1=="partypet2" or arg1=="partypet3" or arg1=="partypet4" or arg1=="partypet5" 
		or arg1=="target" or arg1=="mouseover" then 
			if arg2=="WOUND" or arg2=="HEAL" or arg2=="MISS" or arg2=="DODGE" or arg2=="DODGE" or arg2=="PARRY" or arg2=="RESIST" or arg3=="ABSORB" or arg3=="SPELL_ABSORBED" then 
				db=1;
			end;
		end;
	end;
	-- COMBAT_TEXT_UPDATE
	-- arg1 = Combat message type. Known values include "DAMAGE", "SPELL_DAMAGE", "DAMAGE_CRIT", "HEAL", "PERIODIC_HEAL", "HEAL_CRIT",
	--        "MISS", "DODGE", "PARRY", "BLOCK", "RESIST", "SPELL_RESISTED", "ABSORB", "SPELL_ABSORBED", "MANA", "ENERGY", "RAGE", "FOCUS",
	--        "SPELL_ACTIVE", "COMBO_POINTS", "AURA_START", "AURA_END", "AURA_START_HARMFUL", "AURA_END_HARMFUL", "HONOR_GAINED", and "FACTION".
	-- arg2 = For damage, power gain and honor gains, this is the amount taken/gained. For heals, this is the healer name. 
	--        For auras, the aura name. For block/resist/absorb messages where arg3 is not nil (indicating a partial block/resist/absorb) 
	--        this is the amount taken. For faction gain, this is the faction name. For the SPELL_ACTIVE message, the name of the spell 
	--        (abilities like Overpower and Riposte becoming active will trigger this message).
	-- arg3 = For heals, the amount healed. For block/resist/absorb messages, this is the amount blocked/resisted/absorbed, 
	--        or nil if all damage was avoided. For faction gain, the amount of reputation gained.
	if event == "COMBAT_TEXT_UPDATE" and SOULFUL_CONFIG["action"] then 
		
		if arg1=="DAMAGE" or arg1=="MISS" or arg1=="DODGE" or arg1=="DODGE" or arg1=="PARRY" or arg1=="RESIST" or arg3=="ABSORB" or arg3=="SPELL_ABSORBED" or arg1=="MANA" or arg1=="HEAL" then 
			--db=1;
		end;
	end;
	if SOULFUL_CONFIG["debug"] == 1 or (SOULFUL_CONFIG["debug"] >= 2 and db~=1) then 
		local ta1,ta2,ta3,ta4,ta5="","","","","";
		if arg1 then ta1=" | arg1="..arg1;end; if arg2 then ta2=" | arg2="..arg2;end; if arg3 then ta3=" | arg3="..arg3;end; if arg4 then ta4=" | arg4="..arg4;end; if arg5 then ta5=" | arg5="..arg5;end;
		DEFAULT_CHAT_FRAME:AddMessage("event="..event..ta1..ta2..ta3..ta4..ta5)
	end;
	
	
end;

function Autonutor(arg1, arg2, event) --arg1 = Текст / arg2 = Имя (name)
	local msg,lang,ix="","",0;
	if strfind(arg1,"а") or strfind(arg1,"б") or strfind(arg1,"в") or strfind(arg1,"г") or strfind(arg1,"д") or strfind(arg1,"е") or strfind(arg1,"ё") or strfind(arg1,"ж") or strfind(arg1,"з") or strfind(arg1,"и") or strfind(arg1,"к") 
	or strfind(arg1,"л") or strfind(arg1,"м") or strfind(arg1,"н") or strfind(arg1,"о") or strfind(arg1,"п") or strfind(arg1,"р") or strfind(arg1,"с") or strfind(arg1,"т") or strfind(arg1,"у") or strfind(arg1,"ф") or strfind(arg1,"х") 
	or strfind(arg1,"ц") or strfind(arg1,"ч") or strfind(arg1,"ш") or strfind(arg1,"щ") or strfind(arg1,"ъ") or strfind(arg1,"ы") or strfind(arg1,"ь")or strfind(arg1,"э")or strfind(arg1,"ю")or strfind(arg1,"я")
	then 
		lang="ru";
	end;
	
	if strfind(arg1,"a") or strfind(arg1,"b") or strfind(arg1,"c") or strfind(arg1,"d") or strfind(arg1,"e") or strfind(arg1,"f") or strfind(arg1,"g") or strfind(arg1,"h") or strfind(arg1,"i") or strfind(arg1,"j") or strfind(arg1,"k") 
	or strfind(arg1,"l") or strfind(arg1,"m") or strfind(arg1,"n") or strfind(arg1,"o") or strfind(arg1,"p") or strfind(arg1,"q") or strfind(arg1,"r") or strfind(arg1,"s") or strfind(arg1,"t") or strfind(arg1,"u") or strfind(arg1,"v") 
	or strfind(arg1,"w") or strfind(arg1,"x") or strfind(arg1,"y") or strfind(arg1,"z") 
	then 
		lang="en";
	end;
	
	if not strfind(GetUnitName("player"),arg2) then 
		-- SendChatMessage(msg,"WHISPER","Common",arg2);
		--msg="Вызываемый абонент недоступен для телепатии. Если ты хочешь связаться с ним, то воспользуйтесь почтой или встретьтесь с ним лично."
		if lang=="ru" and not SOULFUL_CONFIG["autonutor_rp"] then Up_Array("afkwhisper", arg2, "afkwhisper", arg2, "Извини "..arg2..", но я сейчас не могу ответить тебе, так как тот, кто контролирует меня, сейчас отсутствует. Оставь сообщение после сигнала.<Бип!>");end;
		if lang=="ru" and SOULFUL_CONFIG["autonutor_rp"] then Up_Array("afkwhisper", arg2, "afkwhisper", arg2, "Извини "..arg2..", но я сейчас не могу ответить тебе, так как у меня отключен шепот. Оставь сообщение после сигнала.<Бип!>");end;
		--msg="The callee is not available for telepathy. If you want to contact him, then use the mail or meet him in person."
		if lang=="en" and not SOULFUL_CONFIG["autonutor_rp"] then Up_Array("afkwhisper", arg2, "afkwhisper", arg2, "Sorry "..arg2..", but I can't answer you right now, as whoever controls me is not there right now. Leave message after the beep. <<Beep!>>");end;
		if lang=="en" and SOULFUL_CONFIG["autonutor_rp"] then Up_Array("afkwhisper", arg2, "afkwhisper", arg2, "Sorry "..arg2..", but I can't answer you right now because my whisper is turned off. Leave a message after the beep.<Beep!>");end;
	end;
	
	if SOULFUL_CONFIG["autonutor_info"]==1 then 
		if lang=="ru" then Info_Print("|Hplayer:"..arg2.."|h["..arg2.."]|h|r: прислал тебе сообщение.");end;
		if lang=="en" then Info_Print("|Hplayer:"..arg2.."|h["..arg2.."]|h|r: sent you a message.");end;
	end;
	if SOULFUL_CONFIG["autonutor_info"]==2 then 
		if lang=="ru" then Info_Print("|Hplayer:"..arg2.."|h["..arg2.."]|h|r: "..arg1,0,0.2,0.4);end;
		if lang=="en" then Info_Print("|Hplayer:"..arg2.."|h["..arg2.."]|h|r: "..arg1,0,0.2,0.4);end;
	end;
	
	if SOULFUL_CONFIG["autonutor_save"] or SOULFUL_CONFIG["autonutor_rp"] then 
		for ix=1,999 do 
			if not RECEIVED_MESSAGES[ix] then 
				RECEIVED_MESSAGES[ix]="|Hplayer:"..arg2.."|h["..arg2.."]|h|r: "..arg1;break;
			end;
		end;
	end;
end;

function Calculator(arg1, arg2, event)
	if not string.find(arg1, "[%a%s%=]") then 
		local stemp=string.gsub(arg1,"[^1^2^3^4^5^6^7^8^9^0^%-^%+^%*^%/^%.^%(^%)^%^^%%]","") ;
		if string.find(stemp, "(%d[%-%+%*%/%^%^^%%]%d)") then 
			local func = assert(loadstring("return " .. stemp));
			if tonumber(func()) then 
				if event=="CHAT_MSG_SAY" then Up_Array(0,0,"say",arg2,stemp.."="..func()); end;
				if event=="CHAT_MSG_WHISPER" then Up_Array(0,0,"whisper",arg2,stemp.."="..func());
				end;
			end;
		end;
	end;
end;

function RollSay(arg1, arg2, event)
	arg1=string.lower(arg1);
	-- if not string.find(arg1, "rolls") and (string.find(arg1, "rnd") or string.find(arg1, "roll")) then 
	if not string.find(arg1, "rolls") and (arg1=="rnd" or arg1=="roll") then 
		local rnd=math.random (0, 100);
		Up_Array(0,0,"say",arg2,arg2.." rolls "..rnd);
	end;
end;
local RollName = {};
local RollNummber = {};
function RollEntry (arg1, arg2, event)
	local ix=0;local iy=0; arg1=string.lower(arg1);
	-- if not string.find(arg1, "rolls") and (string.find(arg1, "rnd") or string.find(arg1, "roll")) then 
	if not string.find(arg1, "rolls") and (arg1=="rnd" or arg1=="roll") then 
		ix=0;
		while(ix < 100) do 
			if arg2 == RollName[ix] then 
				Up_Array(0,0,"say",arg2,COLOR_HUNTER(arg2)..COLOR_HUNTER(" has already made the rolls."));
				break;
			else 
				ix=ix+1;
			end;
		end;
		if ix == 100 then 
			ix=0;
			while(ix < 100) do 
				if not RollName[ix] then 
					RollName[ix]=arg2;
					RollNummber[ix]=math.random (0, 100);
					Up_Array(0,0,"say",arg2,COLOR_HUNTER(arg2)..COLOR_HUNTER(" rolls ")..COLOR_HUNTER(RollNummber[ix]));
					break;
				else 
					ix=ix+1;
				end;
			end;
		end;
	end;
end;
function RollReset()
	local ix=0;
	while(ix<100) do 
		RollName[ix]=nil;
		RollNummber[ix]=nil;
		ix=ix+1;
	end;
end;
function RollEnd()
	local MemRoll=0;
	local WinName;
	local WinRoll;
	local ix=0;
	while(ix<100) do 
		if RollName[ix] then 
			if RollNummber[ix] > MemRoll then MemRoll=RollNummber[ix]; WinName=RollName[ix]; WinRoll=RollNummber[ix]; end;
			-- if RollNummber[ix] > MemRoll then MemRoll=RollNummber[ix]; WinRoll=ix; end;
			ix=ix+1;
		else break;
		end;
	end;
	if WinName and WinRoll then SCM(COLOR_HUNTER(WinName)..COLOR_HUNTER(" wins with a score of ")..COLOR_HUNTER(WinRoll),"say");
	else 
		SCM(COLOR_HUNTER("No winner."),"say");
	end;
	-- if WinRoll then SCM(RollName[ix].." wins with a score of "..RollNummber[ix],"say");end;
end;




local function eventHandler(self, event, ...)
    if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
        local timestamp, eventType, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName, spellSchool = CombatLogGetCurrentEventInfo()
        -- Debug the combat log event
        print('Player ' .. sourceName .. ' casted ' .. spellName .. ' (id: ' .. spellId .. ', school: ' .. spellSchool .. ') on ' .. destName .. ' triggered by ' .. eventType)
        
        if spells[eventType] and spells[eventType][spellId] and sourceGUID == UnitGUID('player') then
            print('Success!')
            -- Handle Aura buff
        end
    end
end
 
local eventFrame = CreateFrame('Frame')
 
eventFrame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
 
eventFrame:SetScript('OnEvent', eventHandler)
