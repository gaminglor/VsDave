package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";

	public var InExpungedState:Bool = false;

	override function create()
	{
		super.create();
		InExpungedState = FlxG.save.data.exploitationState == 'playing';
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = null;
		if (InExpungedState)
		{
			txt = new FlxText(0, 0, FlxG.width, LanguageManager.getTextString('intoWarningExpunged'), 32);
			
			FlxG.save.data.exploitationState = null;
			FlxG.save.flush();
		}
		else if (FlxG.save.data.begin_thing)
		{
			txt = new FlxText(0, 0, FlxG.width, LanguageManager.getTextString('introWarningSeen'), 32);
		}
		else
		{
			txt = new FlxText(0, 0, FlxG.width, LanguageManager.getTextString('introWarningFirstPlay'), 32);
		}
		txt.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		txt.antialiasing = true;
		add(txt);

		#if mobile
		addVirtualPad(LEFT_FULL, A_B_C);
		#end
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT && (FlxG.save.data.begin_thing == true || InExpungedState))
		{
			leaveState();
		}

		if (InExpungedState)
		{
			super.update(elapsed);
			return;
		}

		if (FlxG.keys.justPressed.Y #if mobile || virtualPad.buttonC.justPressed #end && FlxG.save.data.begin_thing != true || controls.ACCEPT && FlxG.save.data.begin_thing != true)
		{
			FlxG.save.data.begin_thing = true;
			FlxG.save.data.eyesores = true;
			leaveState();
		}

		if (FlxG.keys.justPressed.N #if mobile || virtualPad.buttonB.justPressed #end && FlxG.save.data.begin_thing != true || controls.ACCEPT && FlxG.save.data.begin_thing != true)
		{
			FlxG.save.data.begin_thing = true;
			FlxG.save.data.eyesores = false;
			leaveState();	
		}

		super.update(elapsed);
	}

	function leaveState()
	{
		if(!FlxG.save.data.alreadyGoneToWarningScreen)
		{
			FlxG.save.data.alreadyGoneToWarningScreen = true;
			FlxG.save.flush();
		}
		leftState = true;
		FlxG.switchState(new MainMenuState());
	}
}
