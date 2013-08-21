package actionscript
{
	import flash.display.Sprite;
	import flash.display.*;
	import flash.external.*;
	import flash.events.*;
	import fl.transitions.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.utils.setTimeout;
	import flash.events.MouseEvent;
	import flash.utils.*;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.*;
	import flash.text.*;
	import flash.text.TextFieldAutoSize;

	public class midrollAds
	{
		private var config:Object;
		private var reference:Sprite;
		private var index:Number;
		private var midimpdata:URLLoader;
		private var midclickdata:URLLoader;

		public function midrollAds(con,ref)
		{
			config = con;
			reference = ref;
			//====================== create listener for midroll events ================================================
			config['midRoll'].close.addEventListener(MouseEvent.MOUSE_DOWN,midrollClosed);
			config['adv'].addEventListener(MouseEvent.MOUSE_DOWN,midrollOpen);
			config['adv'].tex.autoSize = TextFieldAutoSize.RIGHT;
			config['adv'].tex.text = String(config["ads"]);
			config['adv'].tex.textColor = config['textColor'];
			config['adv'].clip.width = config['adv'].tex.width + 6;
			config['midRoll'].midnxt.addEventListener(MouseEvent.MOUSE_DOWN,calmidnxt);
			config['midRoll'].midprev.addEventListener(MouseEvent.MOUSE_DOWN,midprev);
			config['midRoll'].lnk.addEventListener(MouseEvent.MOUSE_DOWN,midlinkcall);
			if (config['midslistlength'] <= 1)
			{
				config['midRoll'].midnxt.visible = false;
				config['midRoll'].midprev.visible = false;
			}
			else
			{
				config['midRoll'].midnxt.visible = true;
				config['midRoll'].midprev.visible = true;
			}
		}
		public function midrollsetup()
		{
			index = 0;
			clearInterval(config['midinterval']);
			config['midinterval'] = setInterval(getbegintime,500);
		}
		private function getbegintime()
		{
			//====================== Dispaly midroll for specific begintimr from miroll xml ================================================
			if (Math.round(config['currentTime']) >= config['midbegin'])
			{
				clearInterval(config['midinterval']);
				midvisi();
			}
		}
		//============================= midroll visible and set position =====================================================================
		function midvisi()
		{
			setdata();
			config['midvis'] = true;
			config['midRoll'].alpha = 1;
			config['midRoll'].visible = true;
			config['adv'].visible = false;
			config['adv'].y = config['skinMc'].y + 200;
			config['adv'].x = config['stageWidth'];
			if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
			{
				config['midRoll'].x = (config['stageWidth']/2)-(config['midRoll'].width/2);
				if ((config['midRoll'].x+config['midRoll'].width)>(config['stageWidth']-config['thuMc'].thubg.width))
				{
					config['midRoll'].x = config['stageWidth']-(config['thuMc'].thubg.width+config['midRoll'].width);
				}
			}
			else
			{
				config['midRoll'].x = (config['stageWidth']/2)-(config['midRoll'].width/2);
			}
			config['midRoll'].y = (config['stageHeight']-25) - (config['midRoll'].height+8);
		}
		function midrollClosed(eve:MouseEvent)
		{
			midInvisi();
			config['adv'].visible = true;
			config['adv'].y = config['skinMc'].y - 8;
			config['adv'].x = config['stageWidth'];
		}
		//============================= midroll Invisible and set position =====================================================================
		public function midInvisi()
		{
			config['adv'].visible = false;
			config['adv'].y = config['stageHeight'] + 100;
			config['adv'].x = config['stageWidth'];
			config['midvis'] = false;
			config['midRoll'].y =config['stageHeight'] + (config['midRoll'].height+8);
			config['midRoll'].alpha = 0;
		}
		function midrollOpen(eve:MouseEvent)
		{
			midvisi();
		}
		//============================= Change midroll data depends on midroll adrotate and random values =========================================
		function setdata()
		{
			if (config['adrotate'] != "true")
			{
				if (config['random'] == "true")
				{
					index = Math.round(Math.random() * (config['midslistlength']-1));
				}
			}
			else
			{
				index++;
			}
			midrolldata();
		}
		function midrolldata()
		{
			clearInterval(config['midinterval']);
			if (index >= config['midslistlength'])
			{
				index = 0;
			}
			if (index < 0)
			{
				index = config['midslistlength'] - 1;
			}

			config['midRoll'].ad.autoSize = TextFieldAutoSize.LEFT;
			config['midRoll'].ad.htmlText = String(config['midadd'][index]);
			if (config['adrotate'] == "true")
			{
				config['midinterval'] = setInterval(setdata,2000);
			}
			midrollimpression();
		}
		function calmidnxt(eve:MouseEvent)
		{
			index++;
			if (index>config['midslistlength'])
			{
				index = 0;
			}
			midrolldata();
		}
		function midprev(eve:MouseEvent)
		{
			index--;
			if (index<0)
			{
				index = config['midslistlength'] - 1;
			}
			midrolldata();
		}
		//============================= Midroll money make function =====================================================================
		function midrollimpression()
		{
			if (config['midimpression'][index] != "" && config['midimpression'][index] != undefined)
			{
				midimpdata = new URLLoader();
				var midimpreq:URLRequest = new URLRequest(config['midimpression'][index]);
				midimpdata.load(midimpreq);
			}
		}
		function midlinkcall(eve:MouseEvent)
		{
			if (config["displayState"] == "fullScreen")
			{
				config['playeruI'].dispatchEvent(new Event('onfullscreen'));
			}
			var midreq:URLRequest = new URLRequest(config['midtar'][index]);
			navigateToURL(midreq, "_blank");
			midrollclick();
		}
		function midrollclick()
		{
			if (config['midclick'][index] != "" && config['midclick'][index] != undefined)
			{
				midclickdata = new URLLoader();
				var midclikreq:URLRequest = new URLRequest(config['midclick'][index]);
				midclickdata.load(midclikreq);
			}
		}
	}

}