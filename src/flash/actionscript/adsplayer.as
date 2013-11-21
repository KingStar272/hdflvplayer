package actionscript 
{
  import com.google.ads.instream.api.Ad;
  import com.google.ads.instream.api.AdErrorEvent;
  import com.google.ads.instream.api.AdEvent;
  import com.google.ads.instream.api.AdLoadedEvent;
  import com.google.ads.instream.api.AdSizeChangedEvent;
  import com.google.ads.instream.api.AdTypes;
  import com.google.ads.instream.api.AdsLoadedEvent;
  import com.google.ads.instream.api.AdsLoader;
  import com.google.ads.instream.api.AdsManager;
  import com.google.ads.instream.api.AdsManagerTypes;
  import com.google.ads.instream.api.AdsRequest;
  import com.google.ads.instream.api.AdsRequestType;
  import com.google.ads.instream.api.CompanionAd;
  import com.google.ads.instream.api.CompanionAdEnvironments;
  import com.google.ads.instream.api.CustomContentAd;
  import com.google.ads.instream.api.FlashAd;
  import com.google.ads.instream.api.FlashAdCustomEvent;
  import com.google.ads.instream.api.FlashAdsManager;
  import com.google.ads.instream.api.HtmlCompanionAd;
  import com.google.ads.instream.api.VastVideoAd;
  import com.google.ads.instream.api.VastWrapper;
  import com.google.ads.instream.api.VideoAd;
  import com.google.ads.instream.api.VideoAdsManager;
	
	import flash.display.*;
	import flash.external.*;
	import flash.media.Video;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.display.DisplayObjectContainer;
	import flash.utils.*;
	import flash.ui.*;

  public class adsplayer extends MovieClip 
  {
    private var adsManager:AdsManager;
    private var adsLoader:AdsLoader;
	private var config:Object;
	private var reference:Sprite;
	private var video:Video;
	private var adsMc:adsmc;
	private var VidadsMc:IMAadsMc;
	private var visualContainer:DisplayObjectContainer;
	private var flashAdsManager:FlashAdsManager;
	private var useGUT:Boolean;
	private var playerUI:playerUi;
	private var playvideo:playVideo;
	private var otherindex:Number

    public function adsplayer(conFig,ref) 
	{
		 config = conFig;
		 reference = ref;
    }
    public function loadAd()
	{
		 var videoscale2 = new videoScale(config,reference)
		 //==================== create ads loader request and variables ======================================================
		 adsLoader= new AdsLoader(); 
		 reference.addChild(adsLoader); 
		 config['adsLoader'] = adsLoader
		 var adsRequestAFG:AdsRequest = new AdsRequest();
		 if(String(config['adSlotWidth']) == "" ){config['adSlotWidth'] = config['stageWidth']}
	     if(String(config['adSlotHeight']) == "" )config['adSlotHeight'] = config['stageHeight']
		 if(String(config['adTagUrl']) != "")adsRequestAFG.adTagUrl =String(config['adTagUrl']);
		 adsRequestAFG.adSlotWidth = config['adSlotWidth'];
		 adsRequestAFG.adSlotHeight = config['adSlotHeight'];
		 adsRequestAFG.adType = AdsRequestType.VIDEO
		 if(String(config['adTagUrl']) == "")
		 {
			adsRequestAFG.publisherId=String(config['publisherId']);
			if(String(config['contentId']) != "") adsRequestAFG.contentId=config['contentId'];
			adsRequestAFG.channels =[config['channels']]
			
			if(String(config['adTagUrl']) == "")
			{
			   if(String(config['adType']) == "Overlay")adsRequestAFG.adType = AdsRequestType.GRAPHICAL_OVERLAY;
			   else if(String(config['adType']) == "Text")adsRequestAFG.adType = AdsRequestType.TEXT;
			   if(String(config['adType']) == "Overlay" || String(config['adType']) == "Text")
			   {
				   adsRequestAFG.adSlotWidth = 468;
		           adsRequestAFG.adSlotHeight = 60;
			   }
			}
		 }
		 adsLoader.requestAds(adsRequestAFG)
		 adsLoader.addEventListener(AdsLoadedEvent.ADS_LOADED, onAdsLoaded); 
		 adsLoader.addEventListener(AdErrorEvent.AD_ERROR, onAdError);
    }
	private function onAdStarted(event:AdEvent):void 
	{
	  adsManager.removeEventListener(AdEvent.STARTED, onAdStarted);
      if(adsManager.type == AdsManagerTypes.VIDEO )
	  {
		  var videopause = new videoPause(config)
		  playerUI = new playerUi(config['ref'],config)
		  playerUI.addAdsSkip(config)
		  config['SkipIma'].addEventListener(MouseEvent.MOUSE_DOWN,closeAds)
		  config['SkipIma'].buttonMode = true;
		  config['shareClip'].alpha = 0.1
		  playvideo = new playVideo(config,reference);
	      playvideo.stageOut()
      }
    }
    private function onAdsLoaded(adsLoadedEvent:AdsLoadedEvent)
	{
		adsManager = adsLoadedEvent.adsManager;
		adsManager.addEventListener(AdEvent.STARTED, onAdStarted);
		//==================== FLASH ads    ======================================================
		if(adsManager.type == AdsManagerTypes.FLASH) 
		{
			flashAdsManager = adsManager as FlashAdsManager;
			flashAdsManager.load();
			flashAdsManager.play(visualContainer);
			config['adsManager'] = adsManager;
			flashAdsManager.y= 60
		    displayAdsInformation();
			setTimeout(displayAdsInformation,2000)
		}
		//==================== Video ads ======================================================
		else if(adsManager.type == AdsManagerTypes.VIDEO) 
		{
			VidadsMc = new IMAadsMc();
			reference.addChild(VidadsMc);
			config['VidadsMc'] = VidadsMc
			var videoAdsManager:VideoAdsManager = adsManager as VideoAdsManager;
			adsManager.addEventListener(AdEvent.COMPLETE, onVideoAdComplete);
			adsMc = new adsmc();
			reference.addChild(adsMc);
			videoAdsManager.clickTrackingElement = adsMc;
			video = new Video();
			reference.addChild(video);
			videoAdsManager.load(video);
            videoAdsManager.play(video);
			adsMc.width = video.width = config['adSlotWidth'];
			adsMc.height = video.height = config['adSlotHeight'];
			adsMc.x = video.x = (config['stageWidth']/2)-(video.width/2);
			adsMc.y = video.y = (config['stageHeight']/2)-(video.height/2);
			config['adsManager'] = adsManager;
			config['videoMc'] = video;
		    displayAdsInformation();
		}
		//==================== CUSTOM_CONTENT ads ======================================================
		else if (adsManager.type == AdsManagerTypes.CUSTOM_CONTENT) 
		{
			/*if(String(config['adTagUrl']) != "" && String(config['publisherId']) != "" )
			{
				config['adTagUrl'] = ""
				loadAd()
			}
			else
			{
				if(imMC)reference.removeChild(imMC);
				var videoplay = new videoPlay(config)
			}*/
        }
    }
	private function closeAds(eve:MouseEvent)
	{
		config['SkipIma'].alpha = 0
		if (config['adsManager'].type == AdsManagerTypes.VIDEO) 
		{
			(config['adsManager'] as VideoAdsManager).clickTrackingElement = null;
			reference.removeChild(video);
			reference.removeChild(adsMc);
			var videoplay = new videoPlay(config)
			unloadAd()
		}
		config['imA'] = false
		config['SkipIma'].visible = false;
		playerUI.removeSkipAds(config)
	}
	private function onAdError(adErrorEvent:AdErrorEvent):void 
	{
		if(config['adsLoader'])reference.addChild(config['adsLoader']);
		config['imA'] = false
		unloadAd()
    }
	private function onVideoAdComplete(event:AdEvent):void 
	{
      if (config['adsManager'].type == AdsManagerTypes.VIDEO) 
	  {
         (config['adsManager'] as VideoAdsManager).clickTrackingElement = null;
		 reference.removeChild(video);
	     reference.removeChild(adsMc);
		 var videoplay = new videoPlay(config)
		 unloadAd()
      }
	  config['imA'] = false
	  config['SkipIma'].visible = false;
    }
     public function unloadAd()
	 {
		config['shareClip'].alpha = 1
		config['AdsManagerTypes'] = "";
		if(VidadsMc)reference.removeChild(VidadsMc)
		if(config['adsLoader'] != undefined)
		{
			 config['adsLoader'].removeEventListener(AdsLoadedEvent.ADS_LOADED, onAdsLoaded);
		     config['adsLoader'].removeEventListener(AdErrorEvent.AD_ERROR, onAdError); 
			 reference.removeChild(config['adsLoader']);
		}
        if(config['adsManager']) 
		{
		  config['adsManager'].removeEventListener(AdEvent.COMPLETE, onVideoAdComplete);
		  config['adsManager'].removeEventListener(AdEvent.STARTED, onAdStarted);
          config['adsManager'].unload();
          config['adsManager'] = null;
        }
		config['imA'] = false;
		 if(config['SkipIma'] != undefined)
		 {
			config['SkipIma'].visible = false;
			if(config['SkipIma'])
			{
				playerUI.removeSkipAds(config)
			}
		 }
		config['adsLoader'] = undefined;
    }
	public function displayAdsInformation()
	{
		//==================== get ads information and set position and size of the ads======================================================
		config['imA'] = true;
		var ads:Array = config['adsManager'].ads;
		if (ads) 
		{
			for each (var ad:Ad in ads) 
			{
				if (ad.type == AdTypes.FLASH) 
				{
					config['AdsManagerTypes'] = "flash"
					var flashAd:FlashAd = ad as FlashAd;
					if (flashAd.asset != null) 
					{
						flashAd.asset.y = (config['stageHeight'] - flashAd.asset.height)-35;
						flashAd.asset.x = (config['stageWidth']/2)-(flashAd.asset.width/2);
					} 
				}
				else if (ad.type == AdTypes.VIDEO)
				{
				  adsMc.x = config['videoMc'].x = (config['stageWidth']/2)-(config['videoMc'].width/2)
			      adsMc.y = config['videoMc'].y = (config['stageHeight']/2)-(config['videoMc'].height/2)
				  config['VidadsMc'].width = config['stageWidth']
				  config['VidadsMc'].height = config['stageHeight']
				  otherindex = reference.getChildIndex(config['logocon']);
			      reference.setChildIndex(config['videoMc'], otherindex-1);
				} 
				else if (ad.type == AdTypes.VAST) 
				{
				  var vastAd:VastVideoAd = ad as VastVideoAd;
				  adsMc.x = config['videoMc'].x = (config['stageWidth']/2)-(config['videoMc'].width/2)
			      adsMc.y = config['videoMc'].y = (config['stageHeight']/2)-(config['videoMc'].height/2)
				  config['VidadsMc'].width = config['stageWidth']
				  config['VidadsMc'].height = config['stageHeight']
				  otherindex = reference.getChildIndex(config['logocon']);
			      reference.setChildIndex(config['videoMc'], otherindex-1);
				} 
			} 
		}
    }
  }
}
