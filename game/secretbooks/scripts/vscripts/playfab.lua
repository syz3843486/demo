local json = require 'json'
GameRules.PlayerData = {}


function DebugRes(res)
  if true then
    print(res.Body)
  end
end

if IsInToolsMode() then
  revisionSelect = 'Latest'
  generatePlayStreamEvent = false
else
  revisionSelect = 'Live'
  generatePlayStreamEvent = false
end
serverKey = 'verson 1.0'

function CheckPlayerLogin(playerIdx)
  local playerData = GameRules.PlayerData[playerIdx]
  local SessionTicket = playerData['SessionTicket']
  local EntityToken = playerData['EntityToken']
  local Entity = playerData['Entity']
  local PlayFabId = playerData['PlayFabId']

  return SessionTicket and EntityToken and Entity and PlayFabId
end

function CloudScriptFunc(playerIdx,funcName,funcParam,callback)
  if not CheckPlayerLogin(playerIdx) then
    return false
  end
  local playerData = GameRules.PlayerData[playerIdx]

  local SessionTicket = playerData['SessionTicket']
  local EntityToken = playerData['EntityToken']
  local Entity = playerData['Entity']
  funcParam['PlayFabId'] = playerData['PlayFabId']

  CloudScriptFuncBase(SessionTicket,EntityToken,funcName,funcParam
    ,revisionSelect,generatePlayStreamEvent,Entity,callback)
  return true
end

function CloudScriptFuncBase(sessionTicket,entityToken,funcName,funcParam,revisionSelect,generatePlayStreamEvent,entityTable,callback)
  local req = CreateHTTPRequestScriptVM("POST", "https://E06A.playfabapi.com/CloudScript/ExecuteEntityCloudScript")
  req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
  req:SetHTTPRequestHeaderValue("X-EntityToken", entityToken)
  print('sessionTicket',sessionTicket)
  -- req:SetHTTPRequestHeaderValue("X-Authentication", sessionTicket)
  if funcParam then
    funcParam['ServerKey'] = ""--GetDedicatedServerKeyV2(serverKey)
    print("funcParam['ServerKey']",funcParam['ServerKey'])
  end
  local reqTable = {
        FunctionName= funcName,
        FunctionParameter= funcParam,
        RevisionSelection= revisionSelect,
        GeneratePlayStreamEvent=generatePlayStreamEvent,
        Entity= entityTable,
       }
  print("json.encode(reqTable) ",json.encode(reqTable))
  req:SetHTTPRequestRawPostBody("application/json",json.encode(reqTable))
  req:Send(function(res) 
    if res then
      DebugRes(res)
      local resbody = json.decode(res.Body)
      if callback then
        callback(resbody)
      end
    end
  end)

end

function GetUserData(keys,callback)
  print("GetUserData")
  return CloudScriptFunc(0,'GetUserData',{keys=keys},callback)
end

function UpdateUserDate(data,callback)
  return CloudScriptFunc(0,'UpdateUserDate',{data=data},callback)
end

function SetBooksData(book_name,score,callback)
  return CloudScriptFunc(0,'SetBooksData',{book_data = { name="book"..book_name,score=score}},callback)
end

function GetBookData(callback)

end

function SetBookData(book_name,score,callback)

end



function Donate(money,callback)

end
