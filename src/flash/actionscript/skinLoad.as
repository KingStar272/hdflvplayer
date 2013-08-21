package actionscript
{

	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.external.*;
	import flash.geom.ColorTransform;
	import flash.text.TextFieldAutoSize;

	public class skinLoad extends MovieClip
	{
		private var skiLoader:Loader;
		private var skinMc:MovieClip;
		private var config:Object;
		private var reference:Sprite;
		public var PlayerEvents:playerEvents;
		private var MessageClass:Message;
		private var skinMc_S:Skinmc;
		private var slideRelatedVideo:sliderelatedVideo;

		public function skinLoad(ref,Config)
		{
			reference = ref;
			config = Config;
		}
		public function skinloaded()
		{
			if (config['local'] != 'true')
			{
				skiLoader = new Loader();
				if (config['skin'].indexOf('http') > -1)
				{
					config['skin'] = config['skin'];
				}
				else
				{
					config['skin'] = config['baseurl'] + "" + config['skin'];
				}
				skiLoader.load(new URLRequest(config['skin']+"?skid="+config['ran']));
				skiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,skinFunc);
				skiLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, skinError);
			}
			else
			{
				skinMc_S = new Skinmc();
				reference.addChild(skinMc_S);
				skinMc = new MovieClip();
				skinMc = skinMc_S;
				config['skin'] = "skin_hdflv_white.swf";
				skinElements();
			}
		}
		private function skinError(evt:IOErrorEvent)
		{
			MessageClass = new Message(config,reference);
			MessageClass.show("There is a problem in loading required skin");
		}
		public function skinFunc(eve:Event)
		{
			reference.addChild(skiLoader);
			skinMc = new MovieClip();
			skinMc = MovieClip(skiLoader.content);
			skinElements();
		}
		function changeColor(object:MovieClip, color:Number)
		{
			var colorchange:ColorTransform = new ColorTransform();
			colorchange.color = color;
			object.transform.colorTransform = colorchange;
		}
		function skinElements()
		{
			config['autopL'] = new MovieClip();
			skinMc.addChild(config['autopL']);
			skinMc.y = config['stageHeight']-(skinMc.skin_bg.height);
			config['skinMc'] = skinMc;
			config['skinMc'].pro.seek_bar.width = config['skinMc'].pro.buffer_bar.width = 0;
			config['skinMc'].pp.Replay.visible = false;
			config['skinMc'].pro.pointer.scaleX = config['skinMc'].pro.pointer.scaleY = 1.2;
			config['skinMc'].pro.pointer.alpha = 0;
			config['skinMc'].ti.timetex.autoSize = TextFieldAutoSize.LEFT;
			config['skinMc'].ti2.timetex.autoSize = TextFieldAutoSize.RIGHT;
			config['skinMc'].ti.timetex.htmlText = "00:00";
			config['skinMc'].ti2.timetex.autoSize = TextFieldAutoSize.RIGHT;
			config['skinMc'].ti2.timetex.htmlText = "00:00";
			config['skinMc'].ti2.timetex.x = 3;
			config['skinMc'].ti2.bar.x = config['skinMc'].ti2.timetex.width + 8;

			var getColors = new getColor(config);
			config['skincolor'] = getColors.getSkinColor();
			if (String(config['textColor']) != "" && config['textColor'] != undefined)
			{
				config['textColor'] = config['textColor'];
			}
			else
			{
				config['textColor'] = config['skincolor'];

			}
			config['mailPanel'].form.Totxt.textColor = config['textColor'];
			config['mailPanel'].form.Fromtxt.textColor = config['textColor'];
			config['mailPanel'].form.Notetxt.textColor = config['textColor'];
			config['mailPanel'].result.textColor = config['textColor'];
			config['skinMc'].indication.textColor = config['textColor'];
			if (config['showTag'] == "true")
			{
				config['tagline'].txt.textColor = config['textColor'];
			}
			if (String(config['skinBgColor']) != "" && config['skinBgColor'] != undefined)
			{
				changeColor(config['skinMc'].skin_bg.bg,config['skinBgColor']);
				changeColor(config['skinMc'].pp.bar,config['skinBgColor']);
				changeColor(config['skinMc'].pro.bar,config['skinBgColor']);
				changeColor(config['skinMc'].ti2.bar,config['skinBgColor']);
				changeColor(config['skinMc'].autoPlayButton.bar,config['skinBgColor']);
				changeColor(config['skinMc'].hd.bar,config['skinBgColor']);
				changeColor(config['skinMc'].PlayListView.bar,config['skinBgColor']);
				changeColor(config['skinMc'].Volume.bar,config['skinBgColor']);
				changeColor(config['skinMc'].Volume.bar,config['skinBgColor']);
			}
			if (String(config['skinIconColor']) != "" && config['skinIconColor'] != undefined)
			{
				changeColor(config['skinMc'].pp.pause_btn.icon,config['skinIconColor']);
				changeColor(config['skinMc'].pp.play_btn.icon,config['skinIconColor']);
				changeColor(config['skinMc'].autoPlayButton.icon,config['skinIconColor']);
				changeColor(config['skinMc'].PlayListView.icon,config['skinIconColor']);
				changeColor(config['skinMc'].FullScreen,config['skinIconColor']);
				changeColor(config['skinMc'].Volume.muteBt,config['skinIconColor']);
				changeColor(config['skinMc'].Volume.v1,config['skinIconColor']);
				changeColor(config['skinMc'].Volume.v2,config['skinIconColor']);
				changeColor(config['skinMc'].hd.hdOffmode,config['skinIconColor']);
				config['skinMc'].hd.hdOffmode.alpha = 0.8
				changeColor(config['skinMc'].hd.hdOnmode,config['skinIconColor']);
				config['skinMc'].ti.timetex.textColor = config['skinIconColor'];
				config['skinMc'].ti2.timetex.textColor = config['skinIconColor'];
			}
			if (String(config['seek_barColor']) != "" && config['seek_barColor'] != undefined)
			{
				changeColor(config['skinMc'].pro.seekS,config['seek_barColor']);
				changeColor(config['skinMc'].pro.seek_end,config['seek_barColor']);
				changeColor(config['skinMc'].pro.seek_bar,config['seek_barColor']);
				changeColor(config['adIndicator'].adseek,config['seek_barColor']);
				changeColor(config['skinMc'].Volume.vol_bar.vol_cnt.sli,config['seek_barColor']);
				changeColor(config['skinMc'].Volume.vol_bar.vol_cnt.cur,config['seek_barColor']);
			}
			else
			{
				changeColor(config['adIndicator'].adseek,config['skincolor']);
			}
			if (String(config['buffer_barColor']) != "" && config['buffer_barColor'] != undefined)
			{
				changeColor(config['skinMc'].pro.bufferS,config['buffer_barColor']);
				changeColor(config['skinMc'].pro.buffer_end,config['buffer_barColor']);
				changeColor(config['skinMc'].pro.buffer_bar,config['buffer_barColor']);
			}
			if (String(config['pro_BgColor']) != "" && config['pro_BgColor'] != undefined)
			{
				changeColor(config['skinMc'].pro.bgS,config['pro_BgColor']);
				changeColor(config['skinMc'].pro.bg_end,config['pro_BgColor']);
				changeColor(config['skinMc'].pro.progress_bg,config['pro_BgColor']);
			}
			var skinArrnge = new skinarrnge(config);
			PlayerEvents = new playerEvents(config,reference);
			var getVidData = new getinitialvidData(reference,config);
			if (config['relatedVideoView'] == "side" && config['showPlaylist'] == "true" && config['plistlength'] != 0)
			{
				slideRelatedVideo = new sliderelatedVideo(config,reference);
				slideRelatedVideo.loadrelatedvideos(config);
			}
			var socialshare = new socialShare(config);
			changeColor(config['QualityBg'].poi,config['textColor']);
		}
	}
}