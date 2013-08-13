package script
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.xml.*;
	import flash.display.*;
	import flash.net.NetStream;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;

	public class xmlLoad extends EventDispatcher
	{
		//========================================== Declare common variable for all classes ==============================================================================
		public var config:Object = 
		{
		baseurl:String,
		plistlength:Number,
		video_url:Array,
		video_hdpath:Array,
		video_id:Array,
		thumb_image:Array,
		preview_image:Array,
		allow_preroll:Array,
		allow_postroll:Array,
		allow_ima:Array,
		allow_midroll:Array,
		preroll_id:Array,
		postroll_id:Array,
		disply_copylink:Array,
		streamer_path:Array,
		video_src:Array,
		allow_download:Array,
		video_category:Array,
		video_rating:Array,
		video_isLive:Array,
		video_ratecount:Array,
		date_vid:Array,
		video_title:Array,
		video_description:Array,
		video_targeturl:Array,
		video_views:Array,
		tags_vid:Array,
		member_arr:Array,
		embedplayer:String,
		setnum:Number,
		
		file:String,
		preview:String,
		backBg:MovieClip,
		buffer_Mc:MovieClip,
		adIndicator:MovieClip,
		labelBt:MovieClip,
		tooltipMc:MovieClip,
		videoType:String,
		video:String,
		stream:NetStream,
		stageover:Boolean,
		
		skinMc:MovieClip,
		stageWidth:Number,
		stageHeight:Number,
		nDuration:Number,
		currentTime:Number,
		v:Number,
		skinout:Boolean,
		intP:Boolean,
		
		hd:String,
		videoscale:String,
		vidscale:Number,
		startSec:Number,
		
		adrandom:String,
		adslistlength:String,
		adsUrlArr:Array,
		adsTargetArr:Array,
		adsClickArr:Array,
		adsImpressionArr:Array,
		ads_IdArr:Array,
		adsHitsArr:Array,
		adsImpressionHitsArr:Array,
		adsDesArr:Array,
		
		imA:Boolean,
		
		midslistlength:Number,
		midinterval:Number,
		midbegin:Number,
		adinterval:Number,
		midvis:Boolean,
		
		plistrandom:String,
		playlist_autoplay:String,
		vid:Number,
		streamer:String,
		mov:Number,
		allowpreroll:String,
		allowpostroll:String,
		adtarget:String,
		adclickurl:String,
		adimpressionurl:String,
		adhitsurl:String,
		impressionhits:String,
		vid_id:Number,
		PDownload:String,
		precontainer:MovieClip,
		vidarr:Array,
		
		allowmidroll:String,
		allowpostroll:String,
		bolProgressScrub:Boolean,
		preval:Boolean,
		mouseXpos:Number,
		ref:Sprite,
		org_width:Number,
		org_height:Number,
		playeruI:Object,
		ProgbarWidth:Number,
		
		Playbtn:MovieClip,
		myVideo:MovieClip,
		isplayed:Boolean,
		off:Number,
		timeOffset:Number,
		pixelOffset:Number,
		mp4:Boolean,
		meta:Boolean,
		keyframes:Object,
		YTPlayer:Object,
		qualityLevels:Array,
		YoutubeLoader:Loader,
		hdclicked:Boolean,
		bolVolumeScrub:Boolean,
		intLastVolume:Number,
		relatedview:Boolean,
		relaMc:MovieClip,
		imgContH:Number,
		imgContW:Number,
		xposs:Number,
		yposs:Number,
		numofimg:Number,
		imageCount:Number,
		pase:Boolean,
		update:Boolean,
		downBool:Boolean,
		upBool:Boolean,
		thub:Boolean,
		shareB:Boolean,
		pauseState:Boolean,
		videoAvailable:Boolean,
		tagline:String,
		reclick:Boolean,
		
		x:Number,
		y:Number,
		w:Number,
		h:Number,
		yw:Number,
		yh:Number,
		shareClip:MovieClip,
		
		copylink:String,
		isLive:String,
		title:String,
		caption_video:Array,
		pageURL:String,
		errorMc:MovieClip,
		
		inc:Number,
		displayState:String,
		
		relatedview:Boolean,
		imageCount:Number,
		numofimg:Number,
		rt:Boolean,
		
		downBool:Boolean,
		upBool:Boolean,
		
		audio:Sound,
		audioChannel:SoundChannel,
		lastPosition:Number,
		ini:Boolean,
		pre_vid:Number,
		ran:Number,
		stremPlayed:Boolean,
		QualityArray:Array,
		autopL:MovieClip,
		autopImgArr:Array,
		emailB:Boolean
		};
		public static var reference:Sprite;
		private var obj:Object;
		private var configLoader:URLLoader;
		private var crossLoader:URLLoader;
		private var playlistLoader:URLLoader;

		private var video_url:Array;
		private var video_hdpath:Array;
		private var video_id:Array;
		private var thumb_image:Array;
		private var preview_image:Array;
		private var allow_preroll:Array;
		private var allow_postroll:Array;
		private var allow_ima:Array;
		private var allow_midroll:Array;
		private var preroll_id:Array;
		private var postroll_id:Array;
		private var disply_copylink:Array;
		private var streamer_path:Array;
		private var video_src:Array;
		private var allow_download:Array;
		private var video_category:Array;
		private var video_rating:Array;
		private var video_isLive:Array;
		private var video_ratecount:Array;
		private var date_vid:Array;
		private var video_title:Array;
		private var video_description:Array;
		private var video_targeturl:Array;
		private var video_views:Array;
		private var tags_vid:Array;
		private var duration_arr:Array;
		private var member_arr:Array;
		private var plistDoc:XMLDocument;
		private var caption_video:Array;
		private var errorMc:errorpopup;
		private var MessageClass:Message;
		private var playlistid:String;
		private var char_arr:Array;
		private var fbpath_arr:Array;


		public function xmlLoad(ref:Sprite,wid,hei):void
		{
			video_url = new Array();
			video_hdpath = new Array();
			video_id = new Array();
			thumb_image = new Array();
			preview_image = new Array();
			allow_preroll = new Array();
			allow_postroll = new Array();
			allow_ima = new Array();
			allow_midroll = new Array();
			preroll_id = new Array();
			postroll_id = new Array();
			disply_copylink = new Array();
			streamer_path = new Array();
			video_src = new Array();
			allow_download = new Array();
			video_category = new Array();
			video_rating = new Array();
			video_isLive = new Array();
			video_ratecount = new Array();
			date_vid = new Array();
			video_title = new Array();
			video_description = new Array();
			video_targeturl = new Array();
			video_views = new Array();
			tags_vid = new Array();
			member_arr = new Array();
			duration_arr = new Array();
			caption_video = new Array();
			fbpath_arr = new Array();
			config['vidarr'] = new Array();
			config['QualityArray'] = new Array()
			config['inc'] = 0;
			config['midvis'] = false;
			config['skinout'] = false;
			config['videoAvailable'] = false;
			config['mailB'] = false;
			config['downBool'] = false;
			config['upBool'] = false;
			config['thub'] = false;
			config['shareB'] = false;
			config['relatedview'] = false;
			config['relaMc'] = new MovieClip();
			config['rt'] = true;
			config['pauseState'] = false;
			config['setnum'] = 0;
			config['intP'] = true;
			config['startSec'] = 0;
			config['reclick'] = false;
			config['downBool'] = false;
			config['upBool'] = false;
			config['stageover'] = false;
			config['v'] = 0;
			config['update'] = false;
			config['pase'] = false;
			config['imageCount'] = config['imgContH'] = config['imgContW'] = config['xposs'] = config['yposs'] = 0;
			config['relatedview'] = false;
			config['intLastVolume'] = 0;
			config['bolVolumeScrub'] = false;
			config['hdclicked'] = false;
			config['meta'] = false;
			config['mp4'] = false;
			config['off'] = config['timeOffset'] = config['pixelOffset'] = 0;
			config['isplayed'] = false;
			config['bolProgressScrub'] = false;
			config['mov'] = 1;
			config['vid'] = 0;
			config['ref'] = ref;
			reference = ref;
			config['stageWidth'] = wid;
			config['stageHeight'] = hei;
			var configPath:String;
			config['preval'] = false;
			config['ini'] = true;
			config['stremPlayed'] = true;
			config['ran'] = Math.round(Math.random()*10000000)
			config['baseurl'] = reference.root.loaderInfo.url.replace('hdplayer.swf','');
			config['embedplayer'] = reference.root.loaderInfo.parameters['embedplayer'];
			config['mtype'] = reference.root.loaderInfo.parameters['mtype'];
			var FullUrl:String = reference.root.loaderInfo.url;
			var lastSlashIndex:Number = FullUrl.lastIndexOf("/");
			var DriveSepIndex:Number = FullUrl.indexOf("|");
			if (DriveSepIndex >= 0)
			{
				config['pageURL'] = FullUrl.substring(0,DriveSepIndex);
				config['pageURL'] +=  ":";
			}
			else
			{
				config['pageURL'] = "";
			}
			config['pageURL'] += FullUrl.substring(DriveSepIndex + 1, lastSlashIndex + 1);
			errorMc = new errorpopup();
			errorMc.visible = false;
			ref.addChild(errorMc);
			config['errorMc'] = errorMc;
			if (reference.root.loaderInfo.url.indexOf('file:///') <= -1)
			{
				if (reference.root.loaderInfo.parameters['baserefM'])
				{
					configPath = megentoUri();
					configloadXML(configPath);
				}
				else if (reference.root.loaderInfo.parameters['baserefW'])
				{
					configPath = wordpressUri();
					configloadXML(configPath);
				}
				else
				{
					configPath = standaloneuri();
					configloadXML(configPath+"?coid="+config['ran']);
				}
			}
		}
		private function megentoUri()
		{
			var basearM:String = reference.root.loaderInfo.parameters['baserefM'];
			basearM +=  "videoupload/index/config?";
			if (reference.root.loaderInfo.parameters['id'])
			{
				basearM +=  "id=" + reference.root.loaderInfo.parameters['id'];
			}
			if (reference.root.loaderInfo.parameters['pid'])
			{
				basearM +=  "&pid=" + reference.root.loaderInfo.parameters['pid'];
			}
			basearM +=  "&coid=" + config['ran'];
			return (reference.root.loaderInfo.parameters['config']) ? (reference.root.loaderInfo.parameters['config']) : basearM;
		}
		private function wordpressUri()
		{
			var basearW:String;
			char_arr = new Array()
			char_arr = reference.root.loaderInfo.url.split("hdflvplayer/hdplayer.swf")
			basearW = char_arr[0] + "configXML.php";
			char_arr = new Array()
			char_arr = reference.root.loaderInfo.url.split("hdplayer.swf")
			config['basearW'] = char_arr[0]
			return (reference.root.loaderInfo.parameters['config']) ? (reference.root.loaderInfo.parameters['config']) : basearW;
		}
		//========================================== standalone ==============================================================================
		private function standaloneuri()
		{
			var basear = config['baseurl'].split("?file=");
			config['baseurl'] = basear[0];
			return (reference.root.loaderInfo.parameters['config']) ? (reference.root.loaderInfo.parameters['config']) : (config['baseurl'] + "xml/config.xml");
		}
		private function configloadXML(url:String):void
		{
			Security.allowDomain("*");
			configLoader = new URLLoader();
			configLoader.addEventListener(Event.COMPLETE,configXmlHandler);
			configLoader.addEventListener(IOErrorEvent.IO_ERROR, configError);
			Security.allowDomain("*");
			configLoader.load(new URLRequest(unescape(url)));
		}
		private function configError(evt:IOErrorEvent)
		{
			MessageClass = new Message(config,reference);
			MessageClass.show("There is an Error in loading config.xml");
		}
		private function configXmlHandler(evt:Event):void
		{
			var configxml:XML = XML(evt.target.data);
			for each (var prp:XML in configxml.children())
			{
				config[prp.name()] = prp.text();
			}
			var languagexmlLoad = new languageXml(reference,config);
			var adsxmlLoad = new adsXml(reference,config);
			if (config['imaAds'] == "true")
			{
				var ImaXmlLoad = new ImaXml(reference,config);
			}
			loadPlistxml();
		}
		//========================================== get values fron flashvar ==============================================================================
		public function loadFlashvars():void
		{
			config['autoplay'] = (reference.root.loaderInfo.parameters['autoplay']) ? reference.root.loaderInfo.parameters['autoplay'] : config['autoplay'];
			config['buffer'] = (reference.root.loaderInfo.parameters['buffer']) ? reference.root.loaderInfo.parameters['buffer'] : config['buffer'];
			config['volume'] = (reference.root.loaderInfo.parameters['volume']) ? reference.root.loaderInfo.parameters['volume'] : config['volume'];
			config['normalscale'] = (reference.root.loaderInfo.parameters['normalscale']) ? reference.root.loaderInfo.parameters['normalscale'] : config['normalscale'];
			config['fullscreenscale'] = (reference.root.loaderInfo.parameters['fullscreenscale']) ? reference.root.loaderInfo.parameters['fullscreenscale'] : config['fullscreenscale'];
			config['logopath'] = (reference.root.loaderInfo.parameters['logopath']) ? reference.root.loaderInfo.parameters['logopath'] : config['logopath'];
			config['logoalpha'] = (reference.root.loaderInfo.parameters['logoalpha']) ? reference.root.loaderInfo.parameters['logoalpha'] : config['logoalpha'];
			config['logoalign'] = (reference.root.loaderInfo.parameters['logoalign']) ? reference.root.loaderInfo.parameters['logoalign'] : config['logoalign'];
			config['logo_target'] = (reference.root.loaderInfo.parameters['logo_target']) ? reference.root.loaderInfo.parameters['logo_target'] : config['logo_target'];
			config['skin'] = (reference.root.loaderInfo.parameters['skin']) ? reference.root.loaderInfo.parameters['skin'] : config['skin'];
			config['skin_autohide'] = (reference.root.loaderInfo.parameters['skin_autohide']) ? reference.root.loaderInfo.parameters['skin_autohide'] : config['skin_autohide'];
			config['playlist_open'] = (reference.root.loaderInfo.parameters['playlist_open']) ? reference.root.loaderInfo.parameters['playlist_open'] : config['playlist_open'];
			config['showPlaylist'] = (reference.root.loaderInfo.parameters['showPlaylist']) ? reference.root.loaderInfo.parameters['showPlaylist'] : config['showPlaylist'];
			config['HD_default'] = (reference.root.loaderInfo.parameters['HD_default']) ? reference.root.loaderInfo.parameters['HD_default'] : config['HD_default'];
			config['preroll_ads'] = (reference.root.loaderInfo.parameters['preroll_ads']) ? reference.root.loaderInfo.parameters['preroll_ads'] : config['preroll_ads'];
			config['postroll_ads'] = (reference.root.loaderInfo.parameters['postroll_ads']) ? reference.root.loaderInfo.parameters['postroll_ads'] : config['postroll_ads'];
			config['midroll_ads'] = (reference.root.loaderInfo.parameters['midroll_ads']) ? reference.root.loaderInfo.parameters['midroll_ads'] : config['midroll_ads'];
			config['embed_visible'] =(reference.root.loaderInfo.parameters['embed_visible']) ? reference.root.loaderInfo.parameters['embed_visible'] : config['embed_visible'];
			config['Download'] = (reference.root.loaderInfo.parameters['Download']) ? reference.root.loaderInfo.parameters['Download'] : config['Download'];
			config['adsSkip'] = (reference.root.loaderInfo.parameters['adsSkip']) ? reference.root.loaderInfo.parameters['adsSkip'] : config['adsSkip'];
			config['adsSkipDuration'] = (reference.root.loaderInfo.parameters['adsSkipDuration']) ? reference.root.loaderInfo.parameters['adsSkipDuration'] : config['adsSkipDuration'];
			config['relatedVideoView'] = (reference.root.loaderInfo.parameters['relatedVideoView']) ? reference.root.loaderInfo.parameters['relatedVideoView'] : config['relatedVideoView'];
			config['imaAds'] = (reference.root.loaderInfo.parameters['imaAds']) ? reference.root.loaderInfo.parameters['imaAds'] : config['imaAds'];
			config['license'] = (reference.root.loaderInfo.parameters['license']) ? reference.root.loaderInfo.parameters['license'] : config['license'];
			config['trackCode'] = (reference.root.loaderInfo.parameters['trackCode']) ? reference.root.loaderInfo.parameters['trackCode'] : config['trackCode'];
			config['scaleToHideLogo'] = (reference.root.loaderInfo.parameters['scaleToHideLogo']) ? reference.root.loaderInfo.parameters['scaleToHideLogo'] : config['scaleToHideLogo'];
			config['showTag'] = (reference.root.loaderInfo.parameters['showTag']) ? reference.root.loaderInfo.parameters['showTag'] : config['showTag'];
			config['debug'] = (reference.root.loaderInfo.parameters['debug']) ? reference.root.loaderInfo.parameters['debug'] : config['debug'];
			config['imageDefault'] = (reference.root.loaderInfo.parameters['imageDefault']) ? reference.root.loaderInfo.parameters['imageDefault'] : config['imageDefault'];
			config['timer'] = (reference.root.loaderInfo.parameters['timer']) ? reference.root.loaderInfo.parameters['timer'] : config['timer'];
			config['playlist_auto'] = (reference.root.loaderInfo.parameters['playlist_auto']) ? reference.root.loaderInfo.parameters['playlist_auto'] : config['playlist_auto'];
			config['zoomIcon'] = (reference.root.loaderInfo.parameters['zoomIcon']) ? reference.root.loaderInfo.parameters['zoomIcon'] : config['zoomIcon'];
			config['email'] = (reference.root.loaderInfo.parameters['email']) ? reference.root.loaderInfo.parameters['email'] : config['email'];
			config['shareIcon'] = (reference.root.loaderInfo.parameters['shareIcon']) ? reference.root.loaderInfo.parameters['shareIcon'] : config['shareIcon'];
			config['fullscreen'] = (reference.root.loaderInfo.parameters['fullscreen']) ? reference.root.loaderInfo.parameters['fullscreen'] : config['fullscreen'];
			config['volumecontrol'] = (reference.root.loaderInfo.parameters['volumecontrol']) ? reference.root.loaderInfo.parameters['volumecontrol'] : config['volumecontrol'];
			config['progressControl'] = (reference.root.loaderInfo.parameters['progressControl']) ? reference.root.loaderInfo.parameters['progressControl'] : config['progressControl'];

			config['file'] = (reference.root.loaderInfo.parameters['file']) ? reference.root.loaderInfo.parameters['file'] : config['video_url'][0];
			config['preview'] = (reference.root.loaderInfo.parameters['preview']) ? reference.root.loaderInfo.parameters['preview'] : config['preview_image'][0];
			config['thumb'] = (reference.root.loaderInfo.parameters['thumb']) ? reference.root.loaderInfo.parameters['thumb'] : config['thumb_image'][0];
			config['isLive'] = (reference.root.loaderInfo.parameters['isLive']) ? reference.root.loaderInfo.parameters['isLive'] : config['video_isLive'][0];
			config['title'] = (reference.root.loaderInfo.parameters['title']) ? reference.root.loaderInfo.parameters['title'] : config['video_title'][0];
			config['copylink'] = (reference.root.loaderInfo.parameters['copylink']) ? reference.root.loaderInfo.parameters['copylink'] : config['disply_copylink'][0];
			config['allowpostroll'] = (reference.root.loaderInfo.parameters['allowpostroll']) ? reference.root.loaderInfo.parameters['allowpostroll'] : config['allow_postroll'][0];
			config['allowpreroll'] = (reference.root.loaderInfo.parameters['allowpreroll']) ? reference.root.loaderInfo.parameters['allowpreroll'] : config['allow_preroll'][0];
			config['allow_imaAds'] = (reference.root.loaderInfo.parameters['allow_imaAds']) ? reference.root.loaderInfo.parameters['allow_imaAds'] : config['allow_ima'][0];
			config['playlist_autoplay'] = (reference.root.loaderInfo.parameters['playlist_autoplay']) ? reference.root.loaderInfo.parameters['playlist_autoplay'] : config['playlist_autoplay'];
			config['hd'] = "false";
			if (config['pageURL'].indexOf('file:///') > -1)
			{
				config['preroll_ads'] = config['allowpreroll'];
				config['postroll_ads'] = config['allowpostroll'];
			}
			if (reference.root.loaderInfo.parameters['stagecolor'] == "")
			{
				config['stagecolor'] = "";
			}
			else
			{
				config['stagecolor'] = (reference.root.loaderInfo.parameters['stagecolor']) ? reference.root.loaderInfo.parameters['stagecolor'] : config['stagecolor'];
			}

			if (reference.root.loaderInfo.parameters['skinBgColor'] == "")
			{
				config['skinBgColor'] = "";
			}
			else
			{
				config['skinBgColor'] = (reference.root.loaderInfo.parameters['skinBgColor']) ? reference.root.loaderInfo.parameters['skinBgColor'] : config['skinBgColor'];
			}

			if (reference.root.loaderInfo.parameters['relatedVideoBgColor'] == "")
			{
				config['relatedVideoBgColor'] = "";
			}
			else
			{
				config['relatedVideoBgColor'] = (reference.root.loaderInfo.parameters['relatedVideoBgColor']) ? reference.root.loaderInfo.parameters['relatedVideoBgColor'] : config['relatedVideoBgColor'];
			}

			if (reference.root.loaderInfo.parameters['textColor'] == "")
			{
				config['textColor'] = "";
			}
			else
			{
				config['textColor'] = (reference.root.loaderInfo.parameters['textColor']) ? reference.root.loaderInfo.parameters['textColor'] : config['textColor'];
			}

			if (reference.root.loaderInfo.parameters['seek_barColor'] == "")
			{
				config['seek_barColor'] = "";
			}
			else
			{
				config['seek_barColor'] = (reference.root.loaderInfo.parameters['seek_barColor']) ? reference.root.loaderInfo.parameters['seek_barColor'] : config['seek_barColor'];
			}

			if (reference.root.loaderInfo.parameters['buffer_barColor'] == "")
			{
				config['buffer_barColor'] = "";
			}
			else
			{
				config['buffer_barColor'] = (reference.root.loaderInfo.parameters['buffer_barColor']) ? reference.root.loaderInfo.parameters['buffer_barColor'] : config['buffer_barColor'];
			}

			if (reference.root.loaderInfo.parameters['pro_BgColor'] == "")
			{
				config['pro_BgColor'] = "";
			}
			else
			{
				config['pro_BgColor'] = (reference.root.loaderInfo.parameters['pro_BgColor']) ? reference.root.loaderInfo.parameters['pro_BgColor'] : config['pro_BgColor'];
			}

			if (reference.root.loaderInfo.parameters['skinIconColor'] == "")
			{
				config['skinIconColor'] = "";
			}
			else
			{
				config['skinIconColor'] = (reference.root.loaderInfo.parameters['skinIconColor']) ? reference.root.loaderInfo.parameters['skinIconColor'] : config['skinIconColor'];
			}

			if (reference.root.loaderInfo.parameters['sharepanel_up_BgColor'] == "")
			{
				config['sharepanel_up_BgColor'] = "";
			}
			else
			{
				config['sharepanel_up_BgColor'] = (reference.root.loaderInfo.parameters['sharepanel_up_BgColor']) ? reference.root.loaderInfo.parameters['sharepanel_up_BgColor'] : config['sharepanel_up_BgColor'];
			}

			if (reference.root.loaderInfo.parameters['sharepanel_down_BgColor'] == "")
			{
				config['sharepanel_down_BgColor'] = "";
			}
			else
			{
				config['sharepanel_down_BgColor'] = (reference.root.loaderInfo.parameters['sharepanel_down_BgColor']) ? reference.root.loaderInfo.parameters['sharepanel_down_BgColor'] : config['sharepanel_down_BgColor'];
			}

			if (reference.root.loaderInfo.parameters['sharepaneltextColor'] == "")
			{
				config['sharepaneltextColor'] = "";
			}
			else
			{
				config['sharepaneltextColor'] = (reference.root.loaderInfo.parameters['sharepaneltextColor']) ? reference.root.loaderInfo.parameters['sharepaneltextColor'] : config['sharepaneltextColor'];
			}

			if (reference.root.loaderInfo.parameters['sharepanel_textBgColor'] == "")
			{
				config['sharepanel_textBgColor'] = "";
			}
			else
			{
				config['sharepanel_textBgColor'] = (reference.root.loaderInfo.parameters['sharepanel_textBgColor']) ? reference.root.loaderInfo.parameters['sharepanel_textBgColor'] : config['sharepanel_textBgColor'];
			}

			if (reference.root.loaderInfo.parameters['sendButtonColor'] == "")
			{
				config['sendButtonColor'] = "";
			}
			else
			{
				config['sendButtonColor'] = (reference.root.loaderInfo.parameters['sendButtonColor']) ? reference.root.loaderInfo.parameters['sendButtonColor'] : config['sendButtonColor'];
			}

			if (reference.root.loaderInfo.parameters['sendButtonTextColor'] == "")
			{
				config['sendButtonTextColor'] = "";
			}
			else
			{
				config['sendButtonTextColor'] = (reference.root.loaderInfo.parameters['sendButtonTextColor']) ? reference.root.loaderInfo.parameters['sendButtonTextColor'] : config['sendButtonTextColor'];
			}

			if (reference.root.loaderInfo.parameters['playButtonColor'] == "")
			{
				config['playButtonColor'] = "";
			}
			else
			{
				config['playButtonColor'] = (reference.root.loaderInfo.parameters['playButtonColor']) ? reference.root.loaderInfo.parameters['playButtonColor'] : config['playButtonColor'];
			}

			if (reference.root.loaderInfo.parameters['playButtonBgColor'] == "")
			{
				config['playButtonBgColor'] = "";
			}
			else
			{
				config['playButtonBgColor'] = (reference.root.loaderInfo.parameters['playButtonBgColor']) ? reference.root.loaderInfo.parameters['playButtonBgColor'] : config['playButtonBgColor'];
			}

			if (reference.root.loaderInfo.parameters['playerButtonColor'] == "")
			{
				config['playerButtonColor'] = "";
			}
			else
			{
				config['playerButtonColor'] = (reference.root.loaderInfo.parameters['playerButtonColor']) ? reference.root.loaderInfo.parameters['playerButtonColor'] : config['playerButtonColor'];
			}

			if (reference.root.loaderInfo.parameters['playerButtonBgColor'] == "")
			{
				config['playerButtonBgColor'] = "";
			}
			else
			{
				config['playerButtonBgColor'] = (reference.root.loaderInfo.parameters['playerButtonBgColor']) ? reference.root.loaderInfo.parameters['playerButtonBgColor'] : config['playerButtonBgColor'];
			}

			if (reference.root.loaderInfo.parameters['file'] && reference.root.loaderInfo.parameters['hdVideos'])
			{
				config['hd'] = "true";
			}
			else if (!reference.root.loaderInfo.parameters['file'])
			{
				if (config['video_hdpath'][0])
				{
					config['hd'] = "true";
				}
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function loadPlistxml()
		{
			if (reference.root.loaderInfo.parameters['baserefM'])
			{
				config['playlistXML'] = config['playlistXML'];
			}
			else if (reference.root.loaderInfo.parameters['baserefW'])
			{
				config['playlistXML'] = config['playlistXML'] + "" + wodpressPlaylist();
			}
			else
			{
				config['playlistXML'] = config['playlistXML'];

			}
			config['playlistXML'] = (reference.root.loaderInfo.parameters['playlistXML']) ? reference.root.loaderInfo.parameters['playlistXML'] : config['playlistXML'];
			if (config['playlistXML'].indexOf('http') > -1)
			{
				config['playlistXML'] = config['playlistXML'];
			}
			else
			{
				config['playlistXML'] = config['baseurl'] + "" + config['playlistXML'];
			}
			playlistLoader = new URLLoader();
			playlistLoader.addEventListener(Event.COMPLETE,playlistXmlHandler);
			playlistLoader.addEventListener(IOErrorEvent.IO_ERROR, playlistError);
			playlistLoader.load(new URLRequest(config['playlistXML']+"?plid="+config['ran']));
		}
		private function wodpressPlaylist()
		{
			if (reference.root.loaderInfo.parameters['pid'])
			{
				playlistid = "?pid=" + reference.root.loaderInfo.parameters['pid'];
				if (reference.root.loaderInfo.parameters['vid'])
				{
					playlistid +=  "&vid=" + reference.root.loaderInfo.parameters['vid'];
				}
				if (reference.root.loaderInfo.parameters['tagname'])
				{
					playlistid +=  "&tagname=" + reference.root.loaderInfo.parameters['tagname'];
				}
			}
			else if (reference.root.loaderInfo.parameters['vid'])
			{
				playlistid = "?vid=" + reference.root.loaderInfo.parameters['vid'];
				if (reference.root.loaderInfo.parameters['tagname'])
				{
					playlistid +=  "&tagname=" + reference.root.loaderInfo.parameters['tagname'];
				}
				if (reference.root.loaderInfo.parameters['page_id'])
				{
					playlistid +=  "&page_id=" + reference.root.loaderInfo.parameters['page_id'];
				}
			}
			else if (reference.root.loaderInfo.parameters['tagname'])
			{
				playlistid = "&tagname=" + reference.root.loaderInfo.parameters['tagname'];
			}
			else if (reference.root.loaderInfo.parameters['featured'])
			{
				playlistid = "?featured=" + reference.root.loaderInfo.parameters['featured'];
			}
			if (reference.root.loaderInfo.parameters['numberofvideos'])
			{
				playlistid = playlistid + "&numberofvideos=" + reference.root.loaderInfo.parameters['numberofvideos'];
			}
			if (reference.root.loaderInfo.parameters['type'])
			{
				playlistid = playlistid + "&type=" + reference.root.loaderInfo.parameters['type'];
			}
			return playlistid;
		}
		private function playlistError(evt:IOErrorEvent)
		{
			MessageClass = new Message(config,reference);
			MessageClass.show("There is an Error in loading playlist.xml");
		}
		private function playlistXmlHandler(evt:Event):void
		{
			var plistxml:XML = XML(evt.target.data);
			if (plistxml=="")
			{
				config['plistlength'] = 0;
				if (! reference.root.loaderInfo.parameters['file'] && ! reference.root.loaderInfo.parameters['hdpath'])
				{
					MessageClass = new Message(config,reference);
					MessageClass.show("There is no videos in this playlist");
					config['videoAvailable'] = false;
				}
				else
				{
					config['videoAvailable'] = true;
				}

			}
			else if (!reference.root.loaderInfo.parameters['file'] && !reference.root.loaderInfo.parameters['hdpath'])
			{
				config['videoAvailable'] = true;
				plistDoc = new XMLDocument();
				plistDoc.ignoreWhite = true;
				plistDoc.parseXML(plistxml.toXMLString());
				config['playlist_autoplay'] = plistxml.. @ autoplay;
				config['plistrandom'] = plistxml.. @ random;
				config['plistlength'] = plistxml.children().length();
				for (var i = 0; i<config['plistlength']; i++)
				{
					video_url.push(plistxml.mainvideo[i].@video_url);
					config['video_url'] = video_url;
					video_hdpath.push(plistxml.mainvideo[i].@video_hdpath);
					config['video_hdpath'] = video_hdpath;
					video_id.push(plistxml.mainvideo[i].@video_id);
					config['video_id'] = video_id;

					thumb_image.push(plistxml.mainvideo[i].@thumb_image);
					if (thumb_image[i] == "" && video_url[i].indexOf('youtube') > -1 || video_url[i].indexOf('youtu.be') > -1)
					{
						thumb_image[i] = "http://i3.ytimg.com/vi/" + getyoutube_ID(video_url[i]) + "/mqdefault.jpg";
					}
					else if (thumb_image[i]=="" && video_url[i].indexOf('dailymotion') > -1)
					{
						thumb_image[i] = "http://www.dailymotion.com/thumbnail/video/" + getdailymotionId(video_url[i]);
					}
					else if (thumb_image[i]=="" && video_url[i].indexOf('viddler') > -1)
					{
						thumb_image[i] = "http://cdn-thumbs.viddler.com/thumbnail_2_" + get_viddler__ID(video_url[i]) + "_v1.jpg";
					}
					config['thumb_image'] = thumb_image;

					preview_image.push(plistxml.mainvideo[i].@preview_image);
					if (preview_image[i] == "" && video_url[i].indexOf('youtube') > -1 || video_url[i].indexOf('youtu.be') > -1)
					{
						preview_image[i] = "http://i3.ytimg.com/vi/" + getyoutube_ID(video_url[i]) + "/maxresdefault.jpg";
					}
					else if (preview_image[i]=="" && video_url[i].indexOf('dailymotion') > -1)
					{
						preview_image[i] = "http://www.dailymotion.com/thumbnail/video/" + getdailymotionId(video_url[i]);
					}
					else if (preview_image[i]=="" && video_url[i].indexOf('viddler') > -1)
					{
						preview_image[i] = "http://cdn-thumbs.viddler.com/thumbnail_2_" + get_viddler__ID(video_url[i]) + "_v2.jpg";
					}
					config['preview_image'] = preview_image;

					allow_preroll.push(plistxml.mainvideo[i].@allow_preroll);
					config['allow_preroll'] = allow_preroll;
					allow_midroll.push(plistxml.mainvideo[i].@allow_midroll);
					config['allow_midroll'] = allow_midroll;
					allow_postroll.push(plistxml.mainvideo[i].@allow_postroll);
					config['allow_postroll'] = allow_postroll;
					allow_ima.push(plistxml.mainvideo[i].@allow_ima);
					config['allow_ima'] = allow_ima;
					preroll_id.push(plistxml.mainvideo[i].@preroll_id);
					config['preroll_id'] = preroll_id;
					postroll_id.push(plistxml.mainvideo[i].@postroll_id);
					config['postroll_id'] = postroll_id;
					video_src.push(plistxml.mainvideo[i].@videosrc);
					config['video_src'] = video_src;
					allow_download.push(plistxml.mainvideo[i].@allow_download);
					config['allow_download'] = allow_download;
					streamer_path.push(plistxml.mainvideo[i].@streamer_path);
					config['streamer_path'] = streamer_path;
					video_category[i] = plistxml.mainvideo[i]. @ video_category;
					config['video_category'] = video_category;
					video_rating[i] = plistxml.mainvideo[i]. @ video_rating;
					config['video_rating'] = video_rating;
					video_isLive.push(plistxml.mainvideo[i].@video_isLive);
					config['video_isLive'] = video_isLive;
					video_views[i] = plistxml.mainvideo[i]. @ views;
					config['video_views'] = video_views;
					video_ratecount[i] = plistxml.mainvideo[i]. @ ratecount;
					config['video_ratecount'] = video_ratecount;
					date_vid[i] = plistxml.mainvideo[i]. @ date;
					config['date_vid'] = date_vid;
					tags_vid[i] = plistxml.mainvideo[i]. @ tags;
					config['tags_vid'] = tags_vid;
					video_targeturl[i] = plistxml.mainvideo[i].tagline. @ targeturl;
					config['video_targeturl'] = video_targeturl;
					member_arr[i] = plistxml.mainvideo[i]. @ member;
					config['member_arr'] = member_arr;
					duration_arr[i] = plistxml.mainvideo[i]. @ duration;
					config['duration_arr'] = duration_arr;
					disply_copylink[i] = plistxml.mainvideo[i]. @ copylink;
					config['disply_copylink'] = disply_copylink;
					video_title[i] = plistDoc.firstChild.childNodes[i].childNodes[0].childNodes[0].nodeValue;
					config['video_title'] = video_title;
					fbpath_arr[i] = plistxml.mainvideo[i]. @ fbpath;
					config['fbpath_arr'] = fbpath_arr;
					if (plistDoc.firstChild.childNodes[i].childNodes[1] != undefined)
					{
						for (var jk=0; jk<plistDoc.firstChild.childNodes[i].childNodes[1].childNodes.length; jk++)
						{
							caption_video[i] = plistDoc.firstChild.childNodes[i].childNodes[1].childNodes[jk].nodeValue;
						}
					}
					config['caption_video'] = caption_video;
				}
			}
			else
			{
				config['videoAvailable'] = true;
				config['plistlength'] = 0;
			}
			loadFlashvars();
		}
		//========================================== get  dailymotion ID==============================================================================
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
			st = st.substr(0,6);
			return st;
		}
		//========================================== get  youtube ID==============================================================================
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
		//========================================== get  viddler ID==============================================================================
		private function get_viddler__ID(url:String)
		{
			var viddlerArray:Array = url.split('/v/');
			url = viddlerArray[1];
			return url;
		}
	}
}