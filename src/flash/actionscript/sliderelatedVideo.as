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
	import flash.text.*;
	import flash.utils.*;
	import flash.filters.BitmapFilterQuality;
	import flash.net.*;

	public class sliderelatedVideo
	{
		private var config:Object;
		private var referencee:Sprite;
		private var galMc2:gal2;
		private var imgContW:Number;
		private var imgContH:Number;
		private var nopreviewMc:nopreview;
		private var playerUI:playerUi;
		private var ADV:adV;
		private var mc:MovieClip;

		public function sliderelatedVideo(con,ref)
		{
			config = con;
			referencee = ref;
			playerUI = new playerUi(ref,config);
		}
		//========================================== Load related video to thu slide ==============================================================================
		public function loadrelatedvideos(confi)
		{
			config['scrollbarVerticalMc'].visible = false;
			config['midRoll'].alpha = 0;
			config['thuMc'].sh_hi.show.visible = config['thuMc'].sh_hi.hide.visible = false;
			if(config['skin_opacity'] != "" && config['skin_opacity'] != undefined)
			{
				config['thuMc'].thubg.alpha = config['thuMc'].sh_hi.bg.alpha = config['skin_opacity']
			}
			var getColors = new getColor(config);
			config['skincolor'] = getColors.getSkinColor()
			if (String(config['relatedVideoBgColor']) != "")
			{
				playerUI.changeColor(config['thuMc'].thubg,config['relatedVideoBgColor']);
				playerUI.changeColor(config['thuMc'].sh_hi.bg,config['relatedVideoBgColor']);
			}
			if (String(config['playerButtonColor']) != "")
			{
				playerUI.changeColor(config['thuMc'].sh_hi.show,config['playerButtonColor']);
				playerUI.changeColor(config['thuMc'].sh_hi.hide,config['playerButtonColor']);
			}
			else
			{
				playerUI.changeColor(config['thuMc'].sh_hi.show,config['skincolor']);
				playerUI.changeColor(config['thuMc'].sh_hi.hide,config['skincolor']);
			}

			if (String(config['scroll_barColor']) != "")
			{
				playerUI.changeColor(config['scrollbarVerticalMc'].drag_mc,config['scroll_barColor']);
			}
			else
			{
				playerUI.changeColor(config['scrollbarVerticalMc'].drag_mc,config['skincolor']);
			}
			if (String(config['scroll_BgColor']) != "")
			{
				playerUI.changeColor(config['scrollbarVerticalMc'].track_mc,config['scroll_BgColor']);
			}
			if (config['playlist_open'] == 'true')
			{
				config['thuMc'].x = config['stageWidth'] - config['thuMc'].thubg.width;
				config['thuMc'].sh_hi.hide.visible = true;
			}
			else
			{
				config['thuMc'].x = config['stageWidth'];
				config['thuMc'].sh_hi.show.visible = true;
			}
			config['thuMc'].thu_container.y = 5;
			var totalv:Number;
			if(config['thumb_image'].length>50){totalv = 50}
			else {totalv = config['thumb_image'].length}
			for (var i=0; i<=totalv-1; i++)
			{
				galMc2 = new gal2();
				galMc2.name = "thumb" + i;
				var tex:String = config['video_title'][i];
				galMc2.tle.autoSize = TextFieldAutoSize.LEFT;
				galMc2.tle.htmlText = String(tex);
				galMc2.tle.mouseEnabled = false;
				galMc2.tle.textColor = config['textColor'];
				var format:TextFormat = new TextFormat();
				format.size = 11;
				galMc2.tle.setTextFormat(format);
				galMc2.x = 23;
				config['thuMc'].thu_container.addChild(galMc2);
				imgContW = galMc2.img.width;
				imgContH = galMc2.img.height;
				if (config['thumb_image'][i] == undefined || config['thumb_image'][i] == "")
				{
					if (config['imageDefault'] == true)
					{
						nopreviewMc=new nopreview();
						galMc2.img.addChild(nopreviewMc);
						nopreviewMc.tex.text = String(config['nothumbnail']);
						nopreviewMc.width = imgContW;
						nopreviewMc.height = imgContH;
						galMc2.thu_buf.visible = false;
					}
					else
					{
						galMc2.thu_buf.visible = false;
					}
				}
				else
				{
					var loadThum = new loadThumbImage(galMc2,config,i);
				}
				config['vidarr'][i] = galMc2;
				galMc2.buttonMode = true;
				galMc2.addEventListener(MouseEvent.MOUSE_DOWN,updateMovie);
				if (i==0)
				{
					galMc2.y = 5;
				}
				else
				{
					config['vidarr'][i].y = (config['vidarr'][i-1].height + config['vidarr'][i-1].y+10);

				}
				if (i==config['thumb_image'].length-1)
				{
					ADV = new adV();
					config['thuMc'].thu_container.addChild(ADV);
					ADV.y = config['vidarr'][i].height + config['vidarr'][i].y + 20;
					ADV.alpha = 0;
					//ADV.visible =false
				}
			}
			config['thuMc'].sh_hi.show.buttonMode = true;
			config['thuMc'].sh_hi.hide.buttonMode = true;
			config['thuMc'].sh_hi.hide.addEventListener(MouseEvent.CLICK,hideButtonClicked);
			config['thuMc'].sh_hi.show.addEventListener(MouseEvent.CLICK,showButtonClicked);
			config['thuMc'].addEventListener(MouseEvent.MOUSE_OVER,playlistOver);
			config['thuMc'].addEventListener(MouseEvent.MOUSE_OUT,playlistOut);
			setrelatedposition();
			config['scrollbarVerticalMc'].x = config['thuMc'].thubg.width - 8.7;
			config['scrollbarVerticalMc'].down_arrow_mc.visible = config['scrollbarVerticalMc'].up_arrow_mc.visible = false;
			config['playeruI'].dispatchEvent(new Event('callscroll'));
			config['scrollbarVerticalMc'].visible = false;
		}
		function playlistOver(eve:MouseEvent)
		{
			if (config['thuMc'].thu_container.height > config['stageHeight'])
			{
				config['scrollbarVerticalMc'].visible = true;
			}
		}
		function playlistOut(eve:MouseEvent)
		{
			if (config['ref'].mouseX < config['stageWidth'] - 30)
			{
				config['scrollbarVerticalMc'].visible = false;
			}
		}
		public function setrelatedposition()
		{
			config['thuMc'].tslide.visible = false;
			config['thuMc'].bslide.visible =false
			if (config['skinMc'].y < config['stageHeight'] && config['skinVisible'] != "false")
			{
				config['thuMc'].thubg.height = config['skinMc'].y + 2;
				config['thuMc'].thumask.height = config['skinMc'].y;
				config['thuMc'].tslide.y = config['skinMc'].y;
			}
			else
			{
				config['thuMc'].thubg.height = config['stageHeight'];
				config['thuMc'].thumask.height = config['stageHeight'];
				config['thuMc'].tslide.y = config['stageHeight'];
			}
			config['thuMc'].sh_hi.y = (config['stageHeight']-25)/2
		}
		function hideButtonClicked(eve:MouseEvent)
		{
			config['reclick'] = true;
			hideRelatedVideo();
			setTimeout(reclicked,3000);
		}
		function hideRelatedVideo()
		{
			config['QualityBg'].visible = false;
			config['autopL'].visible = false;
			config['tooltipMc'].visible = false;
			new Tween(config['thuMc'],"x",null,config['thuMc'].x,config['stageWidth'],0.4,true);
			config['thuMc'].sh_hi.show.visible = true;
			config['thuMc'].sh_hi.hide.visible = false;
			if (config['midroll_ads'] == "true" && config['allowmidroll'] == "true" && config['mov'] == 2 && config['imaAds'] == false && config['midvis'])
			{
				new Tween(config['midRoll'], "x",null,config['midRoll'].x,(config['stageWidth']/2)-(config['midRoll'].midbg.width/2), 0.4, true);
			}
			if (config['showTag'] == "true")
			{
				new Tween(config['tagline'].bg,"x",null,config['tagline'].bg.x,0,0.4,true);
				new Tween(config['tagline'].dot,"x",null,config['tagline'].dot.x,config['tagline'].bg.width,0.4,true);
			}
		}
		function showButtonClicked(eve:MouseEvent)
		{
			config['reclick'] = true;
			showRelatedVideo();
			setTimeout(reclicked,3000);
		}
		function showRelatedVideo()
		{
			config['QualityBg'].visible = false;
			config['autopL'].visible = false;
			config['tooltipMc'].visible = false;
			new Tween(config['thuMc'],"x",null,config['thuMc'].x,config['stageWidth'] - config['thuMc'].thubg.width,0.4,true);
			config['thuMc'].sh_hi.show.visible = false;
			config['thuMc'].sh_hi.hide.visible = true;
			if (config['midroll_ads'] == "true" && config['allowmidroll'] == "true" && config['mov'] == 2 && config['imaAds'] == false && config['midvis'])
			{
				if ((config['midRoll'].x+config['midRoll'].midbg.width)>(config['stageWidth']-config['thuMc'].thubg.width))
				{
					new Tween(config['midRoll'], "x",null,config['midRoll'].x,config['stageWidth']-(config['thuMc'].thubg.width+config['midRoll'].midbg.width), 0.4, true);
				}
			}

			if (config['showTag'] == "true")
			{
				var tw:Number = config['stageWidth']-((2*(config['stageHeight']/9.5))+30);
				if (tw<config['tagline'].bg.width)
				{
					new Tween(config['tagline'].bg, "x",null,config['tagline'].bg.x,-(config['thuMc'].thubg.width-(config['stageHeight']/9.5)), 0.4, true);
					new Tween(config['tagline'].dot, "x",null,config['tagline'].dot.x,config['tagline'].bg.width-(config['thuMc'].thubg.width-(config['stageHeight']/9.5)), 0.4, true);
				}
			}
		}
		function reclicked()
		{
			config['reclick'] = false;
		}
		function updateMovie(eve:MouseEvent)
		{
			config['vid'] = eve.currentTarget.name.substr(5);
			config['fbpath'] = config['fbpath_arr'][config['vid']];
			if(String(config['fbpath']) != undefined && String(config['fbpath']) != "" && config['mtype'] != "playerModule")
			{
				navigateToURL(new URLRequest(config['fbpath']), '_self');
				return;
			}
			else
			{
				if (config['shareB'] == true)
				{
					var EmailSS = new scocialSharePanel(config,referencee);
					EmailSS.mailclosed();
				}
				if (config['mailB'] == true)
				{
					var Emails = new email(config,referencee);
					Emails.mailclosed();
				}
				config['QualityBg'].visible = false;
				config['skinMc'].pro.buffer_end.visible = config['skinMc'].pro.seek_end.visible = config['skinMc'].pro.seekS.visible = config['skinMc'].pro.bufferS.visible = false;
				config['errorMc'].visible = false;
				config['update'] = true;
				var playvideo = new playVideo(config,referencee);
				playvideo.stopVideoPlay();
			}
		}
	}
}