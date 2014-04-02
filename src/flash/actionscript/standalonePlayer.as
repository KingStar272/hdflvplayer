package actionscript
{
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.utils.*;
	import flash.ui.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.events.ContextMenuEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.*;
	import script.gs.easing.Cubic;
	import script.gs.TweenMax;
	import flash.media.SoundTransform;
	import flash.system.System;
	import flash.system.Security;
	import flash.net.*;
	import flash.display.MovieClip;
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.processing.ProcessExecutor;
	import flash.geom.ColorTransform;
	import hdflvplayer;

	public class standalonePlayer extends MovieClip
	{
		private var config:Object;
		private var lc:LocalConnection = new LocalConnection();
		private var domain:String = lc.domain;
		private var menu:ContextMenu;
		public var SkinLoad:skinLoad;
		private var playerUI:playerUi;
		private var videoscale:String;
		private var videooscale:videoScale;
		private var relatedvideo:relatedVideo;
		private var Tracker:tracker;
		private var playvideo:playVideo;
		private var seti:Number;
		private var volBool:Boolean;
		private var cntrPressed:Boolean;

		private var switcher:int = 0;
		private var posXa:Number = stage.mouseX;
		private var posYa:Number = stage.mouseY;
		private var posXb:Number = stage.mouseX;
		private var posYb:Number = stage.mouseY;
		private var _scrollbarVertical:Scrollbar;
		private var iconArray:Array;
		private var iconNameArray:Array;

		private var myString:String;
		private var svgDocument:SVGDocument;
		private var _urlLoader:URLLoader;
		private var iconclip:MovieClip;
		private var iconclipBg:MovieClip;
		private var hdflv:hdflvplayer;
		private var webaddr:Array;

		public function standalonePlayer()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			Security.allowDomain("*");
			menu= new ContextMenu();
			volBool = false;
			cntrPressed = false;
			iconArray = new Array();
			iconNameArray = new Array();
			//==================================== call xml loder function ===============================================
			var configxmlLoad = new xmlLoad(this,stage.stageWidth,stage.stageHeight);
			configxmlLoad.addEventListener(Event.COMPLETE, onDataLoaded);
			if (this.root.loaderInfo.url.indexOf('file:///') > -1 && ! this.root.loaderInfo.parameters['embedplayer'])
			{
				configxmlLoad.loadFlashvars();
			}
		}
		private function onDataLoaded(event:Event):void
		{
			config = event.target.config;
			config['initWidth'] = stage.stageWidth;
			if(this.root.loaderInfo.url.indexOf('file:///') > -1)
			{
				config['local'] = "true";
				if (config['fullscreen'] == undefined)
				{
					config['fullscreen'] = "true";
				}
				if (config['volumecontrol'] == undefined)
				{
					config['volumecontrol'] = "true";
				}
				if (config['timer'] == undefined)
				{
					config['timer'] = "true";
				}
				if (config['volume'] == undefined)
				{
					config['volume'] = 80;
				}
				if (config['buffer'] == undefined)
				{
					config['buffer'] = 3;
				}
				if (config['normalscale'] == undefined)
				{
					config['normalscale'] = "2";
				}
				if (config['fullscreenscale'] == undefined)
				{
					config['fullscreenscale'] = "2";
				}
				if(config['HD_default'] == undefined)
				{
					config['HD_default'] = "true"
				}
			}// ==================================== get License key ====================================================
			config['logodomain'] = domain;
			config['displayState'] = stage["displayState"];
			if (stage["displayState"] == "normal")
			{
				videoscale = config['normalscale'];
			}
			if (stage["displayState"] == "fullScreen")
			{
				videoscale = config['fullscreenscale'];
			}
			config['videoscale'] = videoscale;
			config['stageWidth'] = stage.stageWidth;
			config['stageHeight'] = stage.stageHeight;
			if (config['videoAvailable'] == true || this.root.loaderInfo.parameters['file'] || this.root.loaderInfo.parameters['hdpath'])
			{
				//====================================== rest plyer size based on xml values ====================================
				videooscale = new videoScale(config,this);
				// ===================================== add Player movieclips ==================================================
				config['playeruI']= playerUI = new playerUi(this,config);
				addChild(playerUI);
				config['playeruI'].addUi(config)
				config['SkinLoad'] = SkinLoad = new skinLoad(this,config);
				hdflv = new hdflvplayer()
				//var swfURL:String = loaderInfo.url;
               // var ldrURL:String = loaderInfo.loaderURL;
			    config['license_Player'] = hdflv.HDFLVPlayer(config,lc.domain,this)
				playerUI.addEventListener('onfullscreen', toggleScreen);
				playerUI.addEventListener('focus', onFocusFun);
				playerUI.addEventListener('callscroll', callScroll);
				playerUI.addEventListener('mutesound', muteSound);
				config['skinout'] = false;
				stage.addEventListener(Event.MOUSE_LEAVE,mouseleaveFun);
				stage.addEventListener(KeyboardEvent.KEY_UP, stage_onKeyUp);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				//===================================== set player size based on window size =====================================
				stage.addEventListener(Event.RESIZE, resizeFun);
				stage.addEventListener(MouseEvent.MOUSE_UP,stageMouseUp);
				config['ref'] = this;
				//==================================== google analytics ===========================================================
				if (String(config['trackCode'])!="")
				{
					Tracker = new tracker(config,this);
					Tracker.trackPage();
				}
				ProcessExecutor.instance.initialize(stage);
				ProcessExecutor.instance.percentFrameProcessingTime = 1;
				iconArray = new Array()
				if(config['shareIcon'] == "true"){iconArray.push(config['shareMc']);iconNameArray.push('images/icon/share.svg')}
				if(config['zoomIcon'] == "true"){iconArray.push(config['zoomInMc']);iconNameArray.push('images/icon/zoomIn.svg')}
				if(config['zoomIcon'] == "true"){iconArray.push(config['zoomOutMc']);iconNameArray.push('images/icon/zoomOut.svg')}
				if(config['Download'] == "true"){iconArray.push(config['downloadMc']);iconNameArray.push('images/icon/download.svg')}
				if(config['email'] == "true"){iconArray.push(config['mailIcon']);iconNameArray.push('images/icon/mail.svg')}
				if (config['local'] != "true")
				{
					for (var k=0; k<iconArray.length; k++)
					{
						svgDocument = new SVGDocument();
						svgDocument.load(config['pageURL']+"/images/icon/bg.svg");
						iconclip = new MovieClip();
						iconclipBg = new MovieClip()
						iconArray[k].addChild(iconclipBg)
						iconclipBg.addChild(svgDocument);
						iconArray[k].addChild(iconclip);
						svgDocument = new SVGDocument();
						svgDocument.load(config['pageURL']+"/"+iconNameArray[k]);
						iconclip.addChild(svgDocument);
						svgDocument.x = 5;
						if (iconNameArray[k] == 'images/icon/mail.svg')
						{
							svgDocument.y = 10;
							svgDocument.x = 6;
						}
						else if (iconNameArray[k] == 'images/icon/download.svg')
						{
							svgDocument.y = 9;
							svgDocument.x = 8;
						}
						else
						{
							svgDocument.y = 5;
						}
						if (String(config['playerButtonColor']) != "" && config['playerButtonColor'] != undefined)
						{
							changeColor(iconclip,config['playerButtonColor']);
						}
						if (String(config['playerButtonBgColor']) != "" && config['playerButtonBgColor'] != undefined)
						{
							changeColor(iconclipBg,config['playerButtonBgColor']);
						}
						if(config['skin_opacity'] != "" && config['skin_opacity'] != undefined)
						{
							iconclipBg.alpha = config['skin_opacity']
						}
					}
				}
				setChildIndex(config['buffer_Mc'],numChildren-1);
				setChildIndex(config['logocon'],numChildren-1);
				setChildIndex(config['midRoll'],numChildren-1);
				setChildIndex(config['tooltipMc'],numChildren-1);
				if(config['SocialPanel']){setChildIndex(config['SocialPanel'],numChildren-1);}
				videooscale.buttonInVis();
				//=================================== Listener for find mouse idle and mouse go out frm stage ======================;
				this.addEventListener(Event.ENTER_FRAME, checkMovement);
			}
		}
		private function mouseleaveFun(eve:Event)
		{
			config['setnum'] = 0;
			config['downBool'] = false;
			config['upBool'] = false;
			config['stageover'] = false;
			if ((config['mov']==2 || config['preval'] == true) &&  config['reclick'] == false)
			{
				config['skinMc'].pro.pointer.alpha = 0;
				if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
				{
					if (config['thuMc'].sh_hi.show.visible == true)
					{
						seti = setInterval(callout,100);
					}
				}
				else
				{
					seti = setInterval(callout,100);
				}
			}
		}
		private function callout()
		{
			clearInterval(seti);
			if (config['skinout'] == false && config['stageover'] == false && config['reclick'] == false)
			{
				playvideo = new playVideo(config,this);
				playvideo.stageOut();
			}
		}
		private function stageMouseUp(eve:MouseEvent):void
		{
			config['skinMc'].pro.pointer.stopDrag();
			config['skinMc'].Volume.vol_bar.vol_cnt.poi.stopDrag();
			config['bolVolumeScrub'] = false;
			config['bolProgressScrub'] = false;
		}

		public function callScroll(evt:Event):void
		{
			if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
			{
				_scrollbarVertical = new Scrollbar(config['scrollbarVerticalMc']);
				_scrollbarVertical.initialize(config['thuMc'].thu_container, config['thuMc'].thumask, Scrollbar.VERTICAL, 1, null, .2, null, .25, true, false, 0);
				_scrollbarVertical.changeSize(config['thuMc'].thumask.height+1);
			}
		}
		//================================ full screen and normal screen size changed =========================================;
		public function toggleScreen(evt:Event):void
		{
			config['SocialPanel'].visible = config['mailPanel'].visible = false;
			if (config['shareB'] == true && stage.displayState == StageDisplayState.NORMAL)
			{
				var EmailSS = new scocialSharePanel(config,this);
				config['SocialPanel'].visible = false;
				EmailSS.mailclosed();
			}
			if (config['mailB'] == true && stage.displayState == StageDisplayState.NORMAL)
			{
				var Email = new email(config,this);
				config['mailPanel'].visible = false;
				Email.mailclosed();
			}
			config['skinMc'].visible = false;
			if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
			{
				var slideRelatedVideo = new sliderelatedVideo(config,this);
				slideRelatedVideo.setrelatedposition();
				config['thuMc'].alpha = 0;
			}
			if (stage.displayState == StageDisplayState.NORMAL)
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;
				config['skinMc'].FullScreen.icon.i1.gotoAndStop(2)
				config['skinMc'].FullScreen.icon.i2.gotoAndStop(2)
				config['skinMc'].FullScreen.icon.i3.gotoAndStop(2)
				config['skinMc'].FullScreen.icon.i4.gotoAndStop(2)
			}
			else
			{
				stage.displayState = StageDisplayState.NORMAL;
				config['skinMc'].FullScreen.icon.i1.gotoAndStop(1)
				config['skinMc'].FullScreen.icon.i2.gotoAndStop(1)
				config['skinMc'].FullScreen.icon.i3.gotoAndStop(1)
				config['skinMc'].FullScreen.icon.i4.gotoAndStop(1)
			}
			config['displayState'] = stage["displayState"];
			if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
			{
				if (config['thuMc'].sh_hi.show.visible == true)
				{
					config['thuMc'].x = config['stageWidth'];
				}
				else
				{
					config['thuMc'].x = config['stageWidth'] - config['thuMc'].thubg.width;
				}
			}
		}
		public function onFocusFun(evt:Event):void
		{
			stage.focus = config['mailPanel'].form.from;
			config['mailPanel'].form.from.addEventListener(MouseEvent.MOUSE_DOWN,clickmailPanel);
			config['mailPanel'].form.to.addEventListener(MouseEvent.MOUSE_DOWN,clickmailPanel);
			config['mailPanel'].form.Note.addEventListener(MouseEvent.MOUSE_DOWN,clickmailPanel);
		}
		public function clickmailPanel(eve:MouseEvent)
		{
			config['mailPanel'].form.starmcc.visible = false;
			config['mailPanel'].result.text = "";
			config['mailPanel'].form.output.text = "";
			if (eve.currentTarget.name == 'Note')
			{
				config['focus'] = 'to';
			}
			else
			{
				config['focus'] = 'Note';
			}
		}
		function goresifalse()
		{
			config['resi'] =  false;
		}
		private function resizeFun(evt:Event=null):void
		{
			config['stageWidth'] = stage.stageWidth;
			config['stageHeight'] = stage.stageHeight;
            config['resi'] = true;
			setTimeout(goresifalse,2000)
			if (config['video'] == "youtube")
			{
				config['YTPlayer'].scaleX = config['YTPlayer'].scaleY = 1;
				config['YTPlayer'].setSize(config['stageWidth'], config['stageHeight']);
			}
			else
			{
				config['shareClip'].scaleX = config['shareClip'].scaleY = 1;
			}
			if (stage["displayState"] == "normal")
			{
				videoscale = config['normalscale'];
			}
			if (stage["displayState"] == "fullScreen")
			{
				videoscale = config['fullscreenscale'];
			}
			config['displayState'] = stage["displayState"];
			config['videoscale'] = videoscale;
			playerUI.setPos(config);
			var skinArrnge = new skinarrnge(config);
			videooscale = new videoScale(config,this);
			videooscale.videoResize();
			videooscale.alignmidroll(config['midvis']);
			config['skinMc'].alpha = 1;
			if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
			{
				var slideRelatedVideo2 = new sliderelatedVideo(config,this);
				slideRelatedVideo2.setrelatedposition();
				config['thuMc'].alpha = 1;
				if (config['thuMc'].sh_hi.show.visible == true)
				{
					config['thuMc'].x = config['stageWidth'];
				}
				else
				{
					config['thuMc'].x = config['stageWidth'] - config['thuMc'].thubg.width;
				}
				config['scrollbarVerticalMc'].drag_mc.y = 0;
				config['thuMc'].thu_container.y = 0;
				config['scrollbarVerticalMc'].x = config['thuMc'].thubg.width - 8.7;
				config['scrollbarVerticalMc'].down_arrow_mc.visible = config['scrollbarVerticalMc'].up_arrow_mc.visible = false;
				playerUI.dispatchEvent(new Event('callscroll'));
			}
			if (config['isLive'] == "true" && config['mov'] == 2)
			{
				playvideo.setLiveText();
			}
			if (config['showTag'] == "true" && config['preval'] != true)
			{
				if (config['mov'] == 2 && config['caption_video'][config['vid']] != undefined)
				{
					videooscale.taglineposition();
				}
				else if (config['mov']!= 2 && config['adsDesArr'][config['adindex']] != undefined)
				{
					videooscale.taglineposition();
				}
				else
				{
					config['tagline'].visible = false;
				}
			}
			config['skinMc'].alpha = 1;
			config['skinMc'].visible = true;
			config['skinMc'].y = config['stageHeight']-(config['skinMc'].skin_bg.height);
		}
		// ====================================== find mouse in Idle ========================================== 
		function checkMovement(e:Event):void
		{
			setChildIndex(config['buffer_Mc'],numChildren-1);
			setChildIndex(config['logocon'],numChildren-1);
			setChildIndex(config['midRoll'],numChildren-1);
			setChildIndex(config['tooltipMc'],numChildren-1)
			if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
			{
				if (config['thuMc'].x<(stage.stageWidth-config['thuMc'].width) && config['reclick'] == false)
				{
					if (config['thuMc'].sh_hi.show.visible == true)
					{
						config['thuMc'].x = config['stageWidth'];
					}
					else
					{
						config['thuMc'].x = config['stageWidth'] - config['thuMc'].thubg.width;
					}
					var slideRelatedVideo2 = new sliderelatedVideo(config,this);
					slideRelatedVideo2.setrelatedposition();
					config['thuMc'].alpha = 1;
					if (config['thuMc'].sh_hi.show.visible == true)
					{
						config['thuMc'].x = config['stageWidth'];
					}
					else
					{
						config['thuMc'].x = config['stageWidth'] - config['thuMc'].thubg.width;
					}
					config['scrollbarVerticalMc'].drag_mc.y = 0;
					config['thuMc'].thu_container.y = 0;
					config['scrollbarVerticalMc'].x = config['thuMc'].thubg.width - 8.7;
					config['scrollbarVerticalMc'].down_arrow_mc.visible = config['scrollbarVerticalMc'].up_arrow_mc.visible = false;
					playerUI.dispatchEvent(new Event('callscroll'));
					setTimeout(thuvisFun,1000);
				}
				else if(config['mov'] == 2)
				{
					config['thuMc'].visible = true;
				}
				else if(config['preval'] == false)
				{
					config['thuMc'].visible = false;
				}
			}
			if (config['skinMc'].y < config['stageHeight'] - 50)
			{
				config['skinMc'].y = config['stageHeight']-(config['skinMc'].skin_bg.height);
				setTimeout(skinvisFun,1000);
			}
			else
			{
				config['skinMc'].visible = true;
			}
			if (switcher == 0)
			{
				posXa = stage.mouseX;
				posYa = stage.mouseY;
				switcher = 1;
			}
			else
			{
				posXb = stage.mouseX;
				posYb = stage.mouseY;
				switcher = 0;
			}
			if (posXa == posXb && posYa == posYb)
			{
				config['setnum']++;
			}
			else
			{
				config['setnum'] = 0;
			}
			if (config['setnum'] == 50)
			{
				config['setnum'] = 0;
				if ((config['mov'] == 2 || config['preval'] == true) && config['reclick'] == false)
				{
					config['stageover'] = false;
					if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
					{
						if (config['thuMc'].sh_hi.show.visible == true)
						{
							seti = setInterval(callout,100);
						}
					}
					else
					{
						seti = setInterval(callout,100);
					}
				}
			}
			if (config['mov'] == 2 && config['skinMc'].y > stage.stageHeight)
			{
				playvideo.listeneradd();
			}
			config['v'] =  -((config['skinMc'].Volume.vol_bar.vol_cnt.poi.y) / config['skinMc'].Volume.vol_bar.vol_cnt.bg.height );
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
			if (config['mailB'] == true)
			{
				myString = String(config['mailPanel'].form.Note.text);
				if (config['mailPanel'].result.text == "" && config['focus'] == "to")
				{
					config['mailPanel'].form.output.text = String(myString.length) + "/250";
				}
				else
				{
					config['mailPanel'].form.output.text = "";
				}
			}
		}
		function thuvisFun()
		{
			if(config['mov'] == 2 || config['preval'] == true)config['thuMc'].visible = true;
		}
		function skinvisFun()
		{
			config['skinMc'].visible = true;
		}
		function stage_onKeyUp(event:KeyboardEvent)
		{
			config['bolVolumeScrub'] = false;
			config['bolProgressScrub'] = false;
			config['stremPlayed'] = false;
			if (event.keyCode == 17)
			{
				cntrPressed = false;
			}
		}
		function keyDownHandler(event : KeyboardEvent):void
		{
			config['mailPanel'].form.starmcc.visible = false;
			if (event.keyCode == 9)
			{
				config['focus'] = event.target.name;
				config['mailPanel'].result.text = "";
				config['mailPanel'].form.output.text = "";
			}
			else if (event.keyCode == 13 && event.target.name == "bt")
			{
				config['mailPanel'].form.starmcc.visible = false;
				var Email = new email(config,this);
				Email.sendEmailFun();
			}
			else if (event.keyCode == 32 && config['relatedview'] == false && config['shareB'] == false && config['mailB']  == false && config['preval'] == false )
			{
				if (config['isplayed'] == false || config['Playbtn'].visible == true)
				{
					var videoplay = new videoPlay(config);
				}
				else
				{
					if (config['relatedview'] == false && config['shareB'] == false)
					{
						config['Playbtn'].visible = true;
						config['Playbtn'].alpha = 1;
					}
					var videopause = new videoPause(config);
				}
			}
			else if (event.keyCode == 77)
			{
				playerUI.dispatchEvent(new Event('mutesound'));
			}
			else if (event.keyCode == 17)
			{
				cntrPressed = true;
			}
			else if (cntrPressed)
			{
				if (event.keyCode == 38)
				{
					config['bolVolumeScrub'] = true;
					config['skinMc'].Volume.muteBt.gotoAndStop(1);
					if (-(config['skinMc'].Volume.vol_bar.vol_cnt.bg.height-6)<config['skinMc'].Volume.vol_bar.vol_cnt.poi.y)
					{
						config['skinMc'].Volume.vol_bar.vol_cnt.poi.y = config['skinMc'].Volume.vol_bar.vol_cnt.poi.y - 5;
					}
				}
				else if (event.keyCode == 40)
				{
					config['bolVolumeScrub'] = true;
					if (-8 > config['skinMc'].Volume.vol_bar.vol_cnt.poi.y)
					{
						config['skinMc'].Volume.vol_bar.vol_cnt.poi.y = config['skinMc'].Volume.vol_bar.vol_cnt.poi.y + 5;
					}
				}
				else if ((event.keyCode == 39 || event.keyCode == 37) && config['mov'] == 2)
				{
					if ((config['streamer'] != undefined && (config['streamer'].indexOf("rtmp") > -1 ||config['streamer'].indexOf("pseudostreaming") )) || config['video'] == "youtube")
					{
						config['bolProgressScrub'] = true;
						config['stremPlayed'] = true;
						if (config['streamer'].indexOf("pseudostreaming") > -1 && config['mp4'] == false && config['keyframes'] != undefined)
						{
							if (event.keyCode == 39 && config['skinMc'].pro.pointer.x < config['skinMc'].pro.progress_bg.width)
							{
								config['skinMc'].pro.pointer.x = config['skinMc'].pro.pointer.x + 15;
								var lighttPd = new lighttpd(config);
								lighttPd.scrubit();
							}
							else if (event.keyCode == 37 && config['skinMc'].pro.pointer.x>12)
							{
								config['skinMc'].pro.pointer.x = config['skinMc'].pro.pointer.x - 15;
								var lighttPd2 = new lighttpd(config);
								lighttPd.scrubit();
							}
						}
						else if (config['streamer'].indexOf("pseudostreaming") <= -1)
						{
							if (event.keyCode == 39 && config['skinMc'].pro.pointer.x < config['skinMc'].pro.progress_bg.width)
							{
								config['skinMc'].pro.pointer.x = config['skinMc'].pro.pointer.x + 15;
							}
							else if (event.keyCode == 37 && config['skinMc'].pro.pointer.x>12)
							{
								config['skinMc'].pro.pointer.x = config['skinMc'].pro.pointer.x - 15;
							}
						}
						config['skinMc'].pro.seek_bar.width = config['skinMc'].pro.pointer.x;
						if (config['streamer'] != undefined && config['streamer'] != "")
						{
							config['buffer_Mc'].visible = true;
						}
					}
				}
				else if ((config['streamer'] == "" || config['streamer'] == undefined) && config['video'] == "stream")
				{
					if (event.keyCode == 39 && config['skinMc'].pro.pointer.x < config['skinMc'].pro.buffer_bar.width)
					{
						config['skinMc'].pro.pointer.x = config['skinMc'].pro.pointer.x + 15;
					}
					else if (event.keyCode == 37 && config['skinMc'].pro.pointer.x>12)
					{
						config['skinMc'].pro.pointer.x = config['skinMc'].pro.pointer.x - 15;
					}
				}
			}

		}
		public function muteSound(evt:Event):void
		{
			if (config['skinMc'].Volume.muteBt.currentFrame == 1 && ! volBool)
			{
				config['intLastVolume']=-(config['skinMc'].Volume.vol_bar.vol_cnt.poi.y);
				config['skinMc'].Volume.vol_bar.vol_cnt.poi.y = -4;
				config['skinMc'].Volume.muteBt.gotoAndStop(2);
				config['skinMc'].Volume.vol_bar.vol_cnt.sli.height = 0;
				if (config['preval'] == false)
				{
					if (config['file'].indexOf('youtube') > -1)
					{
						config['YTPlayer'].mute();
					}
					else
					{
						setVolume(0);
					}
				}
				volBool = true;
			}
			else
			{
				volBool = false;
				if (config['preval'] == false)
				{
					if (config['file'].indexOf('youtube') > -1)
					{
						config['YTPlayer'].unMute();
					}
				}
				var seWw:Number = config['intLastVolume'];
				if (seWw<0)
				{
					seWw = 0;
				}
				new Tween(config['skinMc'].Volume.vol_bar.vol_cnt.sli,"height",null,config['skinMc'].Volume.vol_bar.vol_cnt.sli.height,seWw,.1,true);
				config['v'] = seWw / 50;
				if (config['v'] > 0.5)
				{
					config['skinMc'].Volume.v1.visible = config['skinMc'].Volume.v2.visible = true;
				}
				else
				{
					config['skinMc'].Volume.v1.visible = true;
					config['skinMc'].Volume.v2.visible = false;
				}
				new Tween(config['skinMc'].Volume.vol_bar.vol_cnt.poi,"y",null,-7, -  config['intLastVolume'],.1,true);
			}
		}
		public function setVolume(intVolume):void
		{
			var sndTransform= new SoundTransform(intVolume);
			if (config['video'] == "youtube")
			{
				config['YTPlayer'].setVolume(Math.round(intVolume*100));
			}
			else if(config['stream'] != null)
			{
				config['stream'].soundTransform= sndTransform;
			}
		}
		public function changeColor(object:MovieClip, color:Number)
		{
			var colorchange:ColorTransform = new ColorTransform();
			colorchange.color = color;
			object.transform.colorTransform = colorchange;
		}
	}
}