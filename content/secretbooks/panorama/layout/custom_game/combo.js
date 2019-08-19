"use strict";

function alertObj(obj,name,str)
{
	var output = "";
	if(name == null)
	{
		name = toString(name)
	}

	if(str == null)
	{
		str = ""
	}

	$.Msg(str+name+"\n"+str+"{")

	for(var i in obj){
		var property=obj[i];
		if(typeof(property) == "object")
		{
			alertObj(property,i,str+"\t")
		}
		else
		{
			output = i + " = " + property + "\t(" + typeof(property) + ")";
			$.Msg(str+"\t"+output);
		}
	}
	$.Msg(str+"}");
}

function ImageNum(_path,_ext){
	this.path = _path;
	this.ext = _ext;
	this.mainPanle = $("#Combo_Panel");
	this.ImageNumArray = new Array();
	this.ImageNumArray[0] = $("#Combo1");
	this.ImageNumArray[1] = $("#Combo2");
	this.ImageNumArray[2] = $("#Combo3");
	this.ImageNumArray[3] = $("#Combo4");
	this.ImageNumArray[4] = $("#Combo5");
}

ImageNum.prototype.start = function () {
	if (this.__is_stop === true) {
		this.__is_stop = false;
		this.__start_time = Game.Time();
		this.__run();
	}
}

ImageNum.prototype.setImageNum = function (idx,num) {
	var path = this.path + num + this.ext;
	//$.Msg('idx ',idx,'---new path',path)
	this.ImageNumArray[idx].SetImage(path);
	this.ImageNumArray[idx].visible = true;
}

ImageNum.prototype.setnum = function (num) {
	if(num > 99999){
		//$.Msg('ImageNum ',num,' > 99999!!!')
		num = 99999;
	}
	

	var endidx = 0
	for(var i=0,max=1 ; i < 5 ; ++i)
	{
		max = max*10;
		if(max > num)
		{
			endidx = i;
			break;
		}
	}
	
	for(var i=endidx+1 ;i < this.ImageNumArray.length-1 ; ++i )
	{
		var imageNum = this.ImageNumArray[i]
		this.ImageNumArray[i].visible = false;
	}

	for(var i = endidx ; i >=0;--i)
	{
		var yu = num%10;
		num = (num-yu)/10;
		this.setImageNum(i,yu);
	}
}

ImageNum.prototype.setvisible = function (_visible) {
	this.mainPanle.visible = _visible;
}

ImageNum.prototype.tween_show = function () {
	this.tween_show_cur = 0
	this.tween_show_end = 1
	this.tween_show_dt = 0.05
	this.tween_show_base_value = 0.8
	this.tween_show_end_value = 2

	return
	var self = this

	var _tween_show_start = function(){
		if(self.tween_update() == false) 
			return;
		$.Schedule(0.05,_tween_show_start)
	}

	_tween_show_start()
}

ImageNum.prototype.tween_update = function () {
	this.tween_show_cur = this.tween_show_cur + this.tween_show_dt
	if( this.tween_show_cur > this.tween_show_end )
		return false
	var alpha = this.tween_show_cur / this.tween_show_end
	var value = (this.tween_show_end_value-this.tween_show_base_value)*alpha + this.tween_show_base_value
	for(var i in this.ImageNumArray){
		this.ImageNumArray[i].SetScaling(2)
		//$.Msg('value ',value)
	}
	return true
}


var path = "file://{resources}/images/custom_game/number/"
var ext = ".png"

function ComboPanel(_unit,_offX,_offY,_path,_ext){
	this.ImageNum = new ImageNum(_path,_ext)
	this.unit = _unit
	this.offsetX = _offX
	this.offsetY = _offY
	this.visible = false
}

ComboPanel.prototype.update = function()
{
	if(this.visible == false)
		return;
	var w = Game.GetScreenWidth();
	var h = Game.GetScreenHeight();
	var origin = Entities.GetAbsOrigin(this.unit);
	var pos = [Game.WorldToScreenX(origin[0],origin[1],origin[2]),Game.WorldToScreenY(origin[0],origin[1],origin[2])];

	var main = this.ImageNum.mainPanle

	var maxwidth = (w/h)*1080;
	var midwidth = maxwidth/2;
	var newX = ((pos[0] / w) * maxwidth) - main.actuallayoutwidth / 3;
	var newY = ((pos[1] / h) * 1080) - main.actuallayoutheight;

	var offsetX = this.offsetX
	var offsetY = this.offsetY

	newX = newX + offsetX
	newY = newY - offsetY

	// if( newX > w )
	// {
	//  	newX = pos[0] - offsetX
	// }
	var newPos = newX + "px " + newY + "px 0px";
	this.ImageNum.mainPanle.style["position"] = newPos;
	//$.Msg('newPos ',newPos , 'w ',w,'h ',h)
	this.ImageNum.mainPanle.visible = true;
}

ComboPanel.prototype.start = function(){
	//$.Msg('this ',this);
	var self = this
	var __start =function (){
		//if (self.visible)
		{
			self.update();
		}
		$.Schedule(0.01,__start);
	}
	__start()
}

ComboPanel.prototype.setvisible = function(_visible){
	this.visible = _visible
	this.ImageNum.setvisible(_visible);
}

ComboPanel.prototype.setnum = function(num){
	this.ImageNum.setnum(num);
}



function OnPlayerInit(data){
	//$.Msg('---OnPlayerInit ',ext)
	GameUI.ComboPanel = new ComboPanel(data.unit , 200,200,path,ext)
	GameUI.ComboPanel.start()
}

function OnComboChg(data){
	//$.Msg('---OnComboChg')
	var combo_data = data.combo_data

	var combo = combo_data.combo
	if (combo > 0){
		GameUI.ComboPanel.setnum(combo)
		GameUI.ComboPanel.setvisible(true);
		GameUI.ComboPanel.ImageNum.tween_show()
	}
	else
		GameUI.ComboPanel.setvisible(false)
}

function OnComboOff(data){
	var x = data.x
	var y = data.y
	//$.Msg('---OnComboOff ',x,y)
	GameUI.ComboPanel.offsetX = x
	GameUI.ComboPanel.offsetY = y
}

;(function(){
	GameEvents.Subscribe("PlayerInit",OnPlayerInit);
	GameEvents.Subscribe("SynCombo",OnComboChg);
	GameEvents.Subscribe("ComboOff",OnComboOff);
})()