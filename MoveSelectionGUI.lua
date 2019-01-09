--Michael Gwynn
--This controls the GUI for selecting up to 4 moves to use in combat out of the available moves
currentPos = 0 --how many moves have been selected. Up to 4 slots may be filled
currentList = 1 --which of the 6 discipline's moves are being shown on the page
offScreen = vmath.vector3(-1000, -1000, 1)
slot1 = ""
slot2 = ""
slot3 = ""
slot4 = ""
enabledMoves = {}
num_to_disc={"Capoeira","KungFu","Gatka","MuayThai","Ninjitsu","Taedekai"}
male = true
num_to_num={2,4,5,3,1,6}

function init(self)
	math.randomseed(os.time())
	msg.post(".", "acquire_input_focus")
	--get appropriate data from the save file
	msg.post("scenes:/autoSaver#autoSave", "get", {4,1})
	msg.post("scenes:/autoSaver#autoSave", "get", {4,2})
	msg.post("scenes:/autoSaver#autoSave", "get", {4,3})
	msg.post("scenes:/autoSaver#autoSave", "get", {4,4})
	msg.post("scenes:/autoSaver#autoSave", "get", {7,1})
	msg.post("scenes:/autoSaver#autoSave", "get", {9,5})
	msg.post("scenes:/autoSaver#autoSave", "get", {10,1})
	setCurrentChoices(self)
end

function on_message(self, message_id, message, sender)
    if message_id == hash("return") then
 		if(message["table_num"] == 7) then
 			--determine which moves are unlocked and disable those that aren't
 			enabledMoves = message[1]
 			for i=1,12,1 do
 				if enabledMoves[i] == false then
 					attack = gui.get_node("attack"..i..".1")
					color = gui.get_color(attack)
					color.w = 0.5
					gui.set_color(attack, color)
 				end
 			end	
 		elseif message["table_num"] == 10 then
 			--determine gender
 			male = message[1]
 		elseif message["table_num"] == 9 then
 			--set the starting GUI page to the appropriate discipline
    		local a = ((currentList - 1) * (2)) + 1
    		local b = ((currentList - 1) * (2)) + 2
 			currentList=num_to_num[message[1][1]]
			local disc_names_node = gui.get_node("disc_names")
			gui.play_flipbook(disc_names_node, "Disc_"..num_to_disc[currentList])
			local a1_1 = gui.get_node("attack" .. a .. ".1")
			local a2_1 = gui.get_node("attack" .. b .. ".1")
			gui.set_position(a1_1, offScreen)
			gui.set_position(a2_1, offScreen)	
 			setCurrentChoices(self)
 		else
 			--fill in any attacks that were selected previously
			if(message[2] == 1) then
				local attack1
				local attack1_1
				if message[1] == "attack0" then
					attack1 = gui.get_node("attack0.1")
				else
					attack1 = gui.get_node(message[1])
					attack1_1 = gui.get_node(message[1] .. ".1")
					currentPos = 1
					slot1 = message[1]				
					string = string.sub(message[1], 7)
					int = tonumber(string)
					enabledMoves[int] = false
					color = gui.get_color(attack1_1)
					color.w = 0.5
					gui.set_color(attack1_1, color)
				end
				local attackPos1 = gui.get_node("pos1")
				gui.set_position(attack1, gui.get_position(attackPos1))
			elseif(message[2] == 2) then
				local attack2
				local attack2_1
				if message[1] == "attack0" then
					attack2 = gui.get_node("attack0.2")
				else
					attack2 = gui.get_node(message[1])
					attack2_1 = gui.get_node(message[1] .. ".1")
					currentPos = 2
					slot2 = message[1]
					string = string.sub(message[1], 7)
					int = tonumber(string)
					enabledMoves[int] = false
					color = gui.get_color(attack2_1)
					color.w = 0.5
					gui.set_color(attack2_1, color)
				end
				local attackPos2 = gui.get_node("pos2")
				gui.set_position(attack2, gui.get_position(attackPos2))
			elseif(message[2] == 3) then
				local attack3
				local attack3_1
				if message[1] == "attack0" then
					attack3 = gui.get_node("attack0.3")
				else
					attack3 = gui.get_node(message[1])
					attack3_1 = gui.get_node(message[1] .. ".1")
					currentPos = 3
					slot3 = message[1]
					string = string.sub(message[1], 7)
					int = tonumber(string)
					enabledMoves[int] = false
					color = gui.get_color(attack3_1)
					color.w = 0.5
					gui.set_color(attack3_1, color)
				end
				local attackPos3 = gui.get_node("pos3")
				gui.set_position(attack3, gui.get_position(attackPos3))
			elseif(message[2] == 4) then
				local attack4
				local attack4_1
				if message[1] == "attack0" then
					attack4 = gui.get_node("attack0.4")
				else
					attack4 = gui.get_node(message[1])
					attack4_1 = gui.get_node(message[1] .. ".1")
					currentPos = 4
					slot4 = message[1]
					string = string.sub(message[1], 7)
					int = tonumber(string)
					enabledMoves[int] = false
					color = gui.get_color(attack4_1)
					color.w = 0.5
					gui.set_color(attack4_1, color)
				end
				local attackPos4 = gui.get_node("pos4")
				gui.set_position(attack4, gui.get_position(attackPos4))
			end
		end
	end
end

function on_input(self, action_id, action)
	if action_id == hash("click") and action.pressed then		
	    local x = action.x
	    local y = action.y
	    local attack1_1 = gui.get_node("choice1")
	    local attack2_1 = gui.get_node("choice2")
	    local attack3_1 = gui.get_node("attack3.1")
	    local attack4_1 = gui.get_node("attack4.1")
	    local attack1 = gui.get_node("attack1")
	    local attack2 = gui.get_node("attack2")
	    local attack3 = gui.get_node("attack3")
	    local attack4 = gui.get_node("attack4")
	    local del1 = gui.get_node("delete1")
	    local del2 = gui.get_node("delete2")
	    local del3 = gui.get_node("delete3")
	    local del4 = gui.get_node("delete4")
	    local nextScene = gui.get_node("next")
    	local a = ((currentList - 1) * (2)) + 1
    	local b = ((currentList - 1) * (2)) + 2
	    if gui.pick_node(attack1_1, x, y) and enabledMoves[a] == true and currentPos<4 then
	    	--add the first of the 2 options on the current page to the move list
	    	local temp = currentPos + 1
	    	msg.post("scenes:/autoSaver#autoSave", "set", {4,temp, "attack" .. a})
	    	msg.post("scenes:/autoSaver#autoSave", "get", {4,temp})
	    	enabledMoves[a] = false
	    elseif gui.pick_node(attack2_1, x, y) and enabledMoves[b] == true and currentPos<4 then
	    	--add the second of the 2 options on the current page to the move list
	    	local temp = currentPos + 1
	    	msg.post("scenes:/autoSaver#autoSave", "set", {4,temp, "attack" .. b})
	    	msg.post("scenes:/autoSaver#autoSave", "get", {4,temp})
	    	enabledMoves[b] = false
	    elseif gui.pick_node(gui.get_node("nextB"), x, y) then
	    	--go forward a move selection page
	    	if currentList < 6 then
	    		currentList = currentList + 1
    		else
    			currentList = 1
			end
			local disc_names_node = gui.get_node("disc_names")
			gui.play_flipbook(disc_names_node, "Disc_"..num_to_disc[currentList])
			local a1_1 = gui.get_node("attack" .. a .. ".1")
			local a2_1 = gui.get_node("attack" .. b .. ".1")
			gui.set_position(a1_1, offScreen)
			gui.set_position(a2_1, offScreen)	
			setCurrentChoices(self)				
	    elseif gui.pick_node(gui.get_node("lastB"), x, y)then
	    	--go back a move selection page
	    	if currentList > 1 then
	    		currentList = currentList - 1
    		else
    			currentList = 6
			end
			local disc_names_node = gui.get_node("disc_names")
			gui.play_flipbook(disc_names_node, "Disc_"..num_to_disc[currentList])
			local a1_1 = gui.get_node("attack" .. a .. ".1")
			local a2_1 = gui.get_node("attack" .. b .. ".1")
			gui.set_position(a1_1, offScreen)
			gui.set_position(a2_1, offScreen)	
			setCurrentChoices(self)
	    elseif gui.pick_node(gui.get_node("goBack"), x, y) then
	    	--load the previous scene
	    	msg.post(".", "load_portal")
	    elseif gui.pick_node(del1, x, y) and currentPos > 0 then
	    	--remove the first skill
	    	local node = gui.get_node(slot1)
	    	local node1 = gui.get_node(slot1 .. ".1")
	    	local color = gui.get_color(node1)
	    	color.w = 1
	    	gui.set_color(node1, color)
			gui.set_position(node, offScreen)
			if currentPos == 1 then
				string = string.sub(slot1, 7)
				int = tonumber(string)
				enabledMoves[int] = true
				msg.post("scenes:/autoSaver#autoSave", "set", {4,1, "attack0"})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,1})
				currentPos = 0				
			elseif currentPos == 2 then
				string = string.sub(slot1, 7)
				int = tonumber(string)
				enabledMoves[int] = true
				msg.post("scenes:/autoSaver#autoSave", "set", {4,1, slot2})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,1})
				msg.post("scenes:/autoSaver#autoSave", "set", {4,2, "attack0"})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,2})
				currentPos = 1
				slot2 = "attack0"
			elseif currentPos == 3 then
				string = string.sub(slot1, 7)
				int = tonumber(string)
				enabledMoves[int] = true
				msg.post("scenes:/autoSaver#autoSave", "set", {4,1, slot2})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,1})
				msg.post("scenes:/autoSaver#autoSave", "set", {4,2, slot3})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,2})
				msg.post("scenes:/autoSaver#autoSave", "set", {4,3, "attack0"})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,3})
				currentPos = 2
				slot3 = "attack0"
			elseif currentPos == 4 then
				string = string.sub(slot1, 7)
				int = tonumber(string)
				enabledMoves[int] = true
				msg.post("scenes:/autoSaver#autoSave", "set", {4,1, slot2})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,1})
				msg.post("scenes:/autoSaver#autoSave", "set", {4,2, slot3})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,2})
				msg.post("scenes:/autoSaver#autoSave", "set", {4,3, slot4})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,3})
				msg.post("scenes:/autoSaver#autoSave", "set", {4,4, "attack0"})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,4})
				currentPos = 3
				slot4 = "attack0"
			end
	    elseif gui.pick_node(del2, x, y) and currentPos > 1 then
	    	--remove the second skill
	    	local node = gui.get_node(slot2)
	    	local node1 = gui.get_node(slot2 .. ".1")
	    	local color = gui.get_color(node1)
	    	color.w = 1
	    	gui.set_color(node1, color)
			gui.set_position(node, offScreen)
			if currentPos == 2 then
				string = string.sub(slot2, 7)
				int = tonumber(string)
				enabledMoves[int] = true
				msg.post("scenes:/autoSaver#autoSave", "set", {4,2, slot3})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,2})
				msg.post("scenes:/autoSaver#autoSave", "set", {4,3, "attack0"})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,3})
				currentPos = 1
				slot2 = "attack0"
			elseif currentPos == 3 then
				string = string.sub(slot2, 7)
				int = tonumber(string)
				enabledMoves[int] = true
				msg.post("scenes:/autoSaver#autoSave", "set", {4,2, slot3})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,2})
				msg.post("scenes:/autoSaver#autoSave", "set", {4,3, slot4})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,3})
				msg.post("scenes:/autoSaver#autoSave", "set", {4,4, "attack0"})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,4})
				currentPos = 2
				slot3 = "attack0"
			elseif currentPos == 4 then
				string = string.sub(slot2, 7)
				int = tonumber(string)
				enabledMoves[int] = true
				msg.post("scenes:/autoSaver#autoSave", "set", {4,2, slot3})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,2})
				msg.post("scenes:/autoSaver#autoSave", "set", {4,3, slot4})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,3})
				msg.post("scenes:/autoSaver#autoSave", "set", {4,4, "attack0"})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,4})
				currentPos = 3
				slot4 = "attack0"
			end			
	    elseif gui.pick_node(del3, x, y) and currentPos > 2 then
	    	--remove the third skill
	    	local node = gui.get_node(slot3)
	    	local node1 = gui.get_node(slot3 .. ".1")
	    	local color = gui.get_color(node1)
	    	color.w = 1
	    	gui.set_color(node1, color)
			gui.set_position(node, offScreen)		
			if currentPos == 3 then
				string = string.sub(slot3, 7)
				int = tonumber(string)
				enabledMoves[int] = true
				msg.post("scenes:/autoSaver#autoSave", "set", {4,3, slot4})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,3})
				msg.post("scenes:/autoSaver#autoSave", "set", {4,4, "attack0"})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,4})
				currentPos = 2
				slot3 = "attack0"
			elseif currentPos == 4 then
				string = string.sub(slot3, 7)
				int = tonumber(string)
				enabledMoves[int] = true
				msg.post("scenes:/autoSaver#autoSave", "set", {4,3, slot4})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,3})
				msg.post("scenes:/autoSaver#autoSave", "set", {4,4, "attack0"})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,4})
				currentPos = 3
				slot4 = "attack0"
			end			
	    elseif gui.pick_node(del4, x, y) and currentPos > 3 then
	    	--remove the fourth skill
	    	local node = gui.get_node(slot4)
	    	local node1 = gui.get_node(slot4 .. ".1")
	    	local color = gui.get_color(node1)
	    	color.w = 1
	    	gui.set_color(node1, color)
			gui.set_position(node, offScreen)	
			if currentPos == 4 then
				string = string.sub(slot4, 7)
				int = tonumber(string)
				enabledMoves[int] = true
				msg.post("scenes:/autoSaver#autoSave", "set", {4,4, "attack0"})
				msg.post("scenes:/autoSaver#autoSave", "get", {4,4})
				currentPos = 3
				slot4 = "attack0"
			end						
	    elseif gui.pick_node(nextScene, x, y) and currentPos > 0 then
	    	--load the combat scene as long as one move is selected
	    	if male == true then
	    		msg.post(".", "load_combat")
    		else
    			msg.post(".", "load_combatf")
    		end
	    end
    end
end

function setCurrentChoices(self)
	--determine which 2 moves are being shown based on the "currentList" variable
	local a = ((currentList - 1) * (2)) + 1
	local b = ((currentList - 1) * (2)) + 2
	local attack1_1 = gui.get_node("attack" .. a .. ".1")
	local attack2_1 = gui.get_node("attack" .. b .. ".1")
	local pos1 = gui.get_node("choice1")
	local pos2 = gui.get_node("choice2")
	gui.set_position(attack1_1, gui.get_position(pos1))
	gui.set_position(attack2_1, gui.get_position(pos2))	
end

function final(self)
	--set the discipline types of the moves selected
	local values = {0,0,0,0}
	local strings = {string.sub(slot1, 7), string.sub(slot2, 7), string.sub(slot3, 7), string.sub(slot4, 7)}
	for i=1,4,1 do
		if(strings[i] == "1" or strings[i] == "2") then
			values[i] = 5
		elseif(strings[i] == "3" or strings[i] == "4") then
			values[i] = 1
		elseif(strings[i] == "5" or strings[i] == "6") then
			values[i] = 4
		elseif(strings[i] == "7" or strings[i] == "8") then
			values[i] = 2
		elseif(strings[i] == "9" or strings[i] == "10") then
			values[i] = 3
		elseif(strings[i] == "11" or strings[i] == "12") then
			values[i] = 6
		end
	end
	if(values[2] == 0) then
		values[2] = values[1]
		values[3] = values[1]
		values[4] = values[1]
	elseif(values[3] == 0) then
		values[3] = values[1]
		values[4] = values[2]
	elseif(values[4] == 0) then
		values[4] = values[math.random(3)]
	end
	msg.post("scenes:/autoSaver#autoSave", "set", {4,5, values})
end