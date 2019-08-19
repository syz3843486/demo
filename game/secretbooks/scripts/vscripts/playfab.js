var GAME_SERVER_KEY = ""

function isEmptyObj(obj){
  for(key in obj){
    if(key){
      return false
    }
  }
  return true
}

handlers.UpdateUserData = function(args, context){
  var serverKey = args.ServerKey
  var playerId = args.PlayerId
  var data = args.Data
  var updateUserDataResult = server.UpdateUserInternalData({
        PlayFabId: playerId,
        Data: data,
    });
  return { serverKey:serverKey };
}

handlers.GetUserData = function(args, context){
  var serverKey = args.ServerKey
  var playerId = args.PlayerId
  var keys = args.keys
  log.debug("keys:", keys);
  var playerData = server.GetUserInternalData({
        PlayFabId: playerId,
        Keys: keys,
    });

  return playerData
}


function getBookName(lua_name)
{
  return "book_name_" + lua_name
}

function getLuaBookName(js_name)
{
  var pre = "book_name_"
  return js_name.substring(pre.length)
}

function getBookScore(PlayFabId,book_name)
{
  var Data = server.GetUserInternalData({
      PlayFabId: PlayFabId,
      Keys: book_name,
    }).Data;
  if(isEmptyObj(Data))
  {
    return 0;
  }

  return Data[book_name].Value
}

handlers.SetBookScoreData = function(args, context){
  var serverKey = args.ServerKey
  var PlayFabId = args.PlayFabId
  var lua_book_name = args.book_name
  var score = args.score
  log.debug('serverKey ',serverKey)
  if(GAME_SERVER_KEY != serverKey)
  {
    return {rst : "serverkey error"};
  }
  var book_name = getBookName(lua_book_name)
  
  var pre_score = getBookScore(PlayFabId,book_name)
  if(pre_score > score)
  {
    var luaData = {}
    luaData[lua_book_name] = pre_score
    return luaData;
  }
  var updateData = {}
  updateData[book_name] = score
  var updateUserDataResult = server.UpdateUserInternalData({
    PlayFabId: PlayFabId,
    Data: updateData,
  });
  var luaData = {}
  luaData[lua_book_name] = score

  return luaData;
}

handlers.GetBookScoreData = function(args, context){
  var serverKey = args.ServerKey
  if(GAME_SERVER_KEY != serverKey)
  {
    return {rst : "serverkey error"};
  }

  var PlayFabId = args.PlayFabId
  var books_name = args.books_name
  log.debug('books_name',books_name)
  var scores = {}

  for (var i = 0; i < books_name.length; i++) {
    lua_name = books_name[i]
     var book_name = getBookName(lua_name)
     var Data = server.GetUserInternalData({
      PlayFabId: PlayFabId,
      Keys: book_name,
    }).Data;
     var score = 0
    log.debug('lua_name', lua_name)
    log.debug('Data',Data)
    if(isEmptyObj(Data))
     {
        Data = {}
        Data[book_name] = 0
        var updateUserDataResult = server.UpdateUserInternalData({
        PlayFabId: PlayFabId,
        Data: Data,
        });
        log.debug('updateUserDataResult',updateUserDataResult)
    }
    else
    {
      score = Data[book_name].Value
    }
    scores[lua_name] = score
  }
  return scores;
}

handlers.GetMoneyData = function(args,context){
  var serverKey = args.ServerKey
  var playFabId = args.PlayFabId
  var moneyData = server.GetUserInternalData({
        PlayFabId: playFabId,
        Keys: ["money"],
    });
  if(moneyData.Data.curMoney == null)
  {
    moneyData = {curMoney:0,totalMoney:0};
    server.UpdateUserInternalData({
        PlayFabId: playFabId,
        Data: { money : moneyData },
    });
  }
  else
    moneyData = moneyData.Data

  return moneyData
}

handlers.setviplvl = function (args,context){
  var viplvl = args.viplvl;
  var currentPlayerId = args.currentPlayerId
  var updateUserDataResult = server.UpdateUserInternalData({
        PlayFabId: currentPlayerId,
        Data: {
            viplvl: viplvl,
        }
    });

  return { viplvl:viplvl };
}

handlers.getviplvl = function (args,context){
  var currentPlayerId = args.currentPlayerId
  
  var playerData = server.GetUserInternalData({
        PlayFabId: currentPlayerId,
        Keys: ["viplvl"]
    });

    var viplvl = playerData.Data["viplvl"];
    log.debug("viplvl:", viplvl);
    
    return {viplvl:viplvl};
}

handlers.UpdateBookRanks = function (args,context){
  
}