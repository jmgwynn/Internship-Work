--Michael Gwynn
--URL: "scenes:/autoSaver#autoSave"
local Save = {}
local playerStats = {}
local OniStats = {}
--Save File Path: C:\Users\**your user name here**\AppData\Roaming\Kaijitsu_Save_Data
local filePath = sys.get_save_file("Kaijitsu", "Save_Data")

--Load Data
--Calls when the scene is switched and on initial loading of the game.
function init(self)
	math.randomseed(os.time())
	print(filePath)
   	Save = sys.load(filePath)
    if not next(Save) then  	
    	createSave(self)
	end
end

--Get and Set functions
--Get table syntax: {index of the table in save, index of the item in the table}. Returns the value at that point to the sender
--now also returns the index value that was being gotten. useful for when you need a bunch of stuff
--Set table syntax: {index of the table in save, index of the item in the table, new value}
function on_message(self, message_id, message, sender)
    if message_id == hash("get") then
    	x=message[1]
    	y=message[2]
    	if Save[x][y] ~= nil then
     		msg.post(sender, "return", {Save[x][y], y,table_num=x})
 		else
 			if x == 1 or 3 or 6 or 7 or 10 then
 				Save[x][y] = false
 				msg.post(sender, "return", {Save[x][y], y,table_num=x})
 			elseif x == 4 or 8 then
 				Save[x][y] = {0,0,0,0}
 				msg.post(sender, "return", {Save[x][y], y,table_num=x})
 			end
 		end
    elseif message_id == hash("set") then
     	Save[message[1]][message[2]] = message[3]
    elseif message_id == hash("reset") then
     	createSave(self)
 	elseif message_id == hash("save") then
 		sys.save(filePath, Save)
    end
end

--Save Data
--Calls when the scene is switched and on closing of the game.
function final(self)
	sys.save(filePath, Save)
    print("goodbye cruel world")
end

function createSave(self)
    Save[1] = {Enemy1=false,Enemy2=false,Enemy3=false,Enemy4=false,Enemy5=false,Enemy6=false,Enemy7=false,Enemy8=false,Enemy9=false,
    			Enemy10=false,Enemy11=false,Enemy12=false,Enemy13=false,Enemy14=false,Enemy15=false,Enemy16=false,Enemy17=false,
    			Enemy18=false} --which pages have been collected in the overworld
    Save[3] = {"Robin",false}--which enemy needs to be spawned in combat
    Save[4] = {"attack0", "attack0", "attack0", "attack0", {0,0,0,0}}--which moves were selected by the player
	Save[5] = {playerStats = {HP = 100, SPD = 100, EVA = 5, ACC = 100, CRT = 5}, 
				EnemyStats = {HP = 100, SPD = 100, EVA = 5, ACC = 100, CRT = 5}}--enemy and player stats
    Save[6] = {Enemy1=false,Enemy2=false,Enemy3=false,Enemy4=false,Enemy5=false,Enemy6=false,Enemy7=false,Enemy8=false,Enemy9=false,
    			Enemy10=false,Enemy11=false,Enemy12=false,Enemy13=false,Enemy14=false,Enemy15=false,Enemy16=false,Enemy17=false,
    			Enemy18=false}--which enemies have been defeated
    Save[7] = {{false, false, false, false, false, false, false, false, false, false, false, false}}--which moves have been unlocked
    Save[8] = {vmath.vector3(0,0,0)}--location the player was at in the overworld last
    Save[9] = {"attack1","attack0","attack0","attack0", {5,0,0,0}}--which moves are being trained in the training mode
    Save[10] = {false,true}--gender
end
