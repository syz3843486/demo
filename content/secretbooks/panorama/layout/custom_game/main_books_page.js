var max_scores = {}
var book_data = {}
var cur_book_id = 1

function OnDetailBookBtn()
{
}

function OnRecBookScoreData(event_data)
{
	$.Msg('OnRecBookScoreData',event_data)
	var ContextPanel = $.FindChildInContext('#ContextPanel')
	for(var key in event_data)
	{
		var id = "#bookDetail_"+ key
		var panel = ContextPanel.FindChildTraverse(id)
		var score = event_data[key]
		max_scores[id] = score
		$.Msg(panel)
		if(panel)
		{
			panel.FindChildTraverse("MaxScore").text = "" + score
		}
	}
}

function OnRecInitBooksEvent( event_data )
{
	$.Msg('OnRecBookData')
	$.Msg( "OnMyEvent: ", event_data );

	var ContextPanel = $.FindChildInContext('#ContextPanel')
	ContextPanel.RemoveAndDeleteChildren()
	for(var key in event_data)
	{
		var id = "#bookDetail_"+ key
		$.Msg('id ',id)
		var panel = $.CreatePanel( "Panel", ContextPanel, id);
		panel.BLoadLayoutSnippet("BookDetail")
		panel.SetParent(ContextPanel)
		for (var i = 0; i < panel.GetChildCount(); i++) {
			$.Msg(panel.GetChild(i).id)
		}
		var BookDesc = panel.FindChildTraverse("BookDesc")
		book_data[key] = event_data[key]
		panel.FindChildTraverse("BookName").text = $.Localize(event_data[key].name)
		BookDesc.text = $.Localize(event_data[key].desc)
		var btn = panel.FindChildTraverse("BookButton")
		btn.SetPanelEvent("onactivate",function(){
			cur_book_id = key
			$.FindChildInContext('#BooksPage').style.visibility = "collapse" 
			GameEvents.SendCustomGameEventToServer('start_book',{id:event_data[key].id})
		})
	}
}

function OnRecUpdateRoundScore(event_data)
{
	var book_id = event_data.id
	var book_name = book_data[book_id].name
	var max_score = event_data.pre_score
	var cur_score = event_data.score

	var RoundRst = $("#RoundRst")
	RoundRst.visible = true
	var nameLable = RoundRst.FindChildTraverse('RoundRst_Name')
	nameLable.text = $.Localize(book_name)
	var curScoreLable = RoundRst.FindChildTraverse("RoundRst_CurScore")
	curScoreLable.text = $.Localize('curscore') + ": " + cur_score

	var maxScoreLable = RoundRst.FindChildTraverse("RoundRst_MaxScore")
	maxScoreLable.text = $.Localize('maxscore') + ": " + max_score
}


function OnCloseRoundRstBtn()	
{
	var RoundRst = $("#RoundRst")
	RoundRst.visible = false
}

function OnRestart()
{
	GameEvents.SendCustomGameEventToServer('start_book',{id:cur_book_id})
	$("#RoundRst").visible = false
}

$.Msg('-main_books_page.js')
GameEvents.Subscribe( "init_books_event", OnRecInitBooksEvent);
GameEvents.Subscribe( "book_score_data", OnRecBookScoreData);
GameEvents.Subscribe( "update_round_score", OnRecUpdateRoundScore);
