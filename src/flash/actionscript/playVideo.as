package actionscript
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.text.*;
	import flash.text.TextFieldAutoSize;
	import flash.display.MovieClip;
	import flash.external.*;
	import flash.utils.setTimeout;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.media.SoundTransform;
	import flash.display.*;
	import flash.events.Event;
	import flash.utils.*;
	import flash.net.URLLoader;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.system.System;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.net.*;

	public class playVideo
	{
		private var config:Object;
		private var reference:Sprite;
		private var nc:NetConnection;
		private var myVideo:Video;
		private var lighttPd:lighttpd;
		private var pas:Boolean;
		private var stbytes = Number;
		private var timeEnd = Number;
		public var relatedvideo:relatedVideo;
		private var nopreviewMc:nopreview;
		private var imgLoader:Loader;
		private var imagePath:URLRequest;
		private var adclickdata:URLLoader;
		private var adclickdata2:URLLoader;
		private var adimpdata:URLLoader;
		private var adimpdata2:URLLoader;
		private var MessageClass:Message;
		private var slideRelatedVideo:sliderelatedVideo;
		private var objClient:Object;
		private var Tracker:tracker;
		private var preview:Preview;
		private var seti:Number;
		private var QText:TextField;
		private var Qclip:MovieClip;
		private var SClipArr:Array;
		private var STextArr:Array;
		private var mc:MovieClip;
		private var mc2:MovieClip;
		private var c:Number;
		private var MemberAccess:memberAccess
		private var keyframes:Object;
		private var ImAlaoded:Boolean;
		private var subTitle:loadSubtitle;
		private var subtitleArr:Array;
		private var cls:Number;
		
		public function playVideo(cfg,ref)
		{
			Security.allowDomain("*");
			cfg['hd1080'] = '1080p HD';
			cfg['hd720'] = '720p HD';
			cfg['large'] = '480p';
			cfg['medium'] = '360p';
			cfg['small'] = '240p';
			cfg['tiny'] = '144p';
			cfg['LOW'] = 'low';
			cfg['HIGH'] = 'high';
			
			cfg['auto'] = 'Auto';
			cfg['hd720'] = '720p HD';
			cfg['hq'] = '480p';
			cfg['sd'] = '380p';
			cfg['ld'] = '240p';
			//========================================== Initialize button visible ==============================================================================
			cfg['Playbtn'].scaleX = cfg['Playbtn'].scaleY = 1;
			/*if (cfg['skinMc'].y > cfg['stageHeight'])
			{
				cfg['Playbtn'].x = cfg['buffer_Mc'].x = cfg['stageWidth'] / 2;
				cfg['Playbtn'].y = cfg['buffer_Mc'].y = cfg['stageHeight'] / 2;
			}
			else
			{*/
				cfg['Playbtn'].x = cfg['buffer_Mc'].x = cfg['stageWidth'] / 2;
				cfg['Playbtn'].y = cfg['buffer_Mc'].y = (cfg['stageHeight']-25)/2;
			//}
			timeEnd = 1;
			pas = true;
			reference = ref;
			config = cfg;
			config['ref'] = ref;
			MessageClass = new Message(config,reference);
			if(config['skinMc'].pp.play_btn.visible == true || config['skinMc'].pp.pause_btn.visible == true)config['skinMc'].pp.Replay.visible = false;
		}
		public function playFun()
		{
			ImAlaoded  = false;
			config['adsLoader'] = undefined;
			config['inc'] = 0;
			clearInterval(config['midinterval']);
			config['buffer_Mc'].visible = true;
			config['skinMc'].pro.seek_bar.width = config['skinMc'].pro.buffer_bar.width = config['skinMc'].pro.pointer.x = 0;
			config['skinMc'].pp.play_btn.visible = false;
			config['skinMc'].pp.pause_btn.visible = true;
			config['skinMc'].pp.Replay.visible = false;
			config['zoomInMc'].visible = true;
			config['zoomOutMc'].visible = false;
			config['imA'] = false;
			config['dailyBG'].tabEnabled = false;
			config['dailyBG'].visible = false;
			config['skinMc'].y = config['stageHeight']-(config['skinMc'].skin_bg.height);
			config['skinMc'].indication.visible = false;
			if (config['backBg'])
			{
				config['backBg'].addEventListener(MouseEvent.MOUSE_DOWN,PlayPausebtnClicked);
			}
			config['playeruI'].removeEventListener(Event.ENTER_FRAME, updateStremDisplay);
			config['autopL'].visible = false;
			config['tooltipMc'].visible = false;
			//========================================== play preroll or postroll ads ==============================================================================
			if (config['mov'] == 1 || config['mov'] == 3)
			{
				config['skinMc'].indication.text = ""
				if (config['showTag'] == "true")
				{
					config['tagline'].visible = true;
					config['tagline'].txt.text = "";
					config['tagline'].txt.autoSize = TextFieldAutoSize.LEFT;
					config['tagline'].txt.htmlText = config['adsDesArr'][config['adindex']];
					config['tagline'].txt.textColor = config['textColor'];
					config['tagline'].dot.textColor = config['textColor'];
				}
				config['skinMc'].indication.visible = true;
				config['skinMc'].indication.textColor = config['textColor'];
				config['skinMc'].PlayListView.visible = config['skinMc'].hd.visible = config['skinMc'].autoPlayButton.visible = config['skinMc'].ti.visible = config['skinMc'].ti2.visible = config['skinMc'].pro.visible = false;
				if (config['adsSkip'] == "true")
				{
					if (config['thumb'] == undefined || config['thumb'] == "")
					{
						nopreviewMc=new nopreview();
						nopreviewMc.width = 90;
						nopreviewMc.height = 50;
						config['labelBt'].bg.addChild(nopreviewMc);
					}
					else
					{
						skipImageload();
					}
					config['labelBt'].txt.visible = false;
					config['labelBt'].textt.visible = true;
					config['labelBt'].bg.gotoAndStop(1);
				}
				else
				{
					config['labelBt'].visible = false;
				}
				config['adIndicator'].bg.width = config['stageWidth'];
				config['adIndicator'].adseek.width = 0;
				config['labelBt'].addEventListener(MouseEvent.MOUSE_DOWN,closeAdsFun);

				if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
				{
					if (config['thuMc'] != undefined)
					{
						config['thuMc'].visible = false;
					}
				}
				buttonInVis();
				var skinArrnge3 = new skinarrnge(config);
			}
			else
			{
				while (config['subTiltleBg'].con.numChildren > 0)
				{
					config['subTiltleBg'].con.removeChildAt(0);
				}
				subtitleArr = new Array()
				if(config['subTitleArr'][config['vid']] != "" && config['subTitleArr'][config['vid']] != undefined)
				{
					subtitleArr = config['subTitleArr'][config['vid']].split(',')
					SClipArr = new Array()
					STextArr = new Array()
					panelcreate(config['subTiltleBg'],subtitleArr,SClipArr);
					subTitle = new loadSubtitle(config,subtitleArr[0])
					config['cc'] = "true" 
					var skinArrngea = new skinarrnge(config);
					for (var f=1; f<=subtitleArr.length; f++)
					{
						STextArr[f].alpha = 0.5;
					}
					STextArr[1].alpha = 1
					config['subTiltleBg'].poi.y = SClipArr[1].y + 10;
				}
				else
				{
					config['cc'] = "false" 
					var skinArrngea = new skinarrnge(config);
				}
				if (config['local'] != 'true' && config['embedplayer'] != "true")
				{
					if(reference.root.loaderInfo.parameters['baserefWP'] || reference.root.loaderInfo.parameters['baserefW'])
					{
						if(reference.root.loaderInfo.parameters['videodata'])ExternalInterface.call(reference.root.loaderInfo.parameters['videodata'],config['vid_id'], config['title'])
			            else ExternalInterface.call('current_video',config['vid_id'], config['title'])
					}
					else
					{
						if(reference.root.loaderInfo.parameters['mid'])ExternalInterface.call('currentvideom',config['vid_id'], config['title'], config['caption_video'][config['vid']],config['video_views'][config['vid']]);
						else{
							 
							 ExternalInterface.call('getvideoData',config['vid_id'],config['title'], config['caption_video'][config['vid']]);
						}
					}
					
				}
				Tracker = new tracker(config,config['ref']);
				Tracker.eventTracker("Video_Start","Start","Play_btn",0);
				if (config['showTag'] == "true")
				{
					if (config['playeruI'].root.loaderInfo.parameters['tagline'])
					{
						config['tagline'].visible = true;
						config['tagline'].txt.text = "";
						config['tagline'].txt.autoSize = TextFieldAutoSize.LEFT;
						config['tagline'].txt.htmlText = config['playeruI'].root.loaderInfo.parameters['tagline'];
						config['tagline'].txt.textColor = config['textColor'];
						config['tagline'].dot.textColor = config['textColor'];
					}
					else if (config['caption_video'][config['vid']] != undefined)
					{
						config['tagline'].visible = true;
						config['tagline'].txt.text = "";
						config['tagline'].txt.autoSize = TextFieldAutoSize.LEFT;
						
						var myString:String = config['caption_video'][config['vid']];
						var removeHtmlRegExp:RegExp = new RegExp("<[^<]+?>", "gi");
						myString = myString.replace(removeHtmlRegExp, "");
						
						config['tagline'].txt.htmlText = myString;
						config['tagline'].txt.textColor = config['textColor'];
						config['tagline'].dot.textColor = config['textColor'];
					}
					var videoscale_tag = new videoScale(config,reference);
					videoscale_tag.taglineposition();
				}
				config['skinMc'].indication.visible = false;
				if (config['timer'] == "true")
				{
					if (config['isLive'] != "true")
					{
						config['skinMc'].ti.visible = config['skinMc'].ti2.visible = true;
					}
					else
					{
						config['skinMc'].ti.visible = true;
						config['skinMc'].ti2.visible = false;
					}
				}
				else
				{
					config['skinMc'].ti.visible = config['skinMc'].ti2.visible = false;
				}
				if (config['playlist_auto'] == "true")
				{
					config['skinMc'].autoPlayButton.visible = true;
				}
				if (config['hd'] == "true")
				{
					config['skinMc'].hd.visible = true;
				}
				if (config['showPlaylistB'] == "true")
				{
					config['skinMc'].PlayListView.visible = true;
				}
				var skinArrnge2 = new skinarrnge(config);
				if (config['isLive'] == "true")
				{
					setLiveText();
				}
				else
				{
					config['skinMc'].pro.visible = true;
				}
				config['skinMc'].visible = true;
				config['setnum'] = 0;
				if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
				{
					if (config['thuMc'] != undefined)
					{
						config['thuMc'].visible = true;
					}
				}
				if (config['showTag'] == "true")
				{
					config['tagline'].addEventListener(MouseEvent.MOUSE_DOWN,gotovideoTarget);
				}
				buttonVis();
			}
			if(config['member'] == 'false')
			{
				MemberAccess = new memberAccess(reference,config)
			}
			else
			{
				config['errorMc'].visible = false
				if(String(config['streamer']) == "undefined"){config['streamer'] = "";}
				if (config['file'] != undefined)
				{
					if (config['file'].indexOf('youtube.com') > -1 || config['file'].indexOf('youtu.be') > -1 || config['file'].indexOf('dailymotion') > -1 || config['file'].indexOf('viddler') > -1 || config['file'].indexOf('vimeo.com') > -1)
					{
						playYoutubeVideo();
					}
					else if(config['file'].indexOf('.f4m') > -1 || config['file'].indexOf('.m3u8') > -1 )
					{
						config['HLSandHDSstream'] = new HLSandHDS(config,reference);
						config['HLSandHDSstream'].loadHDSHLS()
					}
					else
					{
						playStreamVideo();
					}
				}
				else
				{
					MessageClass.show("There is no videos in this playlist");
				}
				buttonVis();
				config['isplayed'] = true;
			}
		}
		private function skipImageload()
		{
			imgLoader  = new Loader();
			imagePath = new URLRequest(config['thumb']);
			imgLoader.load(imagePath);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,imgLoaded);
			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageError);
			config['labelBt'].bg.addChild(imgLoader);
		}
		private function imageError(evt:IOErrorEvent)
		{
			if (config['thumb'].indexOf("maxresdefault.jpg") > -1)
			{
				config['thumb'] = config['thumb'].replace('maxresdefault.jpg','hqdefault.jpg');
				skipImageload();
			}
			else if (config['thumb'].indexOf("hqdefault.jpg") > -1)
			{
				config['thumb'] = config['thumb'].replace('hqdefault.jpg','mqdefault.jpg');
				skipImageload();
			}
			else
			{
				config['thumb'] = config['baseurl'] + "images/default_thumb.jpg";
				skipImageload();
			}
		}
		private function buttonVis()
		{
			if (config['mov'] == 2)
			{
				var videoscale = new videoScale(config,reference);
				videoscale.buttonVis();
			}
		}
		private function buttonInVis()
		{
			var videoscale_InVis = new videoScale(config,reference);
			videoscale_InVis.buttonInVis();
		}
		public function setLiveText()
		{
			config['skinMc'].indication.visible = true;
			config['skinMc'].indication.textColor = config['textColor'];
			config['skinMc'].indication.autoSize = TextFieldAutoSize.LEFT;
			config['skinMc'].indication.text = String(config['live']);
			config['skinMc'].pro.visible = false;
			var format:TextFormat = new TextFormat();
			if (config["displayState"] == "normal")
			{
				format.size = config['stageWidth'] / 50;
			}
			else
			{
				format.size = config['stageWidth'] / 76;
			}
			config['skinMc'].indication.setTextFormat(format);
			if (config['showPlaylistB'] == "true")
			{
				config['skinMc'].indication.x = config['skinMc'].PlayListView.x - (config['skinMc'].indication.width+10);
			}
			else
			{
				config['skinMc'].indication.x = (config['yposi']-30) - (config['skinMc'].indication.width+10);
			}
			listeneradd()
		}//========================================== load Image for ads preview ==============================================================================
		function imgLoaded(evt:Event)
		{
			evt.target.loader.width = 90;
			evt.target.loader.height = 50;
			Bitmap(evt.target.loader.content).smoothing = true;
		}
		//========================================== Loader function for "YOUTUBE","VIDDLER","DAILYMOTION" videos==============================================================================
		private function playYoutubeVideo()
		{
			hdEnabledFun();
			config['YoutubeLoader'] = new Loader();
			if (config['file'].indexOf('youtube.com') > -1 || config['file'].indexOf('youtu.be') > -1)
			{
				config['YoutubeLoader'].contentLoaderInfo.addEventListener(Event.COMPLETE, youtube_onLoaderInit);
				config['YoutubeLoader'].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
				config['buffer_Mc'].visible = true;
				config['buffer_Mc'].alpha =1
				config['YoutubeLoader'].load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			}
			else if (config['file'].indexOf('dailymotion') > -1)
			{
				config['YoutubeLoader'].contentLoaderInfo.addEventListener(Event.COMPLETE, DailyMotion_LoaderInit);
				config['YoutubeLoader'].load(new URLRequest("http://www.dailymotion.com/swf?enableApi=1&chromeless=1&explicit=0&hideInfos=1"));
			}
			else if (config['file'].indexOf('viddler') > -1)
			{
				config['YoutubeLoader'].contentLoaderInfo.addEventListener(Event.COMPLETE, viddler_onLoaderInit);
				config['YoutubeLoader'].load(new URLRequest("http://www.viddler.com/chromeless/"));
			}
			else
			{
				//loadVideoByIdFun()
			}
		}
		private function loadError(eve:IOErrorEvent)
		{
			MessageClass.show("Net connection not available in your system");
		}
		private function viddler_onLoaderInit(event:Event):void
		{
			reference.addChild(config['YoutubeLoader']);
			config['YoutubeLoader'].content.addEventListener("onReady", viddler_onPlayerReady);
		}
		private function viddler_onPlayerReady(event:Event):void
		{
			config['YTPlayer'] = config['YoutubeLoader'].content;
			config['shareClip'] = config['YoutubeLoader'].content;
			config['shareClip'].tabEnabled = false;
			loadVideoByIdFun();
		}
		private function DailyMotion_LoaderInit(e:Event)
		{
			reference.addChild(config['YoutubeLoader']);
			config['YoutubeLoader'].content.addEventListener("onReady", ondailymotionPlayerReady);
		}
		private function ondailymotionPlayerReady(e:Event):void
		{
			config['YTPlayer'] = config['YoutubeLoader'].content;
			config['shareClip'] = config['YoutubeLoader'].content;
			config['shareClip'].tabEnabled = false;
			loadVideoByIdFun();
		}
		private function youtube_onLoaderInit(e:Event)
		{
			reference.addChild(config['YoutubeLoader']);
			config['YoutubeLoader'].content.addEventListener("onReady", onYoutubePlayerReady);
		}
		private function onYoutubePlayerReady(e:Event):void
		{
			config['YTPlayer'] = config['YoutubeLoader'].content;
			config['shareClip'] = config['YoutubeLoader'].content;
			config['shareClip'].tabEnabled = false;
			config['YTPlayer'].alpha = 0
			loadVideoByIdFun();
		}
		private function loadVideoByIdFun()
		{
			if (config['file'].indexOf('youtube.com') > -1 || config['file'].indexOf('youtu.be') > -1 || config['file'].indexOf('dailymotion') > -1 || config['file'].indexOf('viddler') > -1 || config['file'].indexOf('vimeo.com') > -1)
			{
				if (config['file'].indexOf('dailymotion') > -1)
				{
					config['YTPlayer'].loadVideoById(getdailymotionId(config['file']));
					config['dailyBG'].buttonMode = true;
					config['dailyBG'].addEventListener(MouseEvent.MOUSE_DOWN,PlayPausebtnClicked);
					config['buffer_Mc'].visible = false;
				}
				else if (config['file'].indexOf('youtube.com') > -1 || config['file'].indexOf('youtu.be') > -1)
				{
					config['YTPlayer'].alpha = 0
					config['dailyBG'].visible = false;
					if(config['mov']!= 2)config['YTPlayer'].loadVideoById(getyoutube_ID(config['file']), 0, "default");
					else if (config['videoType'] == 'hd')
					{
						config['YTPlayer'].loadVideoById(getyoutube_ID(config['file']), 0, "default");
					}
					else
					{
						config['YTPlayer'].loadVideoById(getyoutube_ID(config['file']), 0, "small");
					}
					config['YTPlayer'].addEventListener(MouseEvent.MOUSE_DOWN,PlayPausebtnClicked);
				}
				else if(config['file'].indexOf('vimeo.com') > -1)
				{
					/*config['YTPlayer'] = new VimeoPlayer("79541124", config['stageWidth'], config['stageHeight'])
					reference.addChild(config['YTPlayer']);
					config['dailyBG'].buttonMode = true;
					config['dailyBG'].visible=true
					config['dailyBG'].addEventListener(MouseEvent.MOUSE_DOWN,PlayPausebtnClicked);
					config['dailyBG'].width = config['stageWidth']
				    config['dailyBG'].height = config['stageHeight']
					config['YTPlayer'].mouseEnabled = false;*/
				}
				else
				{
					config['dailyBG'].visible = true;
					if (config['videoType'] == 'hd')
					{
						config['YTPlayer'].loadVideoById(get_viddler__ID(config['file']), 0, "large");
					}
					else
					{
						config['YTPlayer'].loadVideoById(get_viddler__ID(config['file']), 0, "small");
					}
					config['YTPlayer'].addEventListener(MouseEvent.MOUSE_DOWN,PlayPausebtnClicked);
					config['dailyBG'].buttonMode = true;
					config['dailyBG'].addEventListener(MouseEvent.MOUSE_DOWN,PlayPausebtnClicked);
					config['buffer_Mc'].visible = false;
				}
				var otherindex:Number;
				if (config['file'].indexOf('dailymotion') > -1)
				{
					otherindex = reference.getChildIndex(config['dailyBG']);
				}
				else
				{
					otherindex = reference.getChildIndex(config['backBg']);
				}
			    if(config['file'].indexOf('vimeo.com') > -1)
				{
					reference.setChildIndex(config['YTPlayer'], otherindex+1);
				}
				else 
				{
					config['YTPlayer'].setSize(config['stageWidth'], config['stageHeight'])
					reference.setChildIndex(config['YoutubeLoader'], otherindex+1);
				}
				
				config['YTPlayer'].buttonMode = true;
				
				config['playeruI'].addEventListener(Event.ENTER_FRAME, updateStremDisplay);
				config['video'] = "youtube";
				config['skinMc'].pro.progress_bg.addEventListener(MouseEvent.MOUSE_DOWN,progressbgClicked);
				config['YTPlayer'].addEventListener("onError", onPlayerError);
				if (config['allowmidroll'] == "true" && config['mov'] == 2 && config['allow_imaAds'] == 'false')
				{
					var midRollAds = new midrollAds(config,reference);
					midRollAds.midrollsetup();
				}
				else
				{
					if (config['mov'] != 2)
					{
						adimpression();
					}
				}
				config['skinMc'].pro.buffer_end.visible = config['skinMc'].pro.seek_end.visible = config['skinMc'].pro.seekS.visible = config['skinMc'].pro.bufferS.visible = true;
				buttonVis();
				var skinArrngeS = new skinarrnge(config);
			}
		}
		function getQualityPanel()
		{
			while (config['QualityBg'].con.numChildren > 0)
			{
				config['QualityBg'].con.removeChildAt(0);
			}
			if (config['video'] == "youtube")
			{
				if (config['YTPlayer'].getPlayerState() != -1)
				{
					clearInterval(seti);
					config['QualityArray'] = new Array();
					config['QualityArray'] = config['YTPlayer'].getAvailableQualityLevels();
					config['QTextArr'] = new Array();
					config['QClipArr'] = new Array();
					panelcreate(config['QualityBg'],config['QualityArray'],config['QClipArr']);
				}
			}
			else if (config['hd']=="true")
			{
				clearInterval(seti);
				config['QualityArray'] = new Array();
				config['QualityArray'] = ['HIGH','LOW'];
				config['QTextArr'] = new Array();
				config['QClipArr'] = new Array();
				panelcreate(config['QualityBg'],config['QualityArray'],config['QClipArr']);
			}
			else
			{
				clearInterval(seti);
			}
		}
		public function panelcreate(panel:MovieClip,valueArr:Array,QArr:Array)
		{
			for (var t=0; t<=valueArr.length; t++)
			{
				Qclip = new MovieClip();
				panel.con.addChild(Qclip);
				QArr.push(Qclip);
				if(panel.name == "QA")config['QClipArr'].push(Qclip);
				QText = new TextField();
				Qclip.addChild(QText);
				QText.height = 25;
				QText.width = 80;
				QText.name = "QText" + t;
				Qclip.name = "Qclip" + t;
				QText.mouseEnabled = false;
				if (t==0)
				{
					QText.autoSize = TextFieldAutoSize.CENTER;
					if(panel.name == "QA")
					{
						config['QTextArr'].push(QText);
						if (config['Quality'] != undefined)QText.htmlText = "<b> " + config['Quality'] + " </b>";
						else QText.htmlText = "<b> " + "Quality" + " </b>";
					}
					else
					{
						STextArr.push(QText);
						if (config['Caption'] != undefined)QText.htmlText = "<b> " + config['Caption'] + " </b>";
						else QText.htmlText = "<b> " + "Captions" + " </b>";
					}
					Qclip.y = t*(QText.height);
				}
				else
				{
					if(panel.name == "QA")
					{
						config['QTextArr'].push(QText);
						if (config['file'].indexOf('youtube.com') > -1 || config['file'].indexOf('youtu.be') > -1 || config['file'].indexOf('dailymotion') > -1)QText.text = "       " + config[valueArr[t - 1]];
						else QText.text = "     " + valueArr[t - 1];
						Qclip.addEventListener(MouseEvent.MOUSE_DOWN,ChangevideoQuality);
					}
					else
					{
						STextArr.push(QText);
						var asr:Array = new Array()
						if (valueArr[t - 1].indexOf('http') > -1)
						{
							asr = valueArr[t - 1].split('/')
							var vc:String = asr[asr.length-1]
							asr = new Array()
							asr = vc.split('_')
							vc = asr[1]
							asr = new Array()
							asr = vc.split('.')
						}
						else asr = valueArr[t - 1].split('.')
						QText.text = "     " + asr[0]
						Qclip.addEventListener(MouseEvent.MOUSE_DOWN,Changevideosubtitle);
					}
					Qclip.y = t*(QText.height);
					QText.alpha = 0.5;
					Qclip.buttonMode = true;
					QText.mouseEnabled = false;
					Qclip.addEventListener(MouseEvent.MOUSE_OVER,QclipOverFun);
					
				}
				QText.selectable = false;
				QText.textColor = config['textColor'];
			}
			panel.bgMc.bg.height = ((valueArr.length+1)*25);
			panel.y= config['skinMc'].y-(panel.height-5);
			if(panel.name == "QA" && config['video'] == "youtube" )
			{
				if(config['video'] == "youtube")
				{
					for (var tt=0; tt<config['QualityArray'].length; tt++)
					{
						if (config['YTPlayer'].getPlaybackQuality() == config['QualityArray'][tt] && config['QClipArr'] != null)
						{
							config['QualityBg'].poi.y = ((tt+1)*25)+5;
							config['QTextArr'][tt + 1].alpha = 1;
							config['QClipArr'] = new Array()
							break;
						}
					}
				}
				else
				{
					if (config['hd'] == "true" && config['QClipArr'] != null)
					{
						if (config['HD_default'] == 'true')
						{
							config['QualityBg'].poi.y = config['QClipArr'][1].y + 10;
							config['QTextArr'][1].alpha = 1;
							config['skinMc'].hd.hdOffmode.visible = false;
							config['skinMc'].hd.hdOnmode.visible = true;
						}
						else
						{
							config['QualityBg'].poi.y = config['QClipArr'][2].y + 10;
							config['QTextArr'][2].alpha = 1;
							config['skinMc'].hd.hdOffmode.visible = true;
							config['skinMc'].hd.hdOnmode.visible = false;
						}
					}
				}
			}
		}
		public function Changevideosubtitle(eve:MouseEvent)
		{
			config['QualityBg'].visible = false;
			config['subTiltleBg'].visible = false;
			for (var f=1; f<=subtitleArr.length; f++)
			{
				STextArr[f].alpha = 0.5;
			}
			c = Number(eve.currentTarget.name.substr(5));
			subTitle = new loadSubtitle(config,subtitleArr[c-1])
			config['subTiltleBg'].poi.y = SClipArr[c].y + 10;
			STextArr[c].alpha = 1;
		}
		public function ChangevideoQuality(eve:MouseEvent)
		{
			config['QualityBg'].visible = false;
			config['subTiltleBg'].visible = false;
			for (var f=1; f<=config['QualityArray'].length; f++)
			{
				config['QTextArr'][f].alpha = 0.5;
			}
			if (config['video'] == "youtube")
			{
				if (config['file'].indexOf('youtube.com') > -1 || config['file'].indexOf('youtu.be') > -1)config['YTPlayer'].seekTo(Math.round(config['currentTime']),true);
				c = Number(eve.currentTarget.name.substr(5));
				config['YTPlayer'].setPlaybackQuality(config['QualityArray'][c-1]);
			}
			else
			{
				c = Number(eve.currentTarget.name.substr(5));
				if (c==1)
				{
					config['HD_default'] = "true";
					config['hdclicked'] = true;
					if (config['streamer'] != undefined && config['streamer'].indexOf("rtmp") > -1)
					{
						config['startSec'] = config['currentTime'];
					}
					stopVideoPlay();
				}
				else if (c==2)
				{
					config['HD_default'] = "false";
					config['hdclicked'] = true;
					if (config['streamer'] != undefined && config['streamer'].indexOf("rtmp") > -1)
					{
						config['startSec'] = config['currentTime'];
					}
					stopVideoPlay();
				}
			}
		}
		public function QclipOverFun(eve:MouseEvent)
		{
			mc = eve.currentTarget as MovieClip;
			mc.removeEventListener(MouseEvent.MOUSE_OVER,QclipOverFun);
			mc.addEventListener(MouseEvent.MOUSE_OUT,QclipOutFun);
			c = Number(mc.name.substr(5));
			if(eve.currentTarget.parent.parent.name == "QA")
			{
				config['QTextArr'][c].backgroundColor = 0x3E3E3E;
				config['QTextArr'][c].background = true;
			}
			else
			{
				STextArr[c].backgroundColor = 0x3E3E3E;
				STextArr[c].background = true;
			}
		}
		public function QclipOutFun(eve:MouseEvent)
		{
			mc2 = eve.currentTarget as MovieClip;
			mc2.addEventListener(MouseEvent.MOUSE_OVER,QclipOverFun);
			mc2.removeEventListener(MouseEvent.MOUSE_OUT,QclipOutFun);
			c = Number(mc.name.substr(5));
			if(eve.currentTarget.parent.parent.name == "QA")config['QTextArr'][c].background = false;
			else STextArr[c].background = false;
		}
		function onPlayerError(event:Event)
		{
			config['buffer_Mc'].visible = false;
			if (config['mov'] != 2)
			{
				stopVideoPlay();
			}
			else
			{
				buttonInVis();
				removeYoutubevidlervideos();
				var errornum:Number = Object(event).data;
				if (errornum==150 || errornum==101)
				{
					MessageClass.show(config['video_not_allow_embed_player']);
				}
				else if (errornum==2)
				{
					MessageClass.show(config['youtube_ID_Invalid']);
				}
				else if (errornum==100 || errornum==111 || errornum==0 || errornum==112 )
				{
					MessageClass.show(config['video_Removed_or_private']);
				}
			}
		}//========================================== Get dailymotion video ID ==============================================================================
		private function getdailymotionId(st)
		{
			var arrss:Array = new Array();
			if (st.indexOf('/video/') > -1)
			{
				arrss = st.split('/video/');
			}
			else if (st.indexOf('#video=') > -1)
			{
				arrss = st.split('#video=');
			}
			st = arrss[1];
			arrss = st.split('_');
			st = arrss[0]
			return st;
		}
		//========================================== Get youtube video ID ==============================================================================
		private function getyoutube_ID(url:String):String
		{
			if (url.indexOf('youtu.be/') > -1)
			{
				var arrsY:Array = url.split('youtu.be/');
				var strY = arrsY[1];
				return strY;
			}
			else
			{
				url = url.replace('v/','v=');
				var arrss:Array = url.split('v=');
				var str = arrss[1];
				arrss=new Array();
				arrss = str.split('&');
				str = arrss[0];
				arrss=new Array();
				arrss = str.split('feature');
				str = arrss[0];
				arrss=new Array();
				arrss = str.split('?');
				str = arrss[0];
				return str;
			}
		}
		//========================================== Get viddler video ID ==============================================================================
		private function get_viddler__ID(url:String)
		{
			var viddlerArray:Array = url.split('/v/');
			url = viddlerArray[1];
			return url;
		}
		//========================================== get RTMP url ID ==============================================================================
		private function getrtmpID(url:String):String
		{
			var ext:String = url.substr(-4);
			if (ext=='.mp4' || ext=='.mov' || ext=='.m4v' || ext=='.aac' || ext=='.m4a' || ext=='.f4v')
			{
				return 'mp4:'+url;
			}
			else if (ext == '.flv')
			{
				return url.substr(0,url.length-4);
			}
			else
			{
				return url;
			}
		}
		//========================================== ctreate NetConnection for streaming videos ==============================================================================
		private function playStreamVideo()
		{
			hdEnabledFun();
			config['buffer_Mc'].visible = true;
			config['buffer_Mc'].alpha = 1;
			config['meta'] = false;
			config['off'] = config['timeOffset'] = config['pixelOffset'] = 0;
			config['myVideo'] = new MovieClip();
			reference.addChild(config['myVideo']);
			config['myVideo'].tabEnabled = false;
			Security.allowDomain("*");
			if (config['streamer'] == "")
			{
				if (config['file'].indexOf('http') > -1)
				{
					config['file'] = config['file'];
				}
				else
				{
					config['file'] = config['baseurl'] + "" + config['file'];
				}
			}
			NetConnection.defaultObjectEncoding = flash.net.ObjectEncoding.AMF0;
			nc = new NetConnection();
			nc.objectEncoding = flash.net.ObjectEncoding.AMF0;
			nc.connect(null);
			config['video'] = "stream";
			config['file'] = unescape(decodeURI(config['file']));
			if (config['streamer'] != undefined && config['streamer'] != "" && config['mov'] == 2)
			{
				if (config['streamer'].indexOf("rtmp") > -1)
				{
					config['streamer'] = unescape(config['streamer']);
					config['file'] = getrtmpID(config['file']);
					nc.connect(config['streamer']);
					nc.call("FCSubscribe",null,config['file']);
					nc.addEventListener(NetStatusEvent.NET_STATUS,connectStatusHandler);
				}
				else if (config['streamer'].indexOf("pseudostreaming") > -1)
				{
					lighttPd = new lighttpd(config);
					config['file'] = lighttPd.getlighttpdUrl();
					config['skinMc'].pro.progress_bg.addEventListener(MouseEvent.MOUSE_DOWN,progressbgClicked);
					connect();
				}
			}
			else
			{
				connect();
			}
			buttonVis();
		}
		private function connectStatusHandler(event:NetStatusEvent)
		{
			if (event.info.code == 'NetConnection.Connect.Success')
			{
				nc.call("FCSubscribe",null,config['file']);
				connect();
				nc.removeEventListener(NetStatusEvent.NET_STATUS, connectStatusHandler);
			}
			else if (event.info.code =='NetConnection.Connect.Failed')
			{
				MessageClass.show(config['streaming_connection_failed']);
			}
		}
		//========================================== Connect streaming video to netStream ==============================================================================
		private function connect()
		{
			config['shareClip'] = null;
		    config['stream']  = new NetStream(nc);
			objClient= new Object();
			config['stream'].client = objClient;
			config['stream'].checkPolicyFile = true;
			objClient.onMetaData = flvOnMetaData;
			if (config['file'].indexOf('.mp3') > -1 )
			{
				preview = new Preview(config['ref'],config);
				preview.loadPreview();
				config['audio'] = new Sound(new URLRequest(config['file']));
				config['audio'].addEventListener(Event.COMPLETE, doLoadComplete);
				config['audioChannel'] = new SoundChannel();
				config['audioChannel'] = config['audio'].play();
				config['audioChannel'].addEventListener(Event.SOUND_COMPLETE, doSoundComplete);
				config['audio'].addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				config['shareClip'] = config['precontainer'];
			}
			else
			{
				if (config['file'].indexOf('.m4a') > -1 )
				{
					preview = new Preview(config['ref'],config);
				    preview.loadPreview();
					config['stream'].bufferTime = config['buffer'];
					config['stream'].play(config['file']);
				}
				else
				{
					myVideo = new Video(config['stageWidth'],config['stageHeight']);
					config['myVideo'].addChild(myVideo);
					config['shareClip'] = config['myVideo'];
					config['myVideo'].visible = false;
					var otherindex = reference.getChildIndex(config['backBg']);
					reference.setChildIndex(config['myVideo'], otherindex+1);
					myVideo.attachNetStream(config['stream']);
					myVideo.smoothing = true;
					myVideo.deblocking = 1;
					config['stream'].bufferTime = config['buffer'];
					config['stream'].play(config['file']);
					config['myVideo'].buttonMode = true;
				}
			}
			config['shareClip'].addEventListener(MouseEvent.MOUSE_DOWN,PlayPausebtnClicked);
			config['shareClip'].doubleClickEnabled = true;
			config['shareClip'].addEventListener( MouseEvent.DOUBLE_CLICK, FullscreenFun);
			if (config['mov'] == 1 || config['mov'] == 3)
			{
				var otherindex2 = reference.getChildIndex(config['myVideo']);
				reference.setChildIndex(config['adIndicator'], otherindex2+1);
				reference.setChildIndex(config['labelBt'], otherindex2+2);
				adimpression();
			}
			else
			{
				if (config['allowmidroll'] == "true" && config['mov'] == 2 && config['allow_imaAds'] == "false")
				{
					var midRollAds2 = new midrollAds(config,reference);
					midRollAds2.midrollsetup();
				}
			}
			config['stream'].addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		}
		private function errorHandler(event:IOErrorEvent):void
		{
			buttonInVis();
			MessageClass.show(config['audio_not_found']);
		}
		private function doLoadComplete(eve:Event)
		{
			config['buffer_Mc'].visible = false;
			var totalSeconds:Number = Math.floor(config['audio'].length / 1000);
			var minutesTotal:Number = totalSeconds / 60;
			config['nDuration'] = totalSeconds;
			config['playeruI'].addEventListener(Event.ENTER_FRAME, updateStremDisplay);
		}
		function doSoundComplete(eve:Event)
		{
			config['playeruI'].removeEventListener(Event.ENTER_FRAME, updateStremDisplay);
			stopVideoPlay();
		}
		//========================================== Get video date(onMetaData) ==============================================================================
		private function flvOnMetaData(obj:Object):void
		{
			if(obj.width == undefined)
			{
				obj.width = 300
				obj.height = 250
			}
			//if(obj.width != undefined)
			//{
				config['skinMc'].pro.buffer_end.visible = config['skinMc'].pro.seek_end.visible = config['skinMc'].pro.seekS.visible = config['skinMc'].pro.bufferS.visible = true;
				if (config['meta'] == false)
				{
					config['meta'] = true;
					if (obj.seekpoints)
					{
						config['mp4'] = true;
						keyframes = new Object()
						if(config['streamer'] != undefined && config['streamer'].indexOf("pseudostreaming") > -1)keyframes = convertSeekpoints(obj.seekpoints);
						keyframes = obj.keyframes
					}
					else
					{
						config['mp4'] = false;
						keyframes = new Object()
						keyframes = obj.keyframes;
					}
					config['nDuration'] = Math.ceil(obj.duration);
					
				}
				config['keyframes'] = keyframes
				config['currentTime'] = config['stream'].time;
				if(obj.width != undefined)config['org_width'] = Number(obj.width);
				if(obj.height != undefined)config['org_height'] = Number(obj.height);
				config['vidscale'] = Number(obj.width) / Number(obj.height);
				config['playeruI'].addEventListener(Event.ENTER_FRAME, updateStremDisplay);
				config['obj'] = obj;
				if (config['streamer'] != undefined && config['streamer'].indexOf("rtmp") > -1 && config['hdclicked'] == true)
				{
					config['stream'].seek(config['startSec']);
				}
				config['hdclicked'] = false;
				var videoscale = new videoScale(config,reference);
				videoscale.videoResize();
				config['stream'].send("@clearDataFrame", "onMetaData");
			//}
		}
		//========================================== Streaming video status ==============================================================================
		private function netStatusHandler(event:NetStatusEvent)
		{
			if (config['video'] != "")
			{
				config['buffer_Mc'].alpha = 1;
				switch (event.info.code)
				{
					case "NetStream.Seek.Notify" :
						config['stremPlayed'] = true;
						break;
					case "NetStream.Buffer.Empty" :
						config['buffer_Mc'].visible = true;
						break;
					case "NetStream.Buffer.Full" :
						config['stremPlayed'] = false;
						config['buffer_Mc'].visible = false;
						break;
					case "NetStream.Buffer.Start" :
						if (config['isLive'] != "true")
						{
							config['buffer_Mc'].visible = false;
						}
						else
						{
							config['buffer_Mc'].visible = true;
						}
						break;
					case "NetStream.Play.Stop" :
						config['buffer_Mc'].visible = false;
						cls = setInterval(stopvideofun,500)
						
						break;
					case "NetStream.Play.StreamNotFound" :
						if (config['mov'] != 2)
						{
							stopVideoPlay();
						}
						else
						{
							buttonInVis();
							MessageClass.show(config['video_access_denied']);
						}
						break;
					case "NetStream.Play.FileStructureInvalid" :
						buttonInVis();
						MessageClass.show(config['FileStructureInvalid']);
						break;
					case "NetStream.Play.NoSupportedTrackFound" :
						buttonInVis();
						MessageClass.show(config['NoSupportedTrackFound']);
						break;
				}
			}
		}
		function stopvideofun()
		{
			if (config['isLive'] != "true" && config['currentTime']+1 >= config['nDuration'])
			{
				clearInterval(cls)
				config['stream'].removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				config['playeruI'].removeEventListener(Event.ENTER_FRAME, updateStremDisplay);
				stopVideoPlay();
			}
		}
		//========================================== video controls in enterframe ==============================================================================
		private function updateStremDisplay(eve:Event)
		{
			if(config['file'].indexOf('viddler') > -1){config['backBg'].alpha = 0;config['dailyBG'].width = config['stageWidth'];config['dailyBG'].height=config['stageHeight']}
			else config['backBg'].alpha = 1
			if(config['skinMc'].pro.seek_bar.width >  config['ProgbarWidth'])config['skinMc'].pro.seek_bar.width = config['ProgbarWidth']-30
			if (config['video'] != "")
			{
				if ((config['Playbtn'].visible == true && config['currentTime'] !=0 ) || config['relatedview'] == true || config['shareB'] == true )
				{
					config['buffer_Mc'].alpha = 0;
					var videopause = new videoPause(config);
				}
				if (config['video'] == "youtube")
				{
					config['currentTime'] = config['YTPlayer'].getCurrentTime();
					config['nDuration'] = config['YTPlayer'].getDuration();
				}
				else if(config['file'].indexOf('.f4m') <= -1 && config['file'].indexOf('.m3u8') <= -1)
				{
					config['currentTime'] = config['stream'].time;
				}
				if (config['mov'] == 1 || config['mov'] == 3)
				{
					adsControl();
				}
				else
				{
					
					if (config['ref'].mouseY > config['skinMc'].y && config['ref'].mouseY < config['stageHeight'] - 3)
					{
						config['skinMc'].pro.pointer.alpha = 1;
					}
					else
					{
						config['skinMc'].pro.pointer.alpha = 0;
					}
					config['skinMc'].pro.seek_bar.visible = config['skinMc'].pro.buffer_bar.visible = true;
					if (config['allowmidroll'] == "true" && config['mov'] == 2 && config['allow_imaAds'] == 'false' && config['midvis'] == true)
					{
						if (config['midRoll'].y<(config['stageHeight']-25) - (config['midRoll'].midbg.height+20))
						{
							(config['stageHeight']-25) - (config['midRoll'].midbg.height+8);
						}
					}
					if (config['video'] == "stream")
					{
						if (config['file'].indexOf('.mp3') > -1)
						{
							if (config['precontainer'])
							{
								config['precontainer'].addEventListener(MouseEvent.MOUSE_MOVE,mouseOverFun);
							}
							var percentPlayed:Number = (config['audioChannel'].position/config['audio'].length)*100;
							config['currentTime'] = percentPlayed;
							var minutes:uint = Math.floor(config['audioChannel'].position / 1000 / 60);
							var seconds:uint = Math.floor(config['audioChannel'].position / 1000) % 60;
							config['skinMc'].ti.timetex.htmlText= (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds + "</font> ";
						}
						else if(config['file'].indexOf('.f4m') > -1 || config['file'].indexOf('.m3u8') > -1)
						{
							config['currentTime'] = config['HLSandHDSstream'].getcurrentTime();
						}
						else if (config['streamer'] != undefined && config['streamer'].indexOf("pseudostreaming") <= -1)
						{
							config['currentTime'] = config['stream'].time;
						}
						else
						{
							config['currentTime'] = config['off'] + config['stream'].time;
						}
					}
					if (config['bolProgressScrub'])
					{
						if (config['file'].indexOf('.mp3') > -1)
						{
							config['lastPosition'] = config['audioChannel'].position;
							config['audioChannel'].stop();
						}
						else
						{
							var pcent = (config['skinMc'].pro.pointer.x) / config['ProgbarWidth'];
							if (config['video'] == "stream")
							{   
							    if(config['file'].indexOf('.f4m') > -1 || config['file'].indexOf('.m3u8') > -1){config['HLSandHDSstream'].HDSandHLSseek(Math.round(pcent*config['nDuration']))}
							    else if(config['streamer'] == undefined || config['streamer'] == "")config['stream'].seek(Math.round(pcent*config['nDuration']));
								else if(config['mp4'] == true && config['streamer'] != undefined && config['streamer'].indexOf("rtmp") <= -1)config['stream'].seek(Math.round(pcent*config['nDuration']));
								else if(config['mp4'] == false && config['streamer'] != undefined && config['streamer'].indexOf("rtmp") > -1)config['stream'].seek(Math.round(pcent*config['nDuration']));
							}
							else
							{
								config['YTPlayer'].seekTo(Math.round(pcent*config['nDuration']));
							}
							config['skinMc'].pro.seek_bar.width = config['skinMc'].pro.pointer.x - 7;
							timeDisplay();
						}
						timeDisplay();
					}
					else
					{
						if (config['file'].indexOf('.mp3') > -1)
						{
							var estimatedLength:int = Math.ceil(config['audio'].length / (config['audio'].bytesLoaded / config['audio'].bytesTotal));
							
							var playbackPercent:uint =  Math.round(100 * (config['audioChannel'].position / estimatedLength));
							
							config['skinMc'].pro.pointer.x = playbackPercent*(config['ProgbarWidth']/100);
								
							if (playbackPercent == 100)
							{
								stopVideoPlay();
							}
						}
						else if (config['stremPlayed'] == false && config['buffer_Mc'].visible == false)
						{
							if((config['currentTime'] * config['ProgbarWidth'] / config['nDuration'])>config['skinMc'].pro.pointer.x || config['resi'] == true)
							{
							config['skinMc'].pro.pointer.x = (config['currentTime'] * config['ProgbarWidth'] / config['nDuration']);}
						}
						config['skinMc'].pro.seek_bar.width = config['skinMc'].pro.pointer.x - 7;
					}
					if ((config['streamer'] != undefined && config['streamer'].indexOf("rtmp") > -1) || config['file'].indexOf('.f4m') > -1 || config['file'].indexOf('.m3u8') > -1)
					{
						config['skinMc'].pro.buffer_bar.width = config['ProgbarWidth'];
					}
					else if (config['video'] == "youtube" && config['file'].indexOf("vimeo.com") <= -1 )
					{
						if (config['bolProgressScrub'] == false)
						{
							if (config['YTPlayer'].getPlayerState() != 3)
							{
								config['stremPlayed'] = false;
							}
							if (config['file'].indexOf('dailymotion') > -1)
							{
								if (config['YTPlayer'].getPlayerState() > 0 && config['YTPlayer'].getPlayerState() < 3)
								{
									config['buffer_Mc'].visible = false;
								}
								if (config['YTPlayer'].getPlayerState() == -1)
								{
									config['dailyBG'].visible = false;
								}
								else
								{
									config['dailyBG'].visible = true;
								}
								if (config['Playbtn'].visible == true)
								{
									config['buffer_Mc'].alpha = 0;
								}
								if (config['YTPlayer'].getPlayerState() == 1 && config['Playbtn'].visible == true)
								{
									var videoplay22 = new videoPlay(config);
								}
								else if (config['YTPlayer'].getPlayerState() == 2 && config['Playbtn'].visible != true)
								{
									var videopause22 = new videoPause(config);
								}
							}
							if (config['file'].indexOf('youtube.com') > -1 || config['file'].indexOf('viddler') > -1 || config['file'].indexOf('youtu.be') > -1)
							{
								if (config['YTPlayer'].getPlaybackQuality() == "hd720" || config['YTPlayer'].getPlaybackQuality() == "hd1080" || config['YTPlayer'].getPlaybackQuality() == "highres")
								{
									config['skinMc'].hd.hdOffmode.visible = false;
									config['skinMc'].hd.hdOnmode.visible = true;
								}
								else
								{
									config['skinMc'].hd.hdOffmode.visible = true;
									config['skinMc'].hd.hdOnmode.visible = false;
								}
								if (config['file'].indexOf('youtube.com') > -1 || config['file'].indexOf('youtu.be') > -1)
								{
									if ((config['YTPlayer'].getVideoLoadedFraction() == 0 && config['YTPlayer'].getPlayerState() == 1) || config['YTPlayer'].getPlayerState() == 3)
									{
										config['buffer_Mc'].visible = true;
										config['buffer_Mc'].alpha = 1;
									}
									else
									{
										config['buffer_Mc'].visible = false;
									}
								}
								if (config['Playbtn'].visible == true)
								{
									config['buffer_Mc'].alpha = 0;
								}
								if (config['file'].indexOf('viddler') > -1)
								{
									if (config['YTPlayer'].getPlayerState() == 1 || config['YTPlayer'].getPlayerState() == 2)
									{
										config['buffer_Mc'].visible = false;
									}
									else
									{
										config['buffer_Mc'].visible = true;
										config['buffer_Mc'].alpha = 1;
									}
									if (config['Playbtn'].visible == true)
									{
										config['buffer_Mc'].alpha = 0;
									}
									stbytes = config['YTPlayer'].getVideoStartBytes();
									config['skinMc'].pro.buffer_bar.width=((stbytes+config['YTPlayer'].getVideoBytesLoaded()) * config['ProgbarWidth']) / config['YTPlayer'].getVideoBytesTotal();
								}
								else
								{
									if (config['YTPlayer'].getVideoLoadedFraction() > 0.98)
									{
										config['skinMc'].pro.buffer_bar.width=(config['ProgbarWidth']) ;
									}
									else
									{
										config['skinMc'].pro.buffer_bar.width=(config['YTPlayer'].getVideoLoadedFraction() * config['ProgbarWidth']) ;
									}
								}
							}
						}
						if (config['file'].indexOf('youtube.com') > -1 || config['file'].indexOf('youtu.be') > -1)
						{
							if(config['YTPlayer'].getPlayerState() == -1){config['YTPlayer'].alpha =0;config['buffer_Mc'].alpha=1;config['buffer_Mc'].visible=true}
							else config['YTPlayer'] .alpha = 1
						}
					}
					else
					{
						if (config['file'].indexOf('.mp3') > -1)
						{
							config['skinMc'].pro.buffer_bar.width = config['audio'].bytesLoaded * config['ProgbarWidth'] / config['audio'].bytesTotal;
						}
						else
						{
							config['skinMc'].pro.buffer_bar.width = config['stream'].bytesLoaded * config['ProgbarWidth'] / config['stream'].bytesTotal;
						}
					}
					config['skinMc'].pro.seek_bar.width = config['skinMc'].pro.pointer.x - 7;
					if (config['file'].indexOf('.mp3') > -1)
					{
						config['skinMc'].ti2.timetex.autoSize = TextFieldAutoSize.LEFT;
						if(config['pluginType'] == "")config['skinMc'].ti2.timetex.htmlText= "/ "+formatTime(config['nDuration']);
						else config['skinMc'].ti2.timetex.htmlText= formatTime(config['nDuration']);
					}
					else
					{
						timeDisplay();
					}
					if (config['skinMc'].y > config['stageHeight'] - 5 && config['progressControl'] != 'false' && config['skinVisible'] != 'false')
					{
						config['adIndicator'].visible = true;
					}
					else
					{
						config['adIndicator'].visible = false;
					}
					config['adIndicator'].adseek.width = (config['currentTime'] * config['stageWidth'] / config['nDuration']);
					config['adIndicator'].bg.width = config['stageWidth'];
					config['adIndicator'].y = config['stageHeight'];
					if (config['video'] == "youtube" && config['file'].indexOf("vimeo.com") <= -1 )
					{
						if (config['YTPlayer'].getPlayerState() == 0)
						{
							stopVideoPlay();
						}
					}
					else if(config['file'].indexOf('.f4m') > -1 || config['file'].indexOf('.m3u8') > -1)
					{
						if(config['currentTime']+1 >= config['nDuration'])
						{
							config['playeruI'].removeEventListener(Event.ENTER_FRAME, updateStremDisplay);
							stopVideoPlay()
						}
					}
					if (config['nDuration'] > 2 && config['imaAds'] == "true" && config['imA'] == false && config['allow_imaAds'] == "true" && ImAlaoded == false)
					{
						if (config['nDuration'] > 10)
						{
							if (Math.round(config['currentTime']) >= 10)
							{
								config['imA'] = true;
								ImAlaoded = true;
								var imaAdsload = new adsplayer(config,reference);
								imaAdsload.loadAd();
							}
						}
						else if (Math.round(config['nDuration']/2)== Math.round(config['currentTime']))
						{
							config['imA'] = true;
							ImAlaoded = true;
							var imaAdsload2 = new adsplayer(config,reference);
							imaAdsload2.loadAd();
						}
					}
					if(config['subTitleArr'][config['vid']] != "" && config['subTitleArr'][config['vid']] != undefined)
					{
						subTitle.setSubTitle(subTitle.getSubtitleAt(config['currentTime']))
					}
				}
				config['v'] =  -((config['skinMc'].Volume.vol_bar.vol_cnt.poi.y) / config['skinMc'].Volume.vol_bar.vol_cnt.bg.height);
				config['skinMc'].Volume.vol_bar.vol_cnt.sli.height =  -  config['skinMc'].Volume.vol_bar.vol_cnt.poi.y;

				if (config['v'] > 0.5)
				{
					config['skinMc'].Volume.v1.visible = config['skinMc'].Volume.v2.visible = true;
					config['skinMc'].Volume.muteBt.gotoAndStop(1);
				}
				else
				{
					config['skinMc'].Volume.v1.visible = true;
					config['skinMc'].Volume.v2.visible = false;
					config['skinMc'].Volume.muteBt.gotoAndStop(1);
				}
				if (config['v'] <= 0.1)
				{
					config['skinMc'].Volume.muteBt.gotoAndStop(2);
					setVolume(0);
					config['skinMc'].Volume.v1.visible = config['skinMc'].Volume.v2.visible = false;
				}
				else if (config['v']>0.9)
				{
					config['skinMc'].Volume.muteBt.gotoAndStop(1);
					setVolume(1);
				}
				else
				{
					setVolume(config['v']);
				}
				if (config['skinMc'].Volume.muteBt.currentFrame == 2)
				{
					config['skinMc'].Volume.vol_bar.vol_cnt.poi.y = -6; 
				}
				config['skinMc'].pro.seek_end.x = config['skinMc'].pro.seek_bar.x + config['skinMc'].pro.seek_bar.width;
				config['skinMc'].pro.buffer_end.x = config['skinMc'].pro.buffer_bar.x + config['skinMc'].pro.buffer_bar.width;
				config['skinMc'].pro.bg_end.x = config['skinMc'].pro.progress_bg.x + config['skinMc'].pro.progress_bg.width;
				config['skinMc'].pro.seek_end.alpha = config['skinMc'].pro.buffer_end.alpha = config['skinMc'].pro.bg_end.alpha = 1;
			}
			if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
			{
				slideRelatedVideo = new sliderelatedVideo(config,reference);
				slideRelatedVideo.setrelatedposition();
			}
			if (config['Playbtn'].visible == true)
			{
				config['buffer_Mc'].alpha = 0;
			}
			
		}
		private function timeDisplay()
		{
			config['skinMc'].ti.timetex.autoSize = TextFieldAutoSize.LEFT;
			config['skinMc'].ti2.timetex.autoSize = TextFieldAutoSize.LEFT;
			config['skinMc'].ti.timetex.text= formatTime(config['currentTime']);
			if(config['pluginType'] == "")config['skinMc'].ti2.timetex.text="/ "+formatTime(config['nDuration']);
			else config['skinMc'].ti2.timetex.text=formatTime(config['nDuration']);
			var skinArrnges = new skinarrnge(config);
		}
		private function setVolume(intVolume):void
		{
			var sndTransform= new SoundTransform(intVolume);
			if (config['video'] == "youtube")
			{
				config['YTPlayer'].setVolume(Math.round(intVolume*100));
			}
			else if (config['file'].indexOf('.mp3')>1 && config['audioChannel'] != undefined)
			{
				config['audioChannel'].soundTransform= sndTransform;
			}
			else if (config['file'].indexOf('.f4m') > -1 || config['file'].indexOf('.m3u8') > -1)
			{
				if(config['currentTime']>1 && config['mov'] == 2)config['HLSandHDSstream'].changeVolume(intVolume)
			}
			else
			{
				config['stream'].soundTransform= sndTransform;
			}
		}//========================================== video stopped ==============================================================================
		public function stopVideoPlay()
		{
			config['cc'] = "false" 
			config['SubMc'].visible = false
			var skinArrngea = new skinarrnge(config);
			config['QualityBg'].visible = false;
			config['subTiltleBg'].visible = false;
			if(config['adsLoader'] == undefined || config['adType'] == "Text" || config['adType'] == "Overlay")
			{
				config['playeruI'].removeEventListener(Event.ENTER_FRAME, updateStremDisplay);
				if (config['mov'] == 2 && config['currentTime']>(config['nDuration']-3) && config['embedplayer'] != "true")
				{
					Tracker = new tracker(config,config['ref']);
					Tracker.eventTracker("Video_End","Video_complete","END",0);
				}
				config['setnum'] = 0;
				config['skinMc'].indication.visible = false;
				config['skinMc'].pro.buffer_end.visible = config['skinMc'].pro.seek_end.visible = config['skinMc'].pro.seekS.visible = config['skinMc'].pro.bufferS.visible = false;
				if ((config['adType'] == "Text" || config['adType'] == "Overlay") && String(config['adTagUrl']) == "" && config['imaAds'] == "true" && config['allow_imaAds'] == "true")
				{
					var imaAdsload = new adsplayer(config,reference);
					imaAdsload.unloadAd();
					config['imA'] = false;
				}
				config['buffer_Mc'].alpha = 0;
				config['currentTime'] = config['nDuration'] = 0;
	
				config['skinMc'].ti.timetex.autoSize = TextFieldAutoSize.LEFT;
				config['skinMc'].ti2.timetex.autoSize = TextFieldAutoSize.LEFT;
				config['skinMc'].pro.seek_bar.width = config['skinMc'].pro.buffer_bar.width = config['skinMc'].pro.pointer.x = 0;
				config['skinMc'].ti.timetex.htmlText= "00:00";
				if(config['pluginType'] == "")config['skinMc'].ti2.timetex.htmlText= "/ 00:00";
				else config['skinMc'].ti2.timetex.htmlText= "00:00";
				config['skinMc'].ti2.x = config['skinMc'].ti2.bg = 0;
				clearInterval(config['midinterval']);
				var midRollAds12 = new midrollAds(config,reference);
				midRollAds12.midInvisi();
				config['adIndicator'].y = config['labelBt'].y = config['stageHeight'] + 50;
				config['adIndicator'].visible = config['labelBt'].visible = false;
				removeYoutubevidlervideos();
				if (config['preval'] == true)
				{
					preview = new Preview(config['ref'],config);
					preview.removePreview();
				}
				if (config['update'])
				{
					if (config['preval'] == true)
					{
						preview = new Preview(config['ref'],config);
						preview.removePreview();
					}
					config['Playbtn'].visible = false;
					config['buffer_Mc'].visible = false;
					config['mov'] = 1;
					var getVidDataee = new getinitialvidData(reference,config);
					hdEnabledFun();
				}
				else
				{
					goNextFun();
				}
			}
		}
		private function removeYoutubevidlervideos()
		{
			if (config['file'] != undefined)
			{
				if (config['file'].indexOf('.mp3') > 1 && config['mov'] == 2)
				{
					config['audioChannel'].stop();
					config['audioChannel'].removeEventListener(Event.SOUND_COMPLETE, doSoundComplete);
					if (config['preval'] == true)
					{
						preview = new Preview(config['ref'],config);
						preview.removePreview();
					}
				}
				if(config['file'].indexOf('.f4m') > -1 || config['file'].indexOf('.m3u8') > -1)
				{
					config['file'] = '';
					config['stream'] = null;
					config['video'] = "";
					config['HLSandHDSstream'].closeFun()
				}
				else if (config['video'] == "stream")
				{
					config['file'] = '';
					config['stream'].close();
					config['stream'].send("@clearDataFrame", "onMetaData");
					config['stream'].removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
					reference.removeChild(config['myVideo']);
					config['stream'] = null;
					config['video'] = "";
				}
				else if (config['video'] == "youtube")
				{
					if (config['file'].indexOf('viddler') <= -1)
					{
						config['YTPlayer'].stopVideo();
					}
					reference.removeChild(config['YoutubeLoader']);
					config['video'] = "";
				}
			}
		}
		//========================================== go next video ==============================================================================
		private function goNextFun()
		{
			config['errorMc'].visible = false;
			config['ini'] = false;
			config['pre_vid'] = config['vid'];
			if (config['hdclicked'] == true)
			{
				var getVidDatae = new getinitialvidData(reference,config);
				hdEnabledFun();
			}
			else
			{
				if (config['mov'] < 3)
				{
					config['mov']++;
					var getVidData1 = new getinitialvidData(reference,config);
					hdEnabledFun();
				}
				else
				{
					config['mov'] = 1;
					if (config['playlist_autoplay'] == "true")
					{
						config['vid']++;
						if (config['vid'] >= config['plistlength'])
						{
							config['vid'] = 0;
						}
						config['fbpath'] = config['fbpath_arr'][config['vid']];
						if(String(config['fbpath']) != undefined && String(config['fbpath']) != "" && config['mtype'] != "playerModule")
						{
							navigateToURL(new URLRequest(config['fbpath']), '_self');
							return;
						}
						else
						{
							if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
							{
								config['thuMc'].sh_hi.show.visible = false;
								config['thuMc'].sh_hi.hide.visible = true;
								new Tween(config['thuMc'],"x",null,config['thuMc'].x,config['stageWidth'] - config['thuMc'].thubg.width,0.3,true)
							}
							var getVidData2 = new getinitialvidData(reference,config);
							hdEnabledFun();
						}
					}
					else if (config['relatedVideoView'] == "center" && config['embedplayer'] != "true")
					{
						config['imageCount'] = 0;
						config['numofimg'] = 0;
						relatedvideo = new relatedVideo(config,reference);
						relatedvideo.loadrelatedvideos(config);
						config['skinMc'].pp.pause_btn.visible = false;
						config['skinMc'].pp.play_btn.visible = false;
						config['skinMc'].pp.Replay.visible = true;
						preview = new Preview(reference,config);
						preview.loadPreview();
					}
					else
					{
						if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
				        {
							config['thuMc'].sh_hi.show.visible = false;
							config['thuMc'].sh_hi.hide.visible = true;
							new Tween(config['thuMc'],"x",null,config['thuMc'].x,config['stageWidth'] - config['thuMc'].thubg.width,0.3,true)
						}
						var getVidData3 = new getinitialvidData(reference,config);
						config['skinMc'].pp.pause_btn.visible = false;
						config['skinMc'].pp.play_btn.visible = false;
						config['skinMc'].pp.Replay.visible = true;
						hdEnabledFun();
					}
				}
			}
		}
		//========================================== ads closed ==============================================================================
		private function closeAdsFun(eve:MouseEvent)
		{
			config['QualityBg'].visible = false;
			config['subTiltleBg'].visible = false;
			if (config['labelBt'].bg.visible == false)
			{
				config['Playbtn'].visible = false;
				config['labelBt'].removeEventListener(MouseEvent.MOUSE_DOWN,closeAdsFun);
				stopVideoPlay();
			}
		}
		//========================================== Enable HD ==============================================================================
		private function hdEnabledFun()
		{
			config['hd'] = "true";
			if (config['file'] != undefined && config['file'].indexOf('youtube.com') <= -1 && config['file'].indexOf('youtu.be') <= -1 && config['file'].indexOf('dailymotion') <= -1 && config['file'].indexOf('viddler') <= -1)
			{
				if ((reference.loaderInfo.parameters.file || (config['video_url'][config['vid']]!= undefined && config['video_url'][config['vid']] != "") ) && (reference.loaderInfo.parameters.hdpath || (config['video_hdpath'][config['vid']] != undefined && config['video_hdpath'][config['vid']] != "" )))
				{
					config['hd'] = "true";
				}
				else
				{
					config['hd'] = "false";
				}
			}
			var skinArrnge = new skinarrnge(config);
		}
		//========================================== Time formatted ==============================================================================
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
					return String( (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s);
				}
			}
			else
			{
				return "00:00";
			}
		}
		//========================================== Play and Pause ==============================================================================
		private function PlayPausebtnClicked(eve:MouseEvent)
		{
			config['QualityBg'].visible = false;
			config['subTiltleBg'].visible = false;
			if (config['relatedview'] != true && config['shareB'] != true && config['errorMc'].visible == false && config['mailB'] != true)
			{
				if (config['isplayed'] == false || config['Playbtn'].visible == true)
				{
					var videoplay = new videoPlay(config);
				}
				else
				{
					config['Playbtn'].alpha = 1;
					if (config['video'] == "youtube")
					{
						if (reference.mouseY < config['stageHeight'] - 100)
						{
							var videopause2 = new videoPause(config);
						}
					}
					else
					{
						var videopause = new videoPause(config);
					}
					if (config['mov'] == 2)
					{
						Tracker = new tracker(config,config['ref']);
						Tracker.eventTracker("Pause_video","Pause","Pause_btn",0);
					}
					else if (config['currentTime']>1)
					{
						adclick();
					}
				}
				if (config['video'] == "youtube")
				{
					if (pas==false)
					{
						fullscrfun();
					}
					setTimeout(callfull,160);
					pas = false;
				}
			}
			else
			{
				if (config['shareB'] == true)
				{
					var share = new scocialSharePanel(config,reference);
					share.mailclosed();
				}
				if (config['relatedview'] == true)
				{
					relatedvideo = new relatedVideo(config,reference);
					relatedvideo.removerelated();
					if (config['pauseState'] == true)
					{
						var videoplay2 = new videoPlay(config);
					}
				}
				if (config['mailB'] == true)
				{
					var Email = new email(config,reference);
					Email.mailclosed();
				}
				if (config['pauseState'] == true)
				{
					var videoplays = new videoPlay(config);
				}
				else
				{
					config['Playbtn'].alpha = 1;
				}
				if (config['mov'] == 2)
				{
					config['Playbtn'].alpha = 1;
					buttonVis();
				}
			}
		}
		private function callfull()
		{
			pas = true;
		}
		private function fullscrfun()
		{
			config['playeruI'].dispatchEvent(new Event('onfullscreen'));
		}
		private function FullscreenFun(eve:MouseEvent)
		{
			config['QualityBg'].visible = false;
			config['subTiltleBg'].visible = false;
			config['playeruI'].dispatchEvent(new Event('onfullscreen'));
		}
		//========================================== get  seek point for lighttpd videos ==============================================================================;
		private function convertSeekpoints(dat:Object):Object
		{
			var kfr:Object = new Object();
			kfr.times = new Array();
			kfr.positions = new Array();
			for (var j in dat)
			{
				kfr.times[j] = Number(dat[j]['time']);
				kfr.positions[j] = Number(dat[j]['offset']);
			}
			return kfr;
		}
		//========================================== play vieo at any point ==============================================================================
		private function progressbgClicked(eve:MouseEvent)
		{
			config['QualityBg'].visible = false;
			config['subTiltleBg'].visible = false;
			if (config['video'] == "youtube")
			{
				config['skinMc'].pro.pointer.startDrag(true, new Rectangle(0, 2, config['skinMc'].pro.progress_bg.width, 0));
				config['stremPlayed'] = true;
				config['bolProgressScrub'] = true;
				config['skinMc'].pro.seek_bar.width = config['skinMc'].pro.mouseX - config['skinMc'].pro.x;
				config['skinMc'].pro.buffer_bar.width = config['skinMc'].pro.mouseX - config['skinMc'].pro.x;
				config['skinMc'].pro.pointer.x = config['skinMc'].pro.mouseX - config['skinMc'].pro.x;
				var sec=config['nDuration'] *  (config['skinMc'].pro.mouseX/ config['skinMc'].pro.progress_bg.width);
				config['YTPlayer'].seekTo(sec,true);
			}
			else if (config['streamer'] != undefined && config['streamer'].indexOf("pseudostreaming") > -1 && config['mp4'] == false && config['keyframes'] != undefined)
			{
				config['skinMc'].pro.pointer.startDrag(true, new Rectangle(0, 2, config['skinMc'].pro.progress_bg.width, 0));
				config['stremPlayed'] = true;
				lighttPd.scrubit();
			}
			else if(config['file'].indexOf('.f4m') > -1 || config['file'].indexOf('.m3u8') > -1)
			{
				config['skinMc'].pro.pointer.startDrag(true, new Rectangle(0, 2, config['skinMc'].pro.progress_bg.width, 0));
				config['stremPlayed'] = true;
			}
		}
		//========================================== ads money make function  ==============================================================================
		function adclick()
		{
			if (String(config['adclickurl'])!="" &&  String(config['adclickurl'])!=null )
			{
				adclickdata =  new URLLoader();
				var adreq:URLRequest = new URLRequest(config['adclickurl'] + '&id=' + "" + config['ads_Id']);
				adclickdata.load(adreq);
			}
			if (String(config['adhitsurl'])!="" &&  String(config['adhitsurl'])!=null)
			{
				adclickdata2 =  new URLLoader();
				var adreq2:URLRequest = new URLRequest(config['adhitsurl'] + '&id=' + "" + config['ads_Id']);
				adclickdata2.load(adreq2);
			}
			if (String(config['adtarget'])!="" &&  String(config['adtarget'])!=null)
			{
				if (config["displayState"] == "fullScreen")
				{
					config['playeruI'].dispatchEvent(new Event('onfullscreen'));
				}
				navigateToURL(new URLRequest(config['adtarget']) , "_blank");
			}
		}
		function adimpression()
		{
			if (String(config['adimpressionurl'])!="" && String(config['adimpressionurl'])!=null)
			{
				adimpdata = new URLLoader();
				var adimpreq:URLRequest = new URLRequest(config['adimpressionurl'] + '&id=' + "" + config['ads_Id']);
				adimpdata.load(adimpreq);
			}
			if (String(config['impressionhits'])!="" && String(config['impressionhits'])!=null)
			{
				adimpdata2= new URLLoader();
				var adimpreq2:URLRequest = new URLRequest(config['impressionhits'] + '&id=' + "" + config['ads_Id']);
				adimpdata2.load(adimpreq2);
			}
		}
		public function downLoadUrl()
		{
			if (config["displayState"] == "fullScreen")
			{
				config['playeruI'].dispatchEvent(new Event('onfullscreen'));
			}
			if (config['downloadUrl'].indexOf('http') > -1)
			{
				config['downloadUrl'] = config['downloadUrl'];
			}
			else
			{
				config['downloadUrl'] = config['baseurl'] + "" + config['downloadUrl'];
			}
			if (String(config['downloadUrl']) !="" && String(config['downloadUrl']) !=null && config['file'] !=null)
			{
				if(config['pluginType'] == "")
				{
					navigateToURL(new URLRequest(config['downloadUrl']+"?f="+config['file']) , "_blank");
				}
				else
				{
					var urlArray:Array = config['file'].split('/');
					navigateToURL(new URLRequest(config['downloadUrl']+"?f="+urlArray[urlArray.length-1]) , "_blank");
				}
			}
			else
			{
				navigateToURL(new URLRequest(config['file']) , "_blank");
			}
		}//========================================== Moude go out from stage ==============================================================================
		public function stageOut()
		{
			config['autopL'].visible = false;
			config['tooltipMc'].visible = false;
			config['setnum'] = 0;
			config['QualityBg'].visible = false;
			config['subTiltleBg'].visible = false;
			if (config['skin_autohide'] == "true" && config['mov'] == 2 && config['stageover'] != true)
			{
				config['skinout'] = true;
				new Tween(config['skinMc'],"y",null,config['skinMc'].y,config['stageHeight'] + 5,0.3,true);
			}
			new Tween(config['shareMc'] , "x", null , config['shareMc'].x  ,-(config['shareMc'].width) , 0.3 , true);
			new Tween(config['zoomInMc'] , "x", null , config['zoomInMc'].x  , -(config['zoomInMc'].width) , 0.3 , true);
			new Tween(config['zoomOutMc'] , "x", null , config['zoomOutMc'].x , -(config['zoomOutMc'].width) , 0.3 , true);
			new Tween(config['downloadMc'] , "x", null , config['downloadMc'].x  , -(config['downloadMc'].width) , 0.3 , true);
			new Tween(config['mailIcon'] , "x", null , config['mailIcon'].x  , -(config['mailIcon'].width) , 0.3 , true);
			if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
			{
				if (config['thuMc'] != undefined)
				{
					new Tween(config['thuMc'],"x",null,config['thuMc'].x,config['stageWidth'] + 30,0.3,true);
					new Tween(config['midRoll'], "x",null,config['midRoll'].x,(config['stageWidth']/2)-(config['midRoll'].midbg.width/2), 0.3, true);
				}
			}
			if (config['caption_video'][config['vid']] != undefined && config['showTag'] == "true")
			{
				new Tween(config['tagline'],"alpha",null,config['tagline'].alpha,0,0.3,true);
				new Tween(config['tagline'].bg,"x",null,config['tagline'].bg.x,0,0.3,true);
				new Tween(config['tagline'].dot,"x",null,config['tagline'].dot.x,config['tagline'].bg.width,0.3,true);
			}
			listeneradd();
			setTimeout(listeneradd,500);
		}
		public function listeneradd()
		{
			if (config['dailyBG'])
			{
				config['dailyBG'].addEventListener(MouseEvent.MOUSE_MOVE,mouseOverFun);
			}
			if (config['shareClip'] && config['shareClip'].name != undefined)
			{
				config['shareClip'].addEventListener(MouseEvent.MOUSE_MOVE,mouseOverFun);
			}
			if (config['backBg'])
			{
				config['backBg'].addEventListener(MouseEvent.MOUSE_MOVE,mouseOverFun);
			}
			if (config['skinMc'])
			{
				config['skinMc'].addEventListener(MouseEvent.MOUSE_OVER,mouseOverFun);
			}
			if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
			{
				config['thuMc'].addEventListener(MouseEvent.MOUSE_OVER,mouseOverFun);
			}
		}
		//========================================== mouse over on stage ==============================================================================;
		private function mouseOverFun(eve:MouseEvent)
		{
			if(config['adsLoader'] == undefined || config['adType'] == "Text" || config['adType'] == "Overlay")
			{
				if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0 && config['thuMc'] && config['mov'] == 2)
				{
					config['thuMc'].visible = true;
				}
				if (config['dailyBG'])
				{
					config['dailyBG'].removeEventListener(MouseEvent.MOUSE_MOVE,mouseOverFun);
				}
				if (config['shareClip'])
				{
					config['shareClip'].removeEventListener(MouseEvent.MOUSE_MOVE,mouseOverFun);
				}
				if (config['backBg'])
				{
					config['backBg'].removeEventListener(MouseEvent.MOUSE_MOVE,mouseOverFun);
				}
				if (config['skinMc'])
				{
					config['skinMc'].removeEventListener(MouseEvent.MOUSE_OVER,mouseOverFun);
				}
				config['stageover'] = true;
				config['skinout'] = false;
				if (config['skinMc'].y < config['stageHeight'] - 50)
				{
					config['skinMc'].y = config['stageHeight']-(config['skinMc'].skin_bg.height);
				}
				else
				{
					new Tween(config['skinMc'] , "y", null , config['skinMc'].y  , config['stageHeight']-(config['skinMc'].skin_bg.height) , 0.3 , true);
				}
				if (config['mov'] == 2 && config['errorMc'].visible == false)
				{
					new Tween(config['shareMc'],"x",null,config['shareMc'].x,8,0.3,true);
					new Tween(config['zoomInMc'],"x",null,config['zoomInMc'].x,8,0.3,true);
					new Tween(config['zoomOutMc'],"x",null,config['zoomOutMc'].x,8,0.3,true);
					new Tween(config['downloadMc'],"x",null,config['downloadMc'].x,8,0.3,true);
					new Tween(config['mailIcon'],"x",null,config['mailIcon'].x,8,0.3,true);
				}
				else if (config['preval'] == true)
				{
					new Tween(config['Playbtn'],"alpha",null,config['Playbtn'].alpha,1,0.2,true);
					new Tween(config['mailcloseBt'],"alpha",null,config['mailcloseBt'].alpha,1,0.2,true);
					new Tween(config['Rbt'],"alpha",null,config['Rbt'].alpha,1,0.2,true);
					new Tween(config['Lbt'],"alpha",null,config['Lbt'].alpha,1,0.2,true);
				}
				if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
				{
					if (config['thuMc'].x > config['stageWidth'] - 2)
					{
						config['thuMc'].sh_hi.show.visible = true;
						config['thuMc'].sh_hi.hide.visible = false;
						new Tween(config['thuMc'],"x",null,config['thuMc'].x,config['stageWidth'],0.3,true);
					}
					new Tween(config['midRoll'], "x",null,config['midRoll'].x,(config['stageWidth']/2)-(config['midRoll'].midbg.width/2), 0.3, true);
				}
				if (config['caption_video'][config['vid']] != undefined && config['showTag'] == "true")
				{
					new Tween(config['tagline'],"y",null,config['tagline'].y,0,0.3,true);
					new Tween(config['tagline'],"alpha",null,config['tagline'].alpha,1,0.3,true);
				}
				eve.updateAfterEvent();
			}
		}
		private function gotovideoTarget(eve:MouseEvent)
		{
			config['QualityBg'].visible = false;
			config['subTiltleBg'].visible = false;
			if (config['mov'] == 2)
			{
				if (config['video_targeturl'][config['vid']] != undefined)
				{
					if (config["displayState"] == "fullScreen")
					{
						config['playeruI'].dispatchEvent(new Event('onfullscreen'));
					}
					navigateToURL(new URLRequest(config['video_targeturl'][config['vid']]) , "_blank");
				}
			}
			else
			{
				if (String(config['adtarget'])!="" &&  String(config['adtarget'])!=null)
				{
					if (config["displayState"] == "fullScreen")
					{
						config['playeruI'].dispatchEvent(new Event('onfullscreen'));
					}
					navigateToURL(new URLRequest(config['adtarget']) , "_blank");
				}
			}
		}
		public function calledfun()
		{
			config['playeruI'].addEventListener(Event.ENTER_FRAME, updateStremDisplay);
			config['myVideo'].addEventListener(MouseEvent.MOUSE_DOWN,PlayPausebtnClicked)
		}
		private function adsControl()
		{
			timeEnd = Math.round(config['nDuration'] - config['currentTime']);
			if (config['adsSkip'] == "true")
			{
				config['labelBt'].visible = true;
			}
			else
			{
				config['labelBt'].visible = false;
			}
			if(config['skinVisible'] != 'false')config['adIndicator'].visible = true;
			else config['adIndicator'].visible = false
			var ar:Array = config["adindicator"].split('-');
			if (timeEnd>=0)
			{
				config['labelBt'].txt.text = String(config["skip"]);
				config['skinMc'].indication.text = String(ar[0] + timeEnd + ar[1]);
			}
			var format:TextFormat = new TextFormat();
			if (config["displayState"] == "normal")
			{
				format.size = config['stageWidth'] / 50;
			}
			else
			{
				format.size = config['stageWidth'] / 76;
			}
			config['skinMc'].indication.setTextFormat(format);
			config['labelBt'].txt.setTextFormat(format);
			var xp:Number = (config['yposi']-40)/2;
			var ap:Number = config['skinMc'].indication.width / 2;
			config['skinMc'].indication.x = 40+(xp-ap)
			config['skinMc'].indication.autoSize = TextFieldAutoSize.LEFT;
			config['labelBt'].txt.autoSize = TextFieldAutoSize.RIGHT;
			config['labelBt'].textt.autoSize = TextFieldAutoSize.CENTER;
			config['labelBt'].x = config['stageWidth'] - 10;
			config['skinMc'].indication.y= config['skinMc'].skin_bg.y+(config['skinMc'].skin_bg.height/2)-(config['skinMc'].indication.height/2);
			if(config['skinVisible'] != 'false')config['adIndicator'].y = config['labelBt'].y = config['stageHeight'] - config['skinMc'].skin_bg.height + 2;
			else {config['adIndicator'].y = config['labelBt'].y = config['stageHeight'];}
			config['adIndicator'].x = 0;
			config['labelBt'].textt.text = config['skipvideo']+" "+(config['adsSkipDuration']-Math.round(config['currentTime']));
			config['labelBt'].textt.textColor = config['textColor'];
			config['labelBt'].txt.textColor = config['textColor'];
			config['adIndicator'].adseek.width = (config['currentTime'] * config['stageWidth'] / config['nDuration']);
			if (config['labelBt'].textt.height < 60)
			{
				format.size = 12;
			}
			else
			{
				format.size = 10;
			}
			config['labelBt'].textt.setTextFormat(format);
			config['labelBt'].textt.y= -((config['labelBt'].bg.height/2)+(config['labelBt'].textt.height/2)+5);
			if (config['adsSkip'] == "true")
			{
				if (config['currentTime'] > 0)
				{
					config['labelBt'].visible = true;
					if (0>=(config['adsSkipDuration']-Math.round(config['currentTime'])))
					{
						if (config['thumb_image'][config['vid']] == undefined || config['thumb_image'][config['vid']] == "")
						{
							if (nopreviewMc != null)
							{
								config['labelBt'].bg.removeChild(nopreviewMc);
								nopreviewMc = null;
							}
						}
						config['labelBt'].textt.visible = false;
						if (imgLoader != null)
						{
							config['labelBt'].bg.removeChild(imgLoader);
							imgLoader = null;
						}
						config['labelBt'].txt.visible = true;
						config['labelBt'].bg.visible = false;
						config['labelBt'].bg2.width = config['labelBt'].txt.width + 10;
						config['labelBt'].bg2.x = config['labelBt'].txt.x - 5;
						config['labelBt'].bg2.visible = true;
					}
					else
					{
						config['labelBt'].bg.visible = true;
						config['labelBt'].bg2.visible = false;
					}
				}
				else
				{
					config['labelBt'].visible = false;
				}
			}
			if (timeEnd==0 && config['currentTime']>1)
			{
				timeEnd = 1;
				config['labelBt'].visible = config['adIndicator'].visible = false;
				stopVideoPlay();
			}
			if (config['file'].indexOf('youtube.com') > -1 || config['file'].indexOf('youtu.be') > -1)
			{
				if(config['YTPlayer'].getPlayerState() == -1){config['YTPlayer'].alpha =0;config['buffer_Mc'].alpha=1;config['buffer_Mc'].visible=true}
				else {config['YTPlayer'] .alpha = 1;config['buffer_Mc'].alpha=0;config['buffer_Mc'].visible=false}
			}
		}
		function utftextFun(string:String)
		{
			if (string!=null)
			{
				var utftext = "";
				for (var n = 0; n < string.length; n++)
				{

					var c = string.charCodeAt(n);
					if (c < 128)
					{
						utftext +=  String.fromCharCode(c);
					}
					else if ((c > 127) && (c < 2048))
					{
						utftext += String.fromCharCode((c >> 6) | 192);
						utftext += String.fromCharCode((c & 63) | 128);
					}
					else
					{
						utftext += String.fromCharCode((c >> 12) | 224);
						utftext += String.fromCharCode(((c >> 6) & 63) | 128);
						utftext += String.fromCharCode((c & 63) | 128);
					}
				}
				return utftext;
			}
		}
	}
}