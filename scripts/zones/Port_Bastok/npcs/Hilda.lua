-----------------------------------
-- Area: Port Bastok
-- NPC:  Hilda
-- Involved in Quest: Cid's Secret, Riding on the Clouds
-- Starts & Finishes: The Usual 
-- @zone 236
-- @pos -163 -8 13
-----------------------------------
package.loaded["scripts/zones/Port_Bastok/TextIDs"] = nil;
-----------------------------------

require("scripts/globals/keyitems");
require("scripts/globals/quests");
require("scripts/globals/missions");
require("scripts/zones/Port_Bastok/TextIDs");

-----------------------------------
-- onTrade Action
-----------------------------------

function onTrade(player,npc,trade)
	
    if(trade:getGil() == 0 and trade:getItemCount() == 1) then
        if(trade:hasItemQty(4530,1) and player:getVar("CidsSecret_Event") == 1 and player:hasKeyItem(UNFINISHED_LETTER) == false) then -- Trade Rollanberry
            player:startEvent(0x0085);
        elseif(trade:hasItemQty(4386,1) and player:getQuestStatus(BASTOK,THE_USUAL) == 1) then -- Trade King Truffle
            player:startEvent(0x0087);
        end
    end
	
	if(player:getQuestStatus(JEUNO,RIDING_ON_THE_CLOUDS) == QUEST_ACCEPTED and player:getVar("ridingOnTheClouds_2") == 5) then
		if(trade:hasItemQty(1127,1) and trade:getItemCount() == 1) then -- Trade Kindred seal
			player:setVar("ridingOnTheClouds_2",0);
			player:tradeComplete();
			player:addKeyItem(SMILING_STONE);
			player:messageSpecial(KEYITEM_OBTAINED,SMILING_STONE);
		end
	end
	
end;

-----------------------------------
-- onTrigger Action
-----------------------------------

function onTrigger(player,npc)

	if(player:getCurrentMission(BASTOK) == ON_MY_WAY) and (player:getVar("MissionStatus") == 1) then
		player:startEvent(0x00ff);
	elseif(player:getQuestStatus(BASTOK,THE_USUAL) ~= QUEST_COMPLETED) then
		if(player:getQuestStatus(BASTOK,CID_S_SECRET) == QUEST_ACCEPTED) then
			player:startEvent(0x0084);
			if(player:getVar("CidsSecret_Event") ~= 1) then
				player:setVar("CidsSecret_Event",1);
			end
		elseif(player:getFameLevel(BASTOK) >= 5 and player:getQuestStatus(BASTOK,CID_S_SECRET) == QUEST_COMPLETED) then
			if(player:getVar("TheUsual_Event") == 1) then
				player:startEvent(0x0088);
			elseif(player:getQuestStatus(BASTOK,THE_USUAL) == QUEST_ACCEPTED) then
				player:startEvent(0x0031); --Hilda thanks the player for all the help; there is no reminder dialogue for this quest
			else
				player:startEvent(0x0086);
			end
		else
			player:startEvent(0x0030); --Standard dialogue if fame isn't high enough to start The Usual and Cid's Secret is not active
		end
	elseif(player:getQuestStatus(BASTOK,THE_USUAL) == QUEST_COMPLETED and player:getQuestStatus(BASTOK,CID_S_SECRET) == QUEST_COMPLETED) then
		player:startEvent(0x0031); --Hilda thanks the player for all the help 
	else
		player:startEvent(0x0030); --Standard dialogue if no quests are active or available
	end
	
end;

-----------------------------------
-- onEventUpdate
-----------------------------------

function onEventUpdate(player,csid,option)
--printf("CSID: %u",csid);
--printf("RESULT: %u",option);
end;

-----------------------------------
-- onEventFinish
-----------------------------------

function onEventFinish(player,csid,option)
--printf("CSID: %u",csid);
--printf("RESULT: %u",option);
    
	if(csid == 0x0085) then
        player:tradeComplete();
        player:addKeyItem(UNFINISHED_LETTER);
        player:messageSpecial(KEYITEM_OBTAINED,UNFINISHED_LETTER);
    elseif(csid == 0x0086 and option == 0) then
    	if(player:getQuestStatus(BASTOK,THE_USUAL) == QUEST_AVAILABLE) then
			player:addQuest(BASTOK,THE_USUAL);
		end
    elseif(csid == 0x0087) then
        player:tradeComplete();
		player:addKeyItem(127);
        player:messageSpecial(KEYITEM_OBTAINED,127);
    elseif(csid == 0x0088) then
		if (player:getFreeSlotsCount() == 0) then 
			player:messageSpecial(ITEM_CANNOT_BE_OBTAINED,17170);
		else
			player:addTitle(STEAMING_SHEEP_REGULAR);
			player:delKeyItem(127);
			player:setVar("TheUsual_Event",0);
			player:addItem(17170);
			player:messageSpecial(ITEM_OBTAINED,17170); -- Speed Bow
			player:addFame(BASTOK,BAS_FAME*30);
			player:completeQuest(BASTOK,THE_USUAL);
		end
	elseif(csid == 0x00ff) then
		player:setVar("MissionStatus",2);
    end
	 
end;