package actionscript 
{
	import com.google.ads.ima.api.Ad;
	import com.google.ads.ima.api.AdErrorEvent;
	import com.google.ads.ima.api.AdEvent;
	import com.google.ads.ima.api.AdsLoader;
	import com.google.ads.ima.api.AdsManager;
	import com.google.ads.ima.api.AdsManagerLoadedEvent;
	import com.google.ads.ima.api.AdsRenderingSettings;
	import com.google.ads.ima.api.AdsRequest;
	import com.google.ads.ima.api.CompanionAdEnvironments;
	import com.google.ads.ima.api.FlashCompanionAd;
	import com.google.ads.ima.api.UiElements;
	import com.google.ads.ima.api.ViewModes;
	
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
	//private var flashAdsManager:FlashAdsManager;
	private var useGUT:Boolean;
	private var playerUI:playerUi;
	private var playvideo:playVideo;
	private var otherindex:Number;
	private var contentPlayheadTime:Number=0; 

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
		 adsLoader.loadSdk();
		 config['adsLoader'] = adsLoader
		 requestAds()
		 
    }
	function requestAds()
	{
		var adsRequest:AdsRequest = new AdsRequest();
		adsRequest.adTagUrl = String(config['adTagUrl']);
		adsRequest.linearAdSlotWidth = config['stageWidth'];
		adsRequest.linearAdSlotHeight = config['stageHeight']-30;
		adsRequest.nonLinearAdSlotWidth = config['stageWidth'];
		adsRequest.nonLinearAdSlotHeight = config['stageHeight']-30;
		adsLoader.requestAds(adsRequest);
		adsLoader.addEventListener(AdsManagerLoadedEvent.ADS_MANAGER_LOADED,adsManagerLoadedHandler);
	}
   function adsManagerLoadedHandler(event:AdsManagerLoadedEvent):void 
	{
		var adsRenderingSettings:AdsRenderingSettings =
		new AdsRenderingSettings();
		// In order to support ad rules playlists, ads manager requires an object that
		// provides current playhead position for the content.
		var contentPlayhead:Object = {};
		contentPlayhead.time = function():Number 
		{
		return contentPlayheadTime * 1000; // convert to milliseconds.
		};
		// Get a reference to the AdsManager object through the event object.
		adsManager = event.getAdsManager(contentPlayhead, adsRenderingSettings);
		config['adsManager'] = adsManager
		if (adsManager) 
		{
			 adsManager.addEventListener(AdEvent.LOADED,adLoadedHandler);
			// Add required ads manager listeners.
			// ALL_ADS_COMPLETED event will fire once all the ads have played. There
			// might be more than one ad played in the case of ad pods and ad rules.
			adsManager.addEventListener(AdEvent.ALL_ADS_COMPLETED,onVideoAdComplete);
			// If ad is linear, it will fire content pause request event.
			adsManager.addEventListener(AdEvent.CONTENT_PAUSE_REQUESTED,contentPauseRequestedHandler);
			// When ad finishes or if ad is non-linear, content resume event will be
			// fired. For example, if ad rules response only has post-roll, content
			// resume will be fired for pre-roll ad (which is not present) to signal
			// that content should be started or resumed.
			adsManager.addEventListener(AdEvent.CONTENT_RESUME_REQUESTED,contentResumeRequestedHandler);
			// All AD_ERRORs indicate fatal failures. You can discard the AdsManager and
			// resume your content in this handler.
			adsManager.addEventListener(AdErrorEvent.AD_ERROR,onAdError);
			// If your video player supports a specific version of VPAID ads, pass
			// in the version. If your video player does not support VPAID ads yet,
			// just pass in 1.0.
			adsManager.handshakeVersion("1.0");
			// Init should be called before playing the content in order for ad rules
			// ads to function correctly.
			adsManager.init(config['stageWidth'],config['stageHeight']-30,'normal');
		
			// Add the adsContainer to the display list. Below is an example of how
			// to do it with our Flex player.
			//video = new Video();
			reference.addChild(adsManager.adsContainer);
			//this.addElement(video);
			// Start the ad playback.
			adsManager.start();
		}
	}
	function onVideoAdComplete(event:AdEvent):void 
	{
		destroyAdsManager();
	}
	function onAdError(adErrorEvent:AdErrorEvent):void 
	{
		destroyAdsManager();
	}
	function adsLoadErrorHandler(event:AdErrorEvent):void 
	{
		destroyAdsManager();
	}
	function adLoadedHandler(event:AdEvent):void
	{
		var myad:Ad=event.ad as Ad;
		var x:Number=(config['stageWidth']-myad.width)/2,
		y:Number=(stage.stageHeight+myad.height)/2-5;
	}
	function contentPauseRequestedHandler(event:AdEvent):void 
	{
		 config['IM_a'] = true;
		 config['skinMc'].y = config['stageHeight']-(config['skinMc'].skin_bg.height);
		 var videopause = new videoPause(config)
	}
	function contentResumeRequestedHandler(event:AdEvent):void 
	{
		 config['IM_a'] = false
		 var videoplay = new videoPlay(config)
	}
	public function unloadAd()
	{
		destroyAdsManager();
	}
	private function destroyAdsManager()
	{
	  config['IM_a'] = false
      if (config['adsManager']) 
	  {
        reference.removeChild(config['adsManager'].adsContainer)
        config['adsManager'].destroy();
		config['adsManager'] = null
      }
    }
	public function displayAdsInformation()
	{
		config['adsManager'].resize(config['stageWidth'],config['stageHeight']-30,'normal');
	}
  }
}
