"use strict";

function OnClickReSet(){
	$.Msg('------Reset!!')
}


function OnRoundChg(data){
	$.Msg('---onRoundChg')
	var round_data = data.round_data

	var round_id = round_data.id
	var text = "关卡 "+ round_id.toString()
	$("#Round_Text").text = text
}

function OnScoreChg(data){
	$.Msg('---OnScoreChg')
	var score_data = data.score_data
	var score = score_data.score
	var add = score_data.add
	var text = "分数 "+ score.toString()
	if (add > 0){
		text = text + ' + ' + add.toString()
	}

	$("#Score_Text").text = text
}

function OnComboChg(data){
	$.Msg('---OnComboChg')
	// var combo_data = data.combo_data

	// var combo = combo_data.combo
	// var text = "连击 "
	// text = text +'X'+ combo.toString()
	// $("#Combo_Text").text = text
}

function ComboX(){
	$.Msg('---ComboX111')
	
	var Combo_Panel = $("#Combo_Panel");;

	var run = function () {
		var unit = Players.GetPlayerHeroEntityIndex(0);
		$.Msg('unit ',unit)
		if (unit == -1)
			return
		var origin = Entities.GetAbsOrigin(unit);

		var pos = [Game.WorldToScreenX(origin[0],origin[1],origin[2]),Game.WorldToScreenY(origin[0],origin[1],origin[2])];

		var w = Game.GetScreenWidth();
		var h = Game.GetScreenHeight();

		var offsetX = 200
		var offsetY = 200

		var newX = pos[0]
		var newY = pos[1]

		newX = newX + offsetX
		newY = newY - offsetY
		$.Msg('w ',w,'h ',h,'x ',newX,'y ',newY)

		if( newX > w )
		{
			newX = pos[0] - offsetX
		}

		// $.Msg('newX ',newX ,'newY ', newY)

		/*if( pos[0] > w || pos[0] < 0 || pos[1] > h || pos[1] < 0 )
			Combo_Panel.visible = false;
		else {*/
			var newPos = newX + "px " + newY + "px 0px";
	        Combo_Panel.style["position"] = newPos;
	        $.Msg( Combo_Panel.style["position"])
			Combo_Panel.visible = true;
		/*}*/
	}

	var __run = function(){
		run()
		$.Schedule(0.03,__run);
	}
	__run()
}

;(function(){
	$.Msg('---------evade!!!')
	//ComboX();
	GameEvents.Subscribe("SynRound",OnRoundChg);
	GameEvents.Subscribe("SynScore",OnScoreChg);
	GameEvents.Subscribe("SynCombo",OnComboChg);
})()
