local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			   npcHandler:onCreatureAppear(cid)		    	    end
function onCreatureDisappear(cid)		   npcHandler:onCreatureDisappear(cid)			    end
function onCreatureSay(cid, type, msg)	   npcHandler:onCreatureSay(cid, type, msg)		    end
function onThink()				           npcHandler:onThink()				            	end

local voices = { {text = 'Custom voice.'} }
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end
    local player = Player(cid)
	-- join
    if msgcontains(msg, "join") then
        if player:getStorageValue(Storage.ExplorerSociety.JoiningtheExplorers) < 1 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) < 1 then
            npcHandler:say("join ok?", cid)
            npcHandler.topic[cid] = 1
        end
    elseif msgcontains(msg, "yes") then
        if npcHandler.topic[cid] == 1 then
            npcHandler:say({
                "text ...",
                "text ...",
                "yes?"
            }, cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then
            npcHandler:say("text.", cid)
            npcHandler.topic[cid] = 0
            player:setStorageValue(Storage.ExplorerSociety.JoiningtheExplorers, 1)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 1)	
		end
	elseif msgcontains(msg, "no") then
            npcHandler:say("ok", cid)
            npcHandler.topic[cid] = 0
	end		
end


npcHandler:setMessage(MESSAGE_GREET, 'Hi |PLAYERNAME|. {join}.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Bye.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Bye.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
