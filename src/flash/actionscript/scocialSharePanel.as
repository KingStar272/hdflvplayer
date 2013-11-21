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
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.display.*;
	import flash.text.*;
	import flash.system.System;
	import flash.geom.ColorTransform;
	public class scocialSharePanel
	{
		private var config:Object;
		private var reference:Sprite;


		public function scocialSharePanel(cfg,ref)
		{
			config = cfg;
			reference = ref;
		}
		public function sharefun()
		{
			config['tooltipMc'].visible = false;
			config['SocialPanel'].alpha = 1;
			config['SocialPanel'].closebut.buttonMode = true;
			config['SocialPanel'].closebut.addEventListener(MouseEvent.MOUSE_DOWN,mailcloseFun);
			config['SocialPanel'].Sharetheword.autoSize = TextFieldAutoSize.LEFT;
			config['SocialPanel'].Sharetheword.text = String(config['sharetheword']);
			
			config['SocialPanel'].pMc.buttonMode = true;
			config['SocialPanel'].pMc.pageurl.mouseEnabled = false;
			config['SocialPanel'].emb.buttonMode = true;
			config['SocialPanel'].emb.embedurl.mouseEnabled = false;
			config['SocialPanel'].pMc.addEventListener(MouseEvent.CLICK,copyLinkCopyFun);
			config['SocialPanel'].emb.addEventListener(MouseEvent.CLICK,embedcodeCopyFun);
			config['SocialPanel'].ifra.addEventListener(MouseEvent.CLICK,iframeCopyFun);
			config['SocialPanel'].ifra.buttonMode = true;
			config['SocialPanel'].ifra.embedurl.mouseEnabled = false;
			config['SocialPanel'].socialtext.autoSize = TextFieldAutoSize.LEFT;
			config['SocialPanel'].socialtext.text = String(config['social']);
			config['SocialPanel'].linktext.autoSize = TextFieldAutoSize.LEFT;
			config['SocialPanel'].linktext.text = String(config['link']);
			config['SocialPanel'].embedtext.autoSize = TextFieldAutoSize.LEFT;
			config['SocialPanel'].embedtext.text = String(config['embed']);


			config['SocialPanel'].mouseEnabled = false;
			config['SocialPanel'].scaleX = config['stageHeight'] / 310;
			config['SocialPanel'].scaleY = config['stageHeight'] / 310;
			
			if (config['shareB'] == false)
			{
				config['SocialPanel'].emb.embedurl.alwaysShowSelection = false;
				config['SocialPanel'].pMc.pageurl.alwaysShowSelection = false;
				config['SocialPanel'].x=(config['stageWidth']/2)-(config['SocialPanel'].width/2);
				config['SocialPanel'].y=-(config['SocialPanel'].height);
				new Tween(config['SocialPanel'] , "y", null , config['SocialPanel'].y  , (config['stageHeight']/2)-(config['SocialPanel'].height/2) , 0.3, true);
				config['shareClip'].alpha = 0.5;
				config['SocialPanel'].visible = true;
				config['midRoll'].alpha = 0;
				if (config['isplayed'] == true && config['file'] != undefined)
				{
					var videopause = new videoPause(config);
				}
				config['shareB'] = true;
				config['adv'].visible = false;
				if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
				{
					if (config['thuMc'].x < config['stageWidth'])
					{
						var slideRelatedVideo = new sliderelatedVideo(config,config['ref']);
						slideRelatedVideo.hideRelatedVideo();
					}
				}
			}
			else
			{
				if (config['pauseState'] == true && config['file'] != undefined)
				{
					var videoplay = new videoPlay(config);
				}
				else
				{
					config['Playbtn'].alpha = 1;
				}
				mailclosed();
			}
			setTimeout(shareEnable,400);
		}
		private function copyLinkCopyFun(eve:MouseEvent)
		{
			config['SocialPanel'].pMc.pageurl.setSelection(0, config['SocialPanel'].pMc.pageurl.text.length);
			System.setClipboard(config['SocialPanel'].pMc.pageurl.text);
			config['SocialPanel'].pMc.pageurl.alwaysShowSelection = true;
			config['SocialPanel'].emb.embedurl.alwaysShowSelection = false;
			config['SocialPanel'].ifra.embedurl.alwaysShowSelection = false;
		}
		private function embedcodeCopyFun(eve:MouseEvent)
		{
			config['SocialPanel'].emb.embedurl.setSelection(0, config['SocialPanel'].emb.embedurl.text.length);
			System.setClipboard(config['SocialPanel'].emb.embedurl.text);
			config['SocialPanel'].emb.embedurl.alwaysShowSelection = true;
			config['SocialPanel'].pMc.pageurl.alwaysShowSelection = false;
			config['SocialPanel'].ifra.embedurl.alwaysShowSelection = false;
		}
		
		private function iframeCopyFun(eve:MouseEvent)
		{
			config['SocialPanel'].ifra.embedurl.setSelection(0, config['SocialPanel'].ifra.embedurl.text.length);
			System.setClipboard(config['SocialPanel'].ifra.embedurl.text);
			config['SocialPanel'].ifra.embedurl.alwaysShowSelection = true;
			config['SocialPanel'].emb.embedurl.alwaysShowSelection = false;
			config['SocialPanel'].pMc.pageurl.alwaysShowSelection = false;
		}
		function mailcloseFun(eve:MouseEvent)
		{
			config['QualityBg'].visible = false;
			if (config['shareB'] == true)
			{
				if (config['pauseState'] == true && config['file'] != undefined)
				{
					var videoplay = new videoPlay(config);
				}
				else
				{
					config['Playbtn'].alpha = 1;
				}
				mailclosed();
			}
		}
		public function mailclosed()
		{
			config['midRoll'].alpha = 1;
			config['shareB'] = false;
			config['shareClip'].alpha = 1;
			new Tween(config['SocialPanel'],"y",null,config['SocialPanel'].y,config['stageHeight'] + config['SocialPanel'].height,0.3,true);
			if (config['midvis'])
			{
				config['adv'].visible = true;
			}
			config['mailPanel'].visible = false;
			var videoscale = new videoScale(config,reference);
			videoscale.buttonVis();
		}
		function shareEnable()
		{
			config['shareMc'].mouseEnabled = true;
		}
		public function changeColor(object:MovieClip, color:Number)
		{
			var colorchange:ColorTransform = new ColorTransform();
			colorchange.color = color;
			object.transform.colorTransform = colorchange;
		}

	}
}