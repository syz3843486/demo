function OnMenuBtn()
{
	var MainMenuPanel = $("#MainMenuPanel");
	MainMenuPanel.visible = !MainMenuPanel.visible
} 

function OnCloseBtn()
{
	var MainMenuPanel = $("#MainMenuPanel");
	MainMenuPanel.visible = false
}


function OnOpenBooksPage()
{
	var BooksPage = $("#BooksPage");
	BooksPage.visible = true;
	$.Msg('BooksPage.visible ',BooksPage.visible)

	var MainMenuPanel = $("#MainMenuPanel");
	MainMenuPanel.visible = false
}

function OnBooksPageCloseBtn()
{
	var BooksPage = $("#BooksPage");
	BooksPage.visible = false
}

function AnimatePanel(panel, values, duration, ease, delay)
{
	// generate transition string
	var durationString = (duration != null ? parseInt(duration * 1000) + ".0ms" : DEFAULT_DURATION);
	var easeString = (ease != null ? ease : DEFAULT_EASE);
	var delayString = (delay != null ? parseInt(delay * 1000) + ".0ms" : "0.0ms"); 
	var transitionString = durationString + " " + easeString + " " + delayString;

	var i = 0;
	var finalTransition = ""
	for (var property in values)
	{
		// add property to transition
		finalTransition = finalTransition + (i > 0 ? ", " : "") + property + " " + transitionString;
		i++;
	}

	// apply transition
	panel.style.transition = finalTransition + ";";

	// apply values
	for (var property in values)
		panel.style[property] = values[property];
}

var imageID = 0
function OnAbilityEvent(data)
{	
	var HeroBar = $("#HeroBar");
	var heroImage = $.CreatePanel( "DOTAHeroImage", HeroBar, "heroImage" + imageID);
	heroImage.BLoadLayoutSnippet("HeroImage")
	heroImage.SetParent(HeroBar)
	$.Msg(HeroBar)
	heroImage.heroname = data.name
	var totalTime = data.time * 1.5
	var leftTime = totalTime
	var dt = 0.03
	var w = HeroBar.actuallayoutwidth
	var center = $("#HeroBarCenter")
	$.Msg(center)
	var flag1 = 0.25
	$.Msg(heroImage.style)
	var flag2 = 0.20
	heroImage.style["position"] = 1600+'px '  + '0% 0px';
	AnimatePanel(heroImage, { "transform": "translateX(-1600px);", "opacity": "1;" }, totalTime,'linear');

	function run()
	{
		leftTime =  leftTime - dt
		if(leftTime >= 0)
		{
			var p = leftTime/totalTime
			if(p > flag2 && p < flag1)
			{
				heroImage.style["border"] = "5px solid #FF0000FF";
			}
			else
			{
				heroImage.style["border"] = "2px solid #333333FF";
			}
			//heroImage.style["position"] = Math.floor(p*w) +'px '  + '0% 0px';
			//heroImage.style["position"] = Math.floor(p*100) +'% '  + '0% 0px';
			$.Schedule(dt,run);
			return
		}
		$.Msg('delete')
		heroImage.DeleteAsync(0)
		return
	}
	run()
}

GameEvents.Subscribe( "ability_event", OnAbilityEvent);
