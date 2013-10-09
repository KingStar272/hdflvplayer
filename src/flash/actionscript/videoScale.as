package actionscript
{
	import flash.external.*;
	import flash.display.Sprite;
	import fl.transitions.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	public class videoScale
	{
		private var wid:Number;
		private var hei:Number;
		private var config:Object;
		private var reference:Sprite;
		private var relatedvideo:relatedVideo;
		private var slideRelatedVideo:sliderelatedVideo;
		

		public function videoScale(cfg,ref)
		{
			reference = ref;
			config = cfg;
		}
		public function videoResize()
		{
			wid = config['stageWidth'];
			hei = config['stageHeight'];
			var scaleratio = wid / hei;
			if (config["displayState"] == "normal")
			{
				config['videoscale'] = config['normalscale'];
			}
			if (config["displayState"] == "fullScreen")
			{
				config['videoscale'] = config['fullscreenscale'];
			}
			var vidscal = config['videoscale'];
			if (config['video'] == "youtube")
			{
				vidscal = '2';
			}
			//========================================== set video size ==============================================================================
			config['shareClip'].scaleX = config['shareClip'].scaleY = 1;
			switch (String(vidscal))
			{
					//Aspect ratio
				case "0" :
					if (config['vidscale'] > scaleratio)
					{
						config['shareClip'].width = wid;
						config['shareClip'].x = 0;
						config['shareClip'].height = config['org_height'] * config['shareClip'].width / config['org_width'];
						if ((hei/2)>(config['shareClip'].height/2))
						{
							config['shareClip'].y =(hei/2)-(config['shareClip'].height/2);
						}
						else
						{
							config['shareClip'].y =(config['shareClip'].height/2)-(hei/2);
						}
					}
					else
					{
						config['shareClip'].height = hei;
						config['shareClip'].scaleX = 100;
						config['shareClip'].width =(config['org_width'] * config['shareClip'].height / config['org_height'])-50;
						config['shareClip'].y = 0;
						if ((wid/2)>(config['shareClip'].width/2))
						{
							config['shareClip'].x =(wid/2)-(config['shareClip'].width/2);
						}
						else
						{
							config['shareClip'].x =(config['shareClip'].width/2)-(wid/2);
						}
					}
					break;
					//Original
				case "1" :
					config['shareClip'].width = config['org_width'];
					config['shareClip'].height = config['org_height'];
					config['shareClip'].x = (wid/2)-(config['org_width']/2);
					config['shareClip'].y = (hei/2)-(config['org_height']/2);
					break;
					//Fit to window
				case "2" :
					if (config['video'] == "youtube")
					{
						config['YTPlayer'].x = 0;
						config['YTPlayer'].y = 0;
						config['YTPlayer'].scaleX = config['YTPlayer'].scaleY = 1;
						config['YTPlayer'].setSize(config['stageWidth'], config['stageHeight']);
					}
					else
					{
						config['shareClip'].width = wid;
						config['shareClip'].height = hei;
						config['shareClip'].x = 0;
						config['shareClip'].y = 0;
					}
					break;
			}
			config['dailyBG'].height = hei - 110;
			config['dailyBG'].width = wid;
			config['dailyBG'].x = 0;
			config['dailyBG'].y = 0;
			config['shareClip'].visible = true;
			config['w'] = config['shareClip'].width;
			config['h'] = config['shareClip'].height;
			config['x'] = config['shareClip'].x;
			config['y'] = config['shareClip'].y;
			config['Playbtn'].scaleX = config['Playbtn'].scaleY = 1;
			if (config['skinMc'].y > config['stageHeight'])
			{
				config['Playbtn'].x = config['buffer_Mc'].x = config['stageWidth'] / 2;
				config['Playbtn'].y = config['buffer_Mc'].y = config['stageHeight'] / 2;
			}
			else
			{
				config['Playbtn'].x = config['buffer_Mc'].x = config['stageWidth'] / 2;
				config['Playbtn'].y = config['buffer_Mc'].y = (config['stageHeight']-25)/2;
			}
			config['inc'] = 0;
			//========================================== set related video panel size ==============================================================================
			if (config['relatedview'] == true)
			{
				if (config["displayState"] == "normal")
				{
					if (config['numofimg'] < 4)
					{
						if (config['numofimg'] == 3)
						{
							config['relaMc'].width=2.65*((config['stageWidth']/3));
						}
						else if (config['numofimg'] == 1)
						{
							config['relaMc'].width=(config['stageWidth']/3.4);
						}
						else
						{
							config['relaMc'].width=1.77*((config['stageWidth']/3));
						}
						config['relaMc'].height=(1.02*(config['stageHeight']/3));
					}
					else
					{
						config['relaMc'].width=2.65*((config['stageWidth']/3));
						config['relaMc'].height=(2.05*(config['stageHeight']/3));
					}
				}
				else
				{
					if (config['numofimg'] < 4)
					{
						if (config['numofimg'] == 3)
						{
							config['relaMc'].width=2.80*(config['stageWidth']/4);
						}
						else if (config['numofimg'] ==1)
						{
							config['relaMc'].width=1.2*(config['stageWidth']/4);
						}
						else
						{
							config['relaMc'].width=2*((config['stageWidth']/4))-40;
						}
						config['relaMc'].height=(1.07*(config['stageHeight']/4));
					}
					else
					{
						config['relaMc'].width=2.80*(config['stageWidth']/4);
						config['relaMc'].height=(2.15*(config['stageHeight']/4));
					}
					config['relaMc'].x=(config['stageWidth']/2)-(config['relaMc'].width/2);
					config['relaMc'].y=(config['stageHeight']/2)-(config['relaMc'].height/2);
				}
				relatedvideo = new relatedVideo(config,reference);
				relatedvideo.setrelatedposition();
			}
			else
			{
				config['Lbt'].x = config['Rbt'].x = -300;
				if (config['mov'] == 2)
				{
					buttonVis();
				}
			}//========================================== set ads size ==============================================================================
			config['adIndicator'].bg.width = config['stageWidth'];
			if (config['adsManager']) 
			{
				var imaAdsload = new adsplayer(config,reference);
				imaAdsload.displayAdsInformation();
			}
			if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
			{
				slideRelatedVideo = new sliderelatedVideo(config,reference);
				slideRelatedVideo.setrelatedposition();
				if (config['thuMc'].sh_hi.show.visible == true)
				{
					config['thuMc'].x = config['stageWidth'];
				}
				else
				{
					config['thuMc'].x = config['stageWidth'] - config['thuMc'].thubg.width;
				}
			}
			if (config['errorMc'].visible == true)
			{
				config['errorMc'].x = config['stageWidth'] / 2;
				config['errorMc'].y = config['stageHeight'] / 2;
			}
			config['skinMc'].y = config['stageHeight']-(config['skinMc'].skin_bg.height);

			if (config['mailB'] == true)
			{
				config['mailPanel'].scaleX = config['stageHeight'] / 310;
				config['mailPanel'].scaleY = config['stageHeight'] / 310;
				config['mailPanel'].x=(config['stageWidth']/2)-(config['mailPanel'].width/2);
				config['mailPanel'].y=(config['stageHeight']/2)-(config['mailPanel'].height/2);
			}
			if (config['shareB'] == true)
			{
				config['SocialPanel'].scaleX = config['stageHeight'] / 310;
				config['SocialPanel'].scaleY = config['stageHeight'] / 310;
				config['SocialPanel'].x=(config['stageWidth']/2)-(config['SocialPanel'].width/2);
				config['SocialPanel'].y=(config['stageHeight']/2)-(config['SocialPanel'].height/2);
			}

		}
		//========================================== set position for share zoom and downloads button ==============================================================================
		function buttonVis()
		{
			if (config['errorMc'].visible != true && config['preval'] == false && config['mov'] == 2)
			{
				config['zoomOutMc'].alpha = config['zoomInMc'].alpha = config['shareMc'].alpha = config['mailIcon'].alpha = config['downloadMc'].alpha = 1;
				var yyposi = 10;
				if (config['shareIcon'] == "true")
				{
					config['shareMc'].visible = true;
					config['shareMc'].y = yyposi;
					yyposi = yyposi + 43;
				}
				else
				{
					config['shareMc'].visible = false;
				}
				if (config['email'] == "true")
				{
					config['mailIcon'].visible = true;
					config['mailIcon'].y = yyposi;
					yyposi = yyposi + 43;
				}
				else
				{
					config['mailIcon'].visible = false;
				}
				if (config['zoomIcon'] == "true" && config['shareB'] == false && config['mailB'] == false)
				{
					if (config['inc'] < 3)
					{
						config['zoomInMc'].visible = true;
						config['zoomInMc'].y = yyposi;
						yyposi = yyposi + 43;
					}
					else
					{
						config['zoomInMc'].visible = false;
					}
					if (config['inc'] > 0)
					{
						config['zoomOutMc'].visible = true;
						config['zoomOutMc'].y = yyposi;
						yyposi = yyposi + 43;
					}
					else
					{
						config['zoomOutMc'].visible = false;
					}
				}
				else
				{
					config['zoomOutMc'].visible = config['zoomInMc'].visible = false;
				}
				if (config['file'] != undefined && config['PDownload'] == "true" && config['file'].indexOf('youtube') <= -1 && config['file'].indexOf('dailymotion') <= -1 && config['file'].indexOf('viddler') <= -1)
				{
					if (config['streamer'] != null && config['streamer'].indexOf("rtmp") <= -1)
					{
						config['downloadMc'].visible = true;
						config['downloadMc'].y = yyposi;
					}
					else
					{
						config['downloadMc'].visible = false;
					}
				}
				else
				{
					config['downloadMc'].visible = false;
				}
				config['mailIcon'].x = config['zoomOutMc'].x = config['zoomInMc'].x = config['shareMc'].x = config['downloadMc'].x = 8;

				if (config['showTag'] == "true" && config['preval'] != true)
				{
					if (config['mov'] == 2 && config['caption_video'][config['vid']] != undefined)
					{
						taglineposition();
					}
					else if (config['mov']!= 2 && config['adsDesArr'][config['adindex']] != undefined)
					{
						taglineposition();
					}
					else
					{
						config['tagline'].visible = false;
					}
				}

			}
		}//========================================== button invisible function ==============================================================================
		public function buttonInVis()
		{
			config['mailIcon'].visible = config['shareMc'].visible = config['zoomInMc'].visible = config['zoomOutMc'].visible = config['downloadMc'].visible = false;
			if (config['showTag'] == "true")
			{
				if (config['mov'] == 2 && config['caption_video'][config['vid']] != undefined)
				{
					taglineposition();
				}
				else if (config['mov']!= 2 && config['adsDesArr'][config['adindex']] != undefined)
				{
					taglineposition();
				}
				else
				{
					config['tagline'].visible = false;
				}
			}
		}
		public function taglineposition()
		{
			if (config['preval'] != true)
			{
				config['tagline'].visible = true;
				config['tagline'].bg.width = config['tagline'].txt.width;
				var tw:Number = config['stageWidth']-((2*(config['stageHeight']/9.5))+20);
				config['tagline'].bg.x = 0;
				if (config['mov'] == 2)
				{
					if(config['embedplayer'] != "true")config['tagline'].x = config['mailIcon'].width + 20;
					else config['tagline'].x = 5;
				}
				else
				{
					config['tagline'].x = 10;
				}
				if (tw<config['tagline'].bg.width)
				{
					config['tagline'].bg.width = tw;
					config['tagline'].dot.x = config['tagline'].bg.width;
					config['tagline'].dot.visible = true;
					if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
					{
						if (config['thuMc'].x < config['stageWidth'] - 50 && config['mov'] == 2)
						{
							new Tween(config['tagline'].bg, "x",null,config['tagline'].bg.x,-(config['thuMc'].thubg.width-(config['stageHeight']/9.5)), 0.4, true);
							new Tween(config['tagline'].dot, "x",null,config['tagline'].dot.x,config['tagline'].bg.width-(config['thuMc'].thubg.width-(config['stageHeight']/9.5)), 0.4, true);
						}
					}
				}
				else
				{
					config['tagline'].dot.visible = false;
				}
			}
			else
			{
				config['tagline'].visible = false;
			}
		}
		//========================================== set midroll position  ==============================================================================
		public function alignmidroll(mVis:Boolean)
		{
			if (config['midroll_ads'] == "true" && config['allowmidroll'] == "true" && config['mov'] == 2 && config['imaAds'] == false)
			{
				if (config['currentTime'] > config['midbegin'])
				{
					if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
					{
						if (config['thuMc'].sh_hi.show.visible == true)
						{
							config['midRoll'].x = (config['stageWidth']/2)-(config['midRoll'].midbg.width/2);
						}
						else if ((config['midRoll'].x+config['midRoll'].midbg.width)>(config['stageWidth']-config['thuMc'].thubg.width))
						{
							config['midRoll'].x = config['stageWidth']-(config['thuMc'].thubg.width+config['midRoll'].midbg.width);
						}
						else
						{
							config['midRoll'].x = (config['stageWidth']/2)-(config['midRoll'].midbg.width/2);
						}
					}
					else
					{
						config['midRoll'].x = (config['stageWidth']/2)-(config['midRoll'].midbg.width/2);
					}
					if (mVis)
					{
						config['midRoll'].alpha = 1;
						config['midRoll'].visible = true;
						config['adv'].visible = true;
						config['midRoll'].y = (config['stageHeight']-25) - (config['midRoll'].midbg.height+8) ;
						config['adv'].y = config['stageHeight'] + 50;
						config['adv'].x = config['stageWidth'];
					}
					else
					{
						config['midRoll'].alpha = 1;
						config['midRoll'].visible = true;
						config['adv'].visible = true;
						config['midRoll'].y = config['skinMc'].y + (config['midRoll'].midbg.height+8) ;
						if (config['currentTime'] > 0)
						{
							config['adv'].y = config['skinMc'].y - 8;
						}
						else
						{
							config['adv'].y = config['stageHeight'] + 100;
						}
						config['adv'].x = config['stageWidth'];
					}
				}
			}
			else
			{
				config['midRoll'].alpha = 0;
				config['midRoll'].visible = false;
				config['midRoll'].y = config['skinMc'].y + (config['midRoll'].midbg.height+8) ;
				if (config['currentTime'] > 0)
				{
					config['adv'].y = config['skinMc'].y - 8;
				}
				else
				{
					config['adv'].y = config['stageHeight'] + 100;
				}
				config['adv'].x = config['stageWidth'];
			}
		}
	}
}