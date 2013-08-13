package script
{

	import flash.events.*;
	import flash.utils.*;
	import flash.net.*;
	import fl.transitions.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.external.*;
	import flash.text.*;

	public class playerEvents extends EventDispatcher
	{
		public var Player:Object;
		private var lighttPd:lighttpd;
		private var reference:Sprite;
		private var sec:Number;
		private var pcent:Number;
		private var newtime:String;
		private var relatedvideo:relatedVideo;
		private var ButtonArray:Array;
		private var Tracker:tracker;
		private var dom:String;
		private var zb:Boolean;
		private var vSet:Number;

		// ============================================ create events for all player Clips ===================================================
		public function playerEvents(config,ref):void
		{
			reference = ref;
			config['shareB'] = false;
			zb = false;
			Player = config['playeruI'];
			Player.config['intLastVolume'] = Player.config['volume'] / 100;
			Player.config['skinMc'].pp.play_btn.visible = false;
			Player.config['skinMc'].pp.pause_btn.visible = false;

			Player.config['mailPanel'].form.send.buttonMode = Player.config['skinMc'].FullScreen.buttonMode = Player.config['skinMc'].pp.buttonMode = Player.config['skinMc'].pro.pointer.buttonMode = Player.config['skinMc'].pro.buffer_bar.buttonMode = Player.config['skinMc'].pro.seek_bar.buttonMode = true;
			Player.config['skinMc'].FullScreen.addEventListener(MouseEvent.CLICK, onResizeClick);
			Player.config['skinMc'].pro.seek_bar.addEventListener(MouseEvent.MOUSE_DOWN,progscrubberClicked);
			Player.config['skinMc'].pro.buffer_bar.addEventListener(MouseEvent.MOUSE_DOWN,progscrubberClicked);
			Player.config['skinMc'].pro.pointer.addEventListener(MouseEvent.MOUSE_DOWN,progscrubberClicked);
			Player.config['skinMc'].addEventListener(MouseEvent.MOUSE_UP,stageMouseUp);
			Player.addEventListener(MouseEvent.MOUSE_UP,stageMouseUp);
			Player.config['Playbtn'].addEventListener(MouseEvent.MOUSE_DOWN,PlayPausebtnClicked);
			Player.config['skinMc'].pp.pause_btn.addEventListener(MouseEvent.MOUSE_DOWN,PlayPausebtnClicked);
			Player.config['skinMc'].pp.play_btn.addEventListener(MouseEvent.MOUSE_DOWN,PlayPausebtnClicked);
			Player.config['skinMc'].pp.Replay.addEventListener(MouseEvent.MOUSE_DOWN,replayFun);
			Player.config['skinMc'].hd.buttonMode = true;

			Player.config['skinMc'].hd.addEventListener(MouseEvent.MOUSE_DOWN,OpenQualityPanel);
			config['shareMc'].addEventListener(MouseEvent.MOUSE_DOWN,shareButtonPressed);
			Player.config['mailPanel'].form.send.mouseChildren = false;
			Player.config['mailPanel'].form.send.addEventListener(MouseEvent.CLICK,emailSend);
			config['zoomInMc'].visible = true;
			config['zoomOutMc'].visible = false;
			config['zoomInMc'].addEventListener(MouseEvent.MOUSE_DOWN,zoominFun);
			config['zoomOutMc'].addEventListener(MouseEvent.MOUSE_DOWN,zoomoutFun);
			config['mailIcon'].addEventListener(MouseEvent.MOUSE_DOWN,openMailPanel);

			Player.config['downloadMc'].addEventListener(MouseEvent.MOUSE_DOWN,DownLoadVideoFun);
			Player.config['skinMc'].Volume.mut.addEventListener(MouseEvent.MOUSE_DOWN,muteBtClicked);
			Player.config['skinMc'].Volume.vol_bar.vol_cnt.bg.buttonMode = Player.config['skinMc'].Volume.vol_bar.vol_cnt.sli.buttonMode = Player.config['skinMc'].Volume.vol_bar.vol_cnt.poi.buttonMode = true;
			Player.config['skinMc'].Volume.vol_bar.vol_cnt.poi.addEventListener(MouseEvent.MOUSE_DOWN,volumPoiClick);
			Player.config['skinMc'].Volume.vol_bar.vol_cnt.sli.addEventListener(MouseEvent.MOUSE_DOWN,volumPoiClick);
			Player.config['skinMc'].Volume.vol_bar.vol_cnt.bg.addEventListener(MouseEvent.MOUSE_DOWN,volumPoiClick);
			Player.config['skinMc'].Volume.vol_bar.vol_cnt.poi.y =  -  (80 / (1 / Player.config['intLastVolume']));
			Player.config['skinMc'].Volume.vol_bar.vol_cnt.sli.height =  -  Player.config['skinMc'].Volume.vol_bar.vol_cnt.poi.y;

			if (Player.config['intLastVolume'] > 0.5)
			{
				config['skinMc'].Volume.v1.visible = Player.config['skinMc'].Volume.v2.visible = true;
				Player.config['skinMc'].Volume.muteBt.gotoAndStop(1);
			}
			else
			{
				Player.config['skinMc'].Volume.v1.visible = true;
				Player.config['skinMc'].Volume.v2.visible = false;
				Player.config['skinMc'].Volume.muteBt.gotoAndStop(1);
			}
			if (Player.config['intLastVolume'] <= 0.1)
			{
				Player.config['skinMc'].Volume.muteBt.gotoAndStop(2);
				Player.config['skinMc'].Volume.v1.visible = Player.config['skinMc'].Volume.v2.visible = false;
			}
			else if (Player.config['intLastVolume']>0.9)
			{
				Player.config['skinMc'].Volume.muteBt.gotoAndStop(1);
			}
			Player.config['skinMc'].PlayListView.addEventListener(MouseEvent.MOUSE_DOWN,relatedvideosbuttonclicked);
			config['Rbt'].addEventListener(MouseEvent.MOUSE_DOWN,rbtFunction);
			config['Lbt'].addEventListener(MouseEvent.MOUSE_DOWN,lbtFunction);
			Player.config['skinMc'].Volume.addEventListener(MouseEvent.MOUSE_OVER,showVolume);
			Player.config['skinMc'].Volume.addEventListener(MouseEvent.MOUSE_OUT,OutVolume);
			Player.config['skinMc'].autoPlayButton.addEventListener(MouseEvent.MOUSE_DOWN,channgePlaylistAutoplay);
			Player.config['autopL'].addEventListener(MouseEvent.MOUSE_DOWN,channgePlaylistAutoplay);
			Player.config['autopL'].buttonMode = true;
			ButtonArray = new Array();
			ButtonArray = [Player.config['shareMc'],Player.config['downloadMc'],Player.config['Rbt'],Player.config['Lbt'],Player.config['zoomInMc'],Player.config['zoomOutMc'],Player.config['mailIcon']];
			for (var i=0; i<ButtonArray.length; i++)
			{
				ButtonArray[i].buttonMode = true;
			}
			progressbarListener();
			if (Player.config['showPlaylist'] == "true" && Player.config['relatedVideoView'] == "side" && Player.config['plistlength'] != 0)
			{
				Player.dispatchEvent(new Event('callscroll'));
			}
			if (reference.root.loaderInfo.parameters['baserefM'])
			{
				Player.logocon.addEventListener(MouseEvent.CLICK, PlayPausebtnClicked);
			}
			else
			{
				Player.logocon.addEventListener(MouseEvent.CLICK, onLogoClick);
			}
		}
		function showVolume(eve:MouseEvent)
		{
			clearInterval(vSet);
			Player.config['QualityBg'].visible = false;
			new Tween(Player.config['skinMc'].Volume.vol_bar , "y" , null , Player.config['skinMc'].Volume.vol_bar.y  , -(Player.config['skinMc'].Volume.vol_bar.height+7.5) , 0.3, true);
		}
		function OutVolume(eve:MouseEvent)
		{
			vSet = setInterval(volumeOutFun,700)
		}
		function volumeOutFun()
		{
			clearInterval(vSet);
			Player.config['bolVolumeScrub'] = false;
			Player.config['skinMc'].Volume.vol_bar.vol_cnt.poi.stopDrag();
			new Tween(Player.config['skinMc'].Volume.vol_bar,"y",null,Player.config['skinMc'].Volume.vol_bar.y,Player.config['skinMc'].Volume.vol_bar.height,0.3,true);
		}
		private function OpenQualityPanel(eve:MouseEvent)
		{
			if (Player.config['mov'] == 2 && Player.config['QualityBg'].visible == false)
			{
				Player.config['QualityBg'].visible = true;
				Player.config['QualityBg'].bgMc.bg.height = ((Player.config['QualityArray'].length+1)*25)-5;
				Player.config['QualityBg'].x= Player.mouseX-(Player.config['QualityBg'].width/2);
				Player.config['QualityBg'].y= Player.config['skinMc'].y-(Player.config['QualityBg'].height-5);
			}
			else
			{
				Player.config['QualityBg'].visible = false;
			}
		}
		// ============================================ volume Mute and unMute =======================================================================
		private function muteBtClicked(eve:MouseEvent)
		{
			Player.config['QualityBg'].visible = false;
			Player.dispatchEvent(new Event('mutesound'));
		}
		private function volumPoiClick(eve:MouseEvent)
		{
			Player.config['QualityBg'].visible = false;
			Player.config['bolVolumeScrub'] = true;
			Player.config['skinMc'].Volume.muteBt.gotoAndStop(1);
			Player.config['skinMc'].Volume.vol_bar.vol_cnt.poi.startDrag(true, new Rectangle(0,-5, 0,  -(Player.config['skinMc'].Volume.vol_bar.vol_cnt.bg.height-10)));
		}
		// ============================================ Video replay =================================================================================;
		private function replayFun(eve:MouseEvent)
		{
			Player.config['QualityBg'].visible = false;
			if (Player.config['relatedview'] == true)
			{
				relatedvideo = new relatedVideo(Player.config,reference);
				relatedvideo.removerelated();
			}
			if (Player.config['preval'] == true)
			{
				var preview = new Preview(Player.config['ref'],Player.config);
				preview.removePreview();
				Player.config['Playbtn'].visible = false;
			}
			Player.config['mov'] = 2;
			var getVidData1 = new getinitialvidData(reference,Player.config);
		}

		// ============================================ Logo Target  =================================================================================
		private function onLogoClick(evt:MouseEvent):void
		{
			Player.config['QualityBg'].visible = false;
			Player.config['autopL'].visible = false;
			Player.config['tooltipMc'].visible = false;
			if (Player.config["displayState"] == "fullScreen")
			{
				Player.dispatchEvent(new Event('onfullscreen'));
			}
			if (Player.config['license_Player'] == "demo")
			{
				if (reference.root.loaderInfo.parameters['baserefM'])
				{
					navigateToURL(new URLRequest('http://www.groupclone.net/'), '_blank');
				}
				else if (reference.root.loaderInfo.parameters['baserefW'])
				{
					navigateToURL(new URLRequest('http://www.hdflvplayer.net/wordpress-video-gallery/demo/'), '_blank');
				}
				else
				{
					navigateToURL(new URLRequest('http://www.hdflvplayer.net/'), '_blank');
				}
			}
			else
			{
				dom = "http://www." + Player.config['logodomain'];
				if (Player.config['logo_target'] == "")
				{
					navigateToURL(new URLRequest(String(dom)), '_blank');
				}
				else
				{
					navigateToURL(new URLRequest(Player.config['logo_target']), '_blank');
				}
			}
		}
		// ============================================ fullscreen and normal screen =================================================================
		private function onResizeClick(evt:Event):void
		{
			Player.config['SocialPanel'].visible = Player.config['mailPanel'].visible = false;
			Player.config['QualityBg'].visible = false;
			Player.dispatchEvent(new Event('onfullscreen'));
		}
		// =========================================== play video at any point of buffered area ======================================================
		private function progscrubberClicked(e:MouseEvent):void
		{
			Player.config['QualityBg'].visible = false;
			Player.config['bolProgressScrub'] = true;
			Player.config['stremPlayed'] = true;
			if (Player.config['streamer'] != null && Player.config['streamer'].indexOf("pseudostreaming") > -1 && Player.config['mp4'] == false && Player.config['keyframes'] != undefined)
			{
				Player.config['skinMc'].pro.pointer.startDrag(true, new Rectangle(0, 2, Player.config['skinMc'].pro.progress_bg.width, 0));
				lighttPd = new lighttpd(Player.config);
				lighttPd.scrubit();
			}
			if (Player.config['dailyBG'])
			{
				Player.config['dailyBG'].addEventListener(MouseEvent.MOUSE_MOVE,dragclip);
			}
			Player.addEventListener(MouseEvent.MOUSE_MOVE,dragclip);
			if (Player.config['shareClip'])
			{
				Player.config['shareClip'].addEventListener(MouseEvent.MOUSE_MOVE,dragclip);
			}
			Player.config['playeruI'].addEventListener(MouseEvent.MOUSE_MOVE,dragclip);
			Player.config['skinMc'].addEventListener(MouseEvent.MOUSE_MOVE,dragclip);
			Player.config['skinMc'].pro.seek_bar.width = Player.config['skinMc'].pro.mouseX;
			Player.config['skinMc'].pro.pointer.x = Player.config['skinMc'].pro.mouseX;
			if (Player.config['streamer'] != undefined && Player.config['streamer'] != "")
			{
				Player.config['buffer_Mc'].visible = true;
			}
		}
		function dragclip(eve:MouseEvent)
		{
			if (Player.config['bolProgressScrub'] == true)
			{
				if (Player.config['video'] == "youtube")
				{
					Player.config['skinMc'].pro.pointer.startDrag(true, new Rectangle(0, 2, Player.config['skinMc'].pro.progress_bg.width, 0));
				}
				else if (Player.config['streamer'].indexOf("pseudostreaming") > -1 && Player.config['mp4'] == false && Player.config['keyframes'] != undefined)
				{
					Player.config['skinMc'].pro.pointer.startDrag(true, new Rectangle(0, 2, Player.config['skinMc'].pro.progress_bg.width, 0));
				}
				else
				{
					Player.config['skinMc'].pro.pointer.startDrag(true, new Rectangle(0, 2, Player.config['skinMc'].pro.buffer_bar.width, 0));
				}
			}
			else
			{
				Player.config['skinMc'].pro.pointer.stopDrag();
			}
			eve.updateAfterEvent();
		}
		private function stageMouseUp(eve:MouseEvent):void
		{
			if (Player.config['file'].indexOf('.mp3') > -1 && Player.config['currentTime'] > 0 && Player.config['bolProgressScrub'] == true)
			{
				Player.config['audioChannel'] = Player.config['audio'].play(sec * 1000);
			}
			if (Player.config['bolProgressScrub'] == true && Player.config['streamer'].indexOf("pseudostreaming") > -1 && Player.config['mp4'] == false && Player.config['keyframes'] != undefined)
			{
				lighttPd = new lighttpd(Player.config);
				lighttPd.scrubit();
			}
			Player.config['skinMc'].pro.pointer.stopDrag();
			Player.config['bolProgressScrub'] = false;
			Player.config['bolVolumeScrub'] = false;
			Player.config['downBool'] = false;
			Player.config['upBool'] = false;
			Player.config['stremPlayed'] = false;
			if (Player.config['dailyBG'])
			{
				Player.config['dailyBG'].removeEventListener(MouseEvent.MOUSE_MOVE,dragclip);
			}
			Player.removeEventListener(MouseEvent.MOUSE_MOVE,dragclip);
			if (Player.config['shareClip'])
			{
				Player.config['shareClip'].removeEventListener(MouseEvent.MOUSE_MOVE,dragclip);
			}
			Player.config['playeruI'].removeEventListener(MouseEvent.MOUSE_MOVE,dragclip);
			Player.config['skinMc'].removeEventListener(MouseEvent.MOUSE_MOVE,dragclip);
		}
		// ============================== Viseo Pause and Play =======================================================================================;
		private function PlayPausebtnClicked(eve:MouseEvent)
		{
			Player.config['QualityBg'].visible = false;
			Player.config['autopL'].visible = false;
			if (Player.config['relatedview'] == false && Player.config['shareB'] == false && Player.config['mailB'] == false)
			{
				if (Player.config['preval'] == true)
				{
					if (Player.config['skinMc'].pp.Replay.visible == true)
					{
						Player.config['mov'] = 2;
					}
					var preview = new Preview(Player.config['ref'],Player.config);
					preview.removePreview();
					Player.config['Playbtn'].visible = false;
					var getvideo = new findVideoType(Player.config['ref'],Player.config);
				}
				else if (Player.config['isplayed'] == false || Player.config['Playbtn'].visible == true)
				{
					var videoplay = new videoPlay(Player.config);
				}
				else
				{
					if (Player.config['relatedview'] == false && Player.config['shareB'] == false)
					{
						Player.config['Playbtn'].visible = true;
						Player.config['Playbtn'].alpha = 1;
					}
					var videopause = new videoPause(Player.config);
					Tracker = new tracker(Player.config,Player.config['ref']);
					Tracker.eventTracker("Pause_video","Pause","Pause_btn",0);
				}
			}
			else
			{
				if (Player.config['relatedview'] == true)
				{
					relatedvideo = new relatedVideo(Player.config,reference);
					relatedvideo.removerelated();
					var videoplayEW = new videoPlay(Player.config);
				}
				else if (Player.config['shareB'] == true )
				{
					var EmailSS = new scocialSharePanel(Player.config,reference);
					EmailSS.mailclosed();
					var videoplayB = new videoPlay(Player.config);
				}
				else if (Player.config['mailB'] == true )
				{
					var Emails = new email(Player.config,reference);
					Emails.mailclosed();
					var videoplayLB = new videoPlay(Player.config);
				}
				else
				{
					if (eve.currentTarget.name == "play_btn")
					{
						var videoplayBT = new videoPlay(Player.config);
					}
					else if (Player.config['pauseState'] == true)
					{
						Player.config['Playbtn'].alpha = 1;
					}
				}
			}
		}
		// ====================================== video share via email and social share =============================================================
		private function shareButtonPressed(eve:MouseEvent)
		{
			Player.config['QualityBg'].visible = false;
			if (Player.config['preval'] == false && Player.config['mov'] == 2)
			{
				if (Player.config["displayState"] == "fullScreen")
				{
					Player.dispatchEvent(new Event('onfullscreen'));
				}
				if (Player.config['shareB'] == false && Player.config['mailB'] == false)
				{
					Player.config['pauseState'] = Player.config['isplayed'];
				}
				Player.config['Playbtn'].alpha = 0;
				if (Player.config['relatedview'] == true)
				{
					relatedvideo = new relatedVideo(Player.config,reference);
					relatedvideo.removerelated();
				}
				if (Player.config['mailB'] == true)
				{
					var Emails = new email(Player.config,reference);
					Emails.mailclosed();
				}

				var urlgets = new Loadembedtext(reference,Player.config);
				urlgets.pageurlget();
				urlgets.embedcall();

				var shareS = new scocialSharePanel(Player.config,reference);
				shareS.sharefun();
				var videoscaleS = new videoScale(Player.config,reference);
				videoscaleS.buttonVis();
			}
		}
		private function emailSend(eve:MouseEvent)
		{
			Player.config['QualityBg'].visible = false;
			var EMAILF = new email(Player.config,reference);
			EMAILF.sendEmailFun();
		}
		//============================================ video ZoomIn ==================================================================================
		private function zoominFun(eve:MouseEvent)
		{
			Player.config['QualityBg'].visible = false;
			if (Player.config['inc'] < 3 && Player.config['shareB'] == false && zb == false)
			{
				zb = true;
				var videoscaless = new videoScale(Player.config,reference);
				Player.config['zoomInMc'].mouseEnabled = Player.config['zoomOutMc'].mouseEnabled = false;
				Player.config['zoomOutMc'].mouseEnabled = Player.config['shareMc'].mouseEnabled = Player.config['zoomInMc'].mouseEnabled = false;
				Player.config['zoomOutMc'].buttonMode = Player.config['shareMc'].buttonMode = Player.config['zoomInMc'].buttonMode = false;
				Player.config['inc']++;
				new Tween(Player.config['shareClip'] , "x", null , Player.config['shareClip'].x  ,Player.config['shareClip'].x-((Player.config['stageWidth']/3)/2) , 0.15 , true);
				new Tween(Player.config['shareClip'] , "y", null , Player.config['shareClip'].y  ,Player.config['shareClip'].y-((Player.config['stageHeight']/3)/2) , 0.15 , true);
				new Tween(Player.config['shareClip'] , "width", null , Player.config['shareClip'].width  ,Player.config['shareClip'].width+(Player.config['stageWidth']/3) , 0.15, true);
				new Tween(Player.config['shareClip'] , "height", null , Player.config['shareClip'].height  ,Player.config['shareClip'].height+(Player.config['stageHeight']/3) , 0.15 , true);

				Player.config['zoomOutMc'].mouseEnabled = Player.config['shareMc'].mouseEnabled = Player.config['zoomInMc'].mouseEnabled = false;
				Player.config['zoomOutMc'].buttonMode = Player.config['shareMc'].buttonMode = Player.config['zoomInMc'].buttonMode = false;
				setTimeout(zoomDelayFun,500);
				if (Player.config['inc'] == 3)
				{
					Player.config['zoomInMc'].visible = false;
				}
				else
				{
					Player.config['zoomInMc'].visible = true;
					Player.config['zoomOutMc'].visible = true;
				}
				videoscaless.buttonVis();
			}
		}
		//============================================ video ZoomOut ==================================================================================
		private function zoomoutFun(eve:MouseEvent)
		{
			Player.config['QualityBg'].visible = false;
			if (Player.config['inc'] > 0 && Player.config['shareB'] == false && zb == false)
			{
				zb = true;
				var videoscalesss = new videoScale(Player.config,reference);
				Player.config['zoomInMc'].mouseEnabled = Player.config['zoomOutMc'].mouseEnabled = false;
				Player.config['zoomOutMc'].mouseEnabled = Player.config['shareMc'].mouseEnabled = Player.config['zoomInMc'].mouseEnabled = false;
				Player.config['zoomOutMc'].buttonMode = Player.config['shareMc'].buttonMode = Player.config['zoomInMc'].buttonMode = false;
				Player.config['inc']--;

				new Tween(Player.config['shareClip'] , "x", null , Player.config['shareClip'].x  ,Player.config['shareClip'].x+((Player.config['stageWidth']/3)/2) , 0.15 , true);
				new Tween(Player.config['shareClip'] , "y", null , Player.config['shareClip'].y  ,Player.config['shareClip'].y+((Player.config['stageHeight']/3)/2) , 0.15 , true);
				new Tween(Player.config['shareClip'] , "width", null , Player.config['shareClip'].width  ,Player.config['shareClip'].width-(Player.config['stageWidth']/3) , 0.15 , true);
				new Tween(Player.config['shareClip'] , "height", null , Player.config['shareClip'].height  ,Player.config['shareClip'].height-(Player.config['stageHeight']/3) , 0.15 , true);

				Player.config['zoomOutMc'].mouseEnabled = Player.config['shareMc'].mouseEnabled = Player.config['zoomInMc'].mouseEnabled = false;
				Player.config['zoomOutMc'].buttonMode = Player.config['shareMc'].buttonMode = Player.config['zoomInMc'].buttonMode = false;
				setTimeout(zoomDelayFun,500);
				if (Player.config['inc'] == 0)
				{
					Player.config['zoomOutMc'].visible = false;
					var videoscales = new videoScale(Player.config,reference);
					videoscales.videoResize();

				}
				else
				{
					Player.config['zoomOutMc'].visible = true;
					Player.config['zoomInMc'].visible = true;
				}
				videoscalesss.buttonVis();
			}
		}
		function zoomDelayFun()
		{
			zb = false;
			Player.config['zoomOutMc'].mouseEnabled = Player.config['shareMc'].mouseEnabled = Player.config['zoomInMc'].mouseEnabled = true;
			Player.config['zoomOutMc'].buttonMode = Player.config['shareMc'].buttonMode = Player.config['zoomInMc'].buttonMode = true;
		}
		//============================================ diplay time at any point of the buffered area ==================================================================================
		private function progressbarListener()
		{
			Player.config['skinMc'].pro.buffer_bar.addEventListener(MouseEvent.MOUSE_MOVE,timerDisplay);
			Player.config['skinMc'].pro.buffer_end.addEventListener(MouseEvent.MOUSE_MOVE,timerDisplay);
			Player.config['skinMc'].pro.seek_bar.addEventListener(MouseEvent.MOUSE_MOVE,timerDisplay);
			Player.config['skinMc'].pro.seek_end.addEventListener(MouseEvent.MOUSE_MOVE,timerDisplay);
			Player.config['skinMc'].pro.pointer.addEventListener(MouseEvent.MOUSE_MOVE,timerDisplay);

			Player.config['skinMc'].pro.addEventListener(MouseEvent.MOUSE_OUT,removetooltip);
			Player.config['skinMc'].pro.progress_bg.addEventListener(MouseEvent.MOUSE_MOVE,timerDisplay2);
		}
		private function timerDisplay2(eve:MouseEvent)
		{
			Player.config['autopL'].visible = false;
			Player.config['tooltipMc'].visible = false;
			if (Player.config['video'] == "youtube")
			{
				Player.config['skinMc'].pro.progress_bg.buttonMode = true;
				displayFun();
			}
			else if (Player.config['streamer'].indexOf("pseudostreaming") > -1 && Player.config['mp4'] == false && Player.config['keyframes'] != undefined)
			{
				Player.config['skinMc'].pro.progress_bg.buttonMode = true;
				displayFun();
			}
			else
			{
				Player.config['skinMc'].pro.progress_bg.buttonMode = false;
			}
		}
		private function timerDisplay(eve:MouseEvent)
		{
			Player.config['autopL'].visible = false;
			Player.config['tooltipMc'].visible = false;
			displayFun();
			eve.updateAfterEvent();
		}
		private function displayFun()
		{
			Player.config['tooltipMc'].visible = true;
			Player.config['tooltipMc'].tips.autoSize = TextFieldAutoSize.CENTER;
			Player.config['tooltipMc'].tips.text = getovertime();
			Player.config['tooltipMc'].tipm.width = Player.config['tooltipMc'].tips.width + 8;
			Player.config['tooltipMc'].x = Player.mouseX;
			Player.config['tooltipMc'].y = Player.config['stageHeight']-(Player.config['skinMc'].skin_bg.height+15);
			Player.config['tooltipMc'].ti.x = 0;
			Player.config['tooltipMc'].ti.visible = true;
			Player.config['tooltipMc'].tips.textColor = Player.config['textColor'];
			if (Player.config['tooltipMc'].x>(Player.config['stageWidth']-(Player.config['tooltipMc'].tipm.width/2)))
			{
				Player.config['tooltipMc'].x = (Player.config['stageWidth']-(Player.config['tooltipMc'].tipm.width/2))-2;
				Player.config['tooltipMc'].ti.x = (Player.config['tooltipMc'].tipm.width/2)-10;
			}
			else if (Player.config['tooltipMc'].x<(Player.config['tooltipMc'].tipm.width/2))
			{
				Player.config['tooltipMc'].x = (Player.config['tooltipMc'].tipm.width/2)+2;
				Player.config['tooltipMc'].ti.x = -((Player.config['tooltipMc'].tipm.width/2)-10);
			}
		}
		private function removetooltip(eve:MouseEvent)
		{
			Player.config['tooltipMc'].visible = false;
		}
		private function getovertime()
		{
			pcent = (Player.mouseX-(Player.config['skinMc'].pro.x-5)) / (Player.config['skinMc'].pro.width);
			if (Player.config['video'] == "youtube")
			{
				sec = pcent * Player.config['YTPlayer'].getDuration();
				if (sec>Player.config['YTPlayer'].getDuration())
				{
					sec = Player.config['YTPlayer'].getDuration();
				}
				newtime = formatTime(sec);
			}
			else
			{
				sec = pcent * Player.config['nDuration'];
				if (sec>Player.config['nDuration'])
				{
					sec = Player.config['nDuration'];
				}
				newtime = formatTime(sec);
			}
			return newtime;
		}
		// =============================== Time format ==============================================================================================
		function formatTime(t:int):String
		{
			var s:int = Math.round(t);
			var m:int = 0;
			var hr:int = 0;
			if (s > 0)
			{
				while (s > 59)
				{
					m++;
					s -=  60;
				}
				while (m > 59)
				{
					hr++;
					m -=  60;
				}
				if (hr!=0)
				{
					return String( hr + ":"+(m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s);
				}
				else
				{
					return String( m + ":"  + (s < 10 ? "0" : "") + s);
				}
			}
			else
			{
				return "0:00";
			}
		}

		// ===================================== show related video for type 1 method ================================================================
		function relatedvideosbuttonclicked(eve:MouseEvent)
		{
			Player.config['QualityBg'].visible = false;
			Player.config['skinMc'].PlayListView.mouseEnabled = false;
			var videoscale = new videoScale(Player.config,reference);
			if (Player.config['relatedview'] == false)
			{
				Player.config['tooltipMc'].tips.text = Player.config['PlayListHide'];
				if (Player.config['shareB'] == true)
				{
					if (Player.config['pauseState'] == true)
					{
						var videoplay3 = new videoPlay(Player.config);
					}
					Player.config['SocialPanel'].alpha = 0;
				}
				Player.config['pauseState'] = Player.config['isplayed'];
				Player.config['imageCount'] = 0;
				Player.config['numofimg'] = 0;
				relatedvideo = new relatedVideo(Player.config,reference);
				relatedvideo.loadrelatedvideos(Player.config);
				if (Player.config['Playbtn'].visible == false)
				{
					var videopause2 = new videoPause(Player.config);
				}
				videoscale.buttonInVis();
			}
			else
			{
				Player.config['tooltipMc'].tips.text = Player.config['PlayListView'];
				relatedvideo = new relatedVideo(Player.config,reference);
				relatedvideo.removerelated();
				Player.config['skinMc'].PlayListView.mouseEnabled = false;
				if (Player.config['Playbtn'].visible == true && Player.config['pauseState'] == true)
				{
					var videoplay2 = new videoPlay(Player.config);
				}
				videoscale.buttonVis();
			}
			setTimeout(enablePlaylistbt,500);
		}
		private function enablePlaylistbt()
		{
			Player.config['skinMc'].PlayListView.mouseEnabled = true;
		}
		//============================= get next set of related video================================================================================
		function rbtFunction(eve:MouseEvent)
		{
			Player.config['QualityBg'].visible = false;
			Player.config['autopL'].visible = false;
			Player.config['tooltipMc'].visible = false;
			Player.config['rt'] = true;
			relatedvideo = new relatedVideo(Player.config,reference);
			relatedvideo.removerelated();
			relatedvideo.loadrelatedvideos(Player.config);
		}
		//============================= get previous set of related video=============================================================================;
		function lbtFunction(eve:MouseEvent)
		{
			Player.config['QualityBg'].visible = false;
			Player.config['autopL'].visible = false;
			Player.config['tooltipMc'].visible = false;
			Player.config['rt'] = false;
			Player.config['imageCount']=Player.config['imageCount']-(Player.config['numofimg']+6);
			if (Player.config['imageCount'] < 0)
			{
				Player.config['imageCount'] = 0;
			}
			relatedvideo = new relatedVideo(Player.config,reference);
			relatedvideo.removerelated();
			relatedvideo.loadrelatedvideos(Player.config);
		}
		// ==================================== change playlist auto play value from user ============================================================;
		function channgePlaylistAutoplay(eve:MouseEvent)
		{
			Player.config['QualityBg'].visible = false;
			if (Player.config['playlist_autoplay'] == "true")
			{
				for (var g=1; g<Player.config['autopImgArr'].length; g++)
				{
					Player.config['autopImgArr'][g].img.alpha = 0.1;
				}
				Player.config['playlist_autoplay'] = "false";
				Player.config['tooltipMc'].tips.text = Player.config['autoplayOn'];
			}
			else
			{
				for (var g1=1; g1<Player.config['autopImgArr'].length; g1++)
				{
					Player.config['autopImgArr'][g1].img.alpha = 1;
				}
				Player.config['playlist_autoplay'] = "true";
				Player.config['tooltipMc'].tips.text = Player.config['autoplayOff'];
			}
		}
		//============================================== video downloads =============================================================================
		function DownLoadVideoFun(eve:MouseEvent)
		{
			Player.config['QualityBg'].visible = false;
			Tracker = new tracker(Player.config,Player.config['ref']);
			Tracker.eventTracker("Video_Download","Download","Download",0);
			var playvideo2 = new playVideo(Player.config,reference);
			playvideo2.downLoadUrl();
		}
		function openMailPanel(eve:MouseEvent)
		{
			if (Player.config["displayState"] == "fullScreen")
			{
				Player.dispatchEvent(new Event('onfullscreen'));
			}
			if (Player.config['mailB'] == false && Player.config['shareB'] == false)
			{
				Player.config['pauseState'] = Player.config['isplayed'];
			}
			Player.config['mailPanel'].result.text = Player.config['mailPanel'].form.Note.text = Player.config['mailPanel'].form.from.text = Player.config['mailPanel'].form.to.text = "";
			Player.config['mailPanel'].form.from.tabIndex = 1;
			Player.config['mailPanel'].form.to.tabIndex = 2;
			Player.config['mailPanel'].form.Note.tabIndex = 3;
			Player.config['mailPanel'].form.bt.tabIndex = 4;
			Player.config['mailPanel'].form.from.tabIndex = 1;
			Player.config['Playbtn'].alpha = 0;
			if (Player.config['shareB'] == true)
			{
				var EmailSS = new scocialSharePanel(Player.config,reference);
				EmailSS.mailclosed();
			}
			var Email = new email(Player.config,reference);
			Email.emailFun();
			Player.dispatchEvent(new Event('focus'));
			var videoscaleS2 = new videoScale(Player.config,reference);
			videoscaleS2.buttonVis();
		}
	}
}