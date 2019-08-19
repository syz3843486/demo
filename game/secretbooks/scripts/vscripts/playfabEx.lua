require "playfab"

local function ResponseFunc(res,successCb,failedCb)
	 if res['status'] == "OK" and successCb then
	 	successCb(res.data)
	 elseif failedCb then
	 	failedCb(res)
	 end
end

function InitDataCallBack(playerIdx)
	--GetMoneyData(playerIdx)
end

function LoginCallBack(playerIdx,res)
  print("[STATS] Received", res.Body)
  local resbody = json.decode(res.Body)
  local status = resbody['status']
  if status == "OK" then
    local data=resbody["data"]
    local playerData = {}
    playerData.SessionTicket=data.SessionTicket  --store session ticket
    playerData.PlayFabId = data.PlayFabId
    playerData.Entity= data.EntityToken.Entity
    playerData.EntityToken= data.EntityToken.EntityToken
    GameRules.PlayerData[playerIdx]=playerData--init player data
    InitDataCallBack(playerIdx)
    GameRules:GetRoundScore(playerIdx)
  else
    Timers:CreateTimer(5000,function()
      Login(playerIdx)
    end)
  end
end

function Login(playerIdx)
  local req = CreateHTTPRequestScriptVM("POST", "https://E06A.playfabapi.com/Client/LoginWithCustomID")
  req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
  local reqTable = { CustomId = 'syz' , CreateAccount = true, TitleId = 'E06A' }
  --reqTable.CustomId = tostring(PlayerResource:GetSteamID(playerIdx))
  local encoded = json.encode(reqTable)
  req:SetHTTPRequestRawPostBody("application/json",encoded)
  print ('login 111')
  req:Send(function(res) LoginCallBack(playerIdx,res) end)
end

function GetMoneyData(playerIdx)
  CloudScriptFunc(playerIdx,'GetMoneyData',{},
	function(res)
		ResponseFunc(res,function(data) 
			data = data['FunctionResult']
			CustomGameEventManager:Send_ServerToAllClients( "money_data", {curMoney=data.curMoney})
		end)
	end
  	)
end

function GetBookScoreData(playerIdx,books_name)
	   CloudScriptFunc(playerIdx,'GetBookScoreData',{books_name=books_name},
	   function(res)
		 if res['status'] == "OK" then
        data = res.data['FunctionResult']
        GameRules:SycnBookScoreFromPlayFab(playerIdx,data)
     else
        Timer:CreateTimer(5000,function() GetBookScoreData(playerIdx,book_names) end)
     end
     end
  	)
end

function SetBookScoreData(playerIdx,book_name,score)
	CloudScriptFunc(playerIdx,'SetBookScoreData',{book_name=book_name , score=score},
	function(res)
    if res['status'] == "OK" then
        data = res.data['FunctionResult']
        GameRules:SycnBookScoreFromPlayFab(playerIdx,data)
     else
        Timer:CreateTimer(5000,function() GetBookScoreData(playerIdx,book_names) end)
     end
	end
  	)
end