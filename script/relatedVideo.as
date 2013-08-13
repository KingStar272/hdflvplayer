package script
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
	import flash.net.*;

	public class relatedVideo
	{
		private var config:Object;
		private var referencee:Sprite;
		private var playerUI:playerUi;
		private var relaMc:relaMcc;
		private var galMc:gal;
		private var xposs:Number;
		private var yposs:Number;
		private var imgContW:Number;
		private var imgContH:Number;
		private var nopreviewMc:nopreview;
		private var myTM:TransitionManager;
		private var mc:MovieClip;
		private var mc2:MovieClip;

		public function relatedVideo(con,ref)
		{
			config = con;
			referencee = ref;
			playerUI = new playerUi(ref,config);
		}
		//========================================== load related video in center of the player ==============================================================================
		public function loadrelatedvideos(confi)
		{
			config['mailcloseBt'].bg.gotoAndStop(2);
			config['mailcloseBt'].addEventListener(MouseEvent.CLICK,closerelatedFun);
			config['midRoll'].alpha = 0;
			var videoscale = new videoScale(config,referencee);
			videoscale.buttonInVis();
			config['relatedview'] = true;
			config['Rbt'].visible = config['Lbt'].visible = false;
			relaMc=new relaMcc();
			referencee.addChild(relaMc);
			config['relaMc'] = relaMc;
			config['shareClip'].alpha = 1;
			yposs = xposs = imgContW = imgContH = config['numofimg'] = 0;
			config['Rbt'].mouseEnabled = config['Lbt'].mouseEnabled = false;
			for (var i=config['imageCount']; i<=config['thumb_image'].length-1; i++)
			{
				if (config['numofimg'] < 6)
				{
					galMc = new gal();
					galMc.name = "thumb" + i;
					var tex:String = config['video_title'][i];
					galMc.tle.htmlText = String(tex);
					if (config['video_views'][i] != undefined)
					{
						galMc.view.text = String("View: "+config['video_views'][i]);
					}
					if (config['duration_arr'][i] != undefined)
					{
						galMc.timer.text = String(config['duration_arr'][i]);
					}
					galMc.tle.mouseEnabled = false;
					galMc.tle.alpha = 0;
					galMc.timer.alpha = 0;
					galMc.view.alpha = 0;
					galMc.tle.textColor = config['textColor'];
					if (config['displayState'] == "normal")
					{
						galMc.width=(config['stageWidth']/3.4);
						galMc.height=(config['stageHeight']/2)-75;
					}
					else
					{
						galMc.width=(config['stageWidth']/4)-20;
						galMc.height=(config['stageHeight']/3)-45;
					}
					if (xposs>=3)
					{
						xposs = 0;
						yposs++;
					}
					galMc.x=(galMc.width-1) * xposs;
					galMc.y =(galMc.height-2) * yposs;
					relaMc.addChild(galMc);
					xposs++;
					config['imageCount']++;
					if (config['imageCount'] > config['thumb_image'].length + 1)
					{
						config['imageCount'] = 0;
					}
					config['numofimg']++;
					imgContW = galMc.img.width;
					imgContH = galMc.img.height;
					if (config['thumb_image'][i] == undefined || config['thumb_image'][i] == "")
					{
						nopreviewMc=new nopreview();
						galMc.img.addChild(nopreviewMc);
						nopreviewMc.tex.text = String(config['nothumbnail']);
						nopreviewMc.width = imgContW;
						nopreviewMc.height = imgContH;
						galMc.thu_buf.visible = false;
					}
					else
					{
						var loadThum = new loadThumbImage(galMc,config,i);
					}
					config['vidarr'].push(galMc);
					galMc.addEventListener(MouseEvent.MOUSE_OVER,overFunnn);
					galMc.buttonMode = true;
					galMc.addEventListener(MouseEvent.CLICK,updateMovie);
				}
			}
			if (config['numofimg'] > 3 && config['numofimg'] < 6)
			{
				relaMc.bg.visible = false;
			}
			else
			{
				relaMc.bg.visible = true;
				relaMc.bg.width = relaMc.width;
				relaMc.bg.height = relaMc.height;
			}
			myTM = new TransitionManager(relaMc);
			if (config['rt'] == true)
			{
				myTM.startTransition({type:Iris, direction:Transition.IN, duration:.3, easing:Strong.easeOut, startPoint:4,shape:Iris.CIRCLE});
			}
			else
			{
				myTM.startTransition({type:Iris, direction:Transition.IN, duration:.3, easing:Strong.easeOut, startPoint:6,shape:Iris.CIRCLE});
			}
			setrelatedposition();
		}
		public function setrelatedposition()
		{
			config['relaMc'].x=(config['stageWidth']/2)-(config['relaMc'].width/2);
			if (config["displayState"] == "normal")
			{
				config['relaMc'].y=(config['stageHeight']/2)-(config['relaMc'].height/2);
			}
			else
			{
				config['relaMc'].y=(config['stageHeight']/2)-(config['relaMc'].height/2);
			}
			if (config['imageCount'] < config['thumb_image'].length)
			{
				config['Rbt'].x = config['relaMc'].x + config['relaMc'].width + 10;
				config['Rbt'].y = config['stageHeight'] / 2;
			}
			else
			{
				config['Rbt'].x = -200;
			}
			if ((config['imageCount']-config['numofimg'])>=6)
			{
				config['Lbt'].x = config['relaMc'].x - 18;
				config['Lbt'].y = config['stageHeight'] / 2;
			}
			else
			{
				config['Lbt'].x = -200;
			}
			setTimeout(bgvis,100);
			config['mailcloseBt'].visible = true;
			config['mailcloseBt'].x = config['relaMc'].x + config['relaMc'].width - 14;
			config['mailcloseBt'].y = config['relaMc'].y + 12;
			referencee.setChildIndex(config['mailcloseBt'],referencee.numChildren-1);
		}
		function bgvis()
		{
			if (config['relatedview'] == true)
			{
				config['Rbt'].visible = config['Lbt'].visible = true;
				config['Rbt'].mouseEnabled = config['Lbt'].mouseEnabled = true;
			}
		}
		public function closerelatedFun(eve:MouseEvent)
		{
			config['QualityBg'].visible = false;
			if (config['relatedview'] == true)
			{
				removerelated();
			}
			if (config['pauseState'] == true)
			{
				var videoplay3 = new videoPlay(config);
			}
			else
			{
				config['Playbtn'].alpha = 1;
			}
		}
		public function removerelated()
		{
			if (config['shareB'] == true)
			{
				config['SocialPanel'].alpha = 1;
			}
			config['mailcloseBt'].visible = false;
			config['shareClip'].alpha = 1;
			config['midRoll'].alpha = 1;
			config['relatedview'] = false;
			if (config['relaMc'] != null)
			{
				referencee.removeChild(config['relaMc']);
				config['relaMc'] = null;
			}
			config['Rbt'].visible = config['Lbt'].visible = false;
			var videoscaleee = new videoScale(config,referencee);
			if (config['errorMc'].visible == true)
			{
				videoscaleee.buttonInVis();
			}
			else
			{
				videoscaleee.buttonVis();
			}
		}
		public function overFunnn(eve:MouseEvent)
		{
			mc = eve.currentTarget as MovieClip;
			mc.tle.alpha = 1;
			mc.timer.alpha = 1;
			mc.view.alpha = 1;
			new Tween(mc.img,"alpha",Strong.easeOut,mc.img.alpha,0.05,0.5,true);
			mc.removeEventListener(MouseEvent.MOUSE_OVER,overFunnn);
			mc.addEventListener(MouseEvent.MOUSE_OUT,outFunnn);
		}
		public function outFunnn(eve:MouseEvent)
		{
			mc2 = eve.currentTarget as MovieClip;
			mc2.tle.alpha = 0;
			mc2.timer.alpha = 0;
			mc.view.alpha = 0;
			new Tween(mc2.img,"alpha",Strong.easeOut,mc2.img.alpha,1,0.5,true);
			mc2.addEventListener(MouseEvent.MOUSE_OVER,overFunnn);
		}
		//========================================== select videos from related video ==============================================================================
		private function updateMovie(eve:MouseEvent)
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
				config['update'] = true;
				config['errorMc'].visible = false;
				config['vid'] = eve.currentTarget.name.substr(5);
				var playvideo = new playVideo(config,referencee);
				playvideo.stopVideoPlay();
				removerelated();
			}
		}
	}

}