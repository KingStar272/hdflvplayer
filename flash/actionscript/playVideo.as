package actionscript{
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

	public class playVideo{
		private var config:Object;
		private var nc:NetConnection;
		private var objClient:Object;
		private var myVideo:Video;
		private var nDuration:Number;
		private var ref:Sprite;
		private var YoutubeLoader:Loader;
		private var keyframes:Object;
		private var lighttPd:lighttpd;
		
		public function playVideo(obj,re){
			config = obj;
			ref = re;
			if(config['file'].indexOf('.f4m') > -1 || config['file'].indexOf('.m3u8') > -1 )
			{
				config['HLSandHDSstream'] = new HLSandHDS(config,ref);
				config['HLSandHDSstream'].loadHDSHLS()
			}
			else if (config['file'].indexOf('youtube.com') > -1 || config['file'].indexOf('youtu.be') > -1)
			{
				config['video'] = 'youtube';
				playYoutubeVideo();
			}	
			else playStreamVideo();
		}
		private function playStreamVideo(){
			config['meta'] = false;
			config['off'] = config['timeOffset'] = config['pixelOffset'] = 0;
			config['myVideo'] = new MovieClip();
			config['ref'].addChild(config['myVideo']);
			nc = new NetConnection();
			nc.objectEncoding = flash.net.ObjectEncoding.AMF0;
			nc.connect(null);
			if (config['streamer'] != undefined)
			{
				if(config['streamer'].indexOf("rtmp") > -1)
				{
					config['streamer'] = unescape(config['streamer']);
					config['file'] = getrtmpID(config['file']);
					nc.connect(config['streamer']);
					nc.call("FCSubscribe",null,config['file']);
					nc.addEventListener(NetStatusEvent.NET_STATUS,connectStatusHandler);
				}
				else if (config['streamer'].indexOf("pseudostreaming") > -1)
				{
					config['lighttPd'] = new lighttpd(config);
					config['file'] = config['lighttPd'].getlighttpdUrl();
					connect();
				}
			}else{
				connect();
			}
		}
		private function connect()
		{
			config['stream']  = new NetStream(nc);
			objClient= new Object();
			config['stream'].client = objClient;
			objClient.onMetaData = flvOnMetaData;
			myVideo = new Video(config['stageWidth'],config['stageHeight']);
			config['myVideo'].addChild(myVideo);
			myVideo.attachNetStream(config['stream']);
			myVideo.smoothing = true;
			myVideo.deblocking = 1;
			config['bytesLoaded'] = config['currentTime'] = config['bytesTotal'] = 0;
			setDim(config['width'],config['height']);
			config['myVideo'].buttonMode = true
			config['stream'].addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			config['myVideo'].addEventListener(MouseEvent.CLICK,playpausecontainer)
			if(config['autoplay'] == 'true')playpause()
		}
		private function connectStatusHandler(event:NetStatusEvent)
		{
			if (event.info.code == 'NetConnection.Connect.Success')
			{
				connect();
				nc.removeEventListener(NetStatusEvent.NET_STATUS, connectStatusHandler);
			}
			else if (event.info.code =='NetConnection.Connect.Failed')
			{
				//MessageClass.show(config['streaming_connection_failed']);
			}
		}
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
		private function playpausecontainer(eve:MouseEvent)
		{
			playpause();
		}
		private function flvOnMetaData(obj:Object):void{
			config['nDuration'] = obj.duration;
			config['currentTime'] = 0;
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
			myVideo.addEventListener(Event.ENTER_FRAME, updateStremDisplay);
		}
		public function playpause():void{
			if(config['played'] == "initial"){
				if(config['video'] == 'youtube')
				{
					config['autoplay'] = 'true';
					config['YTPlayer'].playVideo()
				}
				else config['stream'].play(config['file']);
				config['played'] = 'playing';
			}else if(config['played'] == "paused"){
				if(config['video'] == 'youtube')config['YTPlayer'].playVideo()
				else config['stream'].resume();
				config['played'] = 'playing';
			}else{
				if(config['video'] == 'youtube')config['YTPlayer'].pauseVideo()
				else config['stream'].pause();
				config['played'] = 'paused';
			}
		}
		private function updateStremDisplay(eve:Event){
			config['currentTime'] = config['stream'].time;
			config['bytesLoaded'] = config['stream'].bytesLoaded;
			config['bytesTotal'] = config['stream'].bytesTotal;
		}
		public function setDim(wid,hei):void{
			if(config['file'].indexOf('.f4m') > -1 || config['file'].indexOf('.m3u8') > -1 ){
				config['HLSandHDSstream'].setvidSize(wid,hei)
			}else if (config['file'].indexOf('youtube.com') > -1 || config['file'].indexOf('youtu.be') > -1){
				config['YTPlayer'].setSize(wid,hei)
			}else{
				myVideo.width = wid;
				myVideo.height = hei;
				myVideo.x=myVideo.y =0
			}
		}
		private function netStatusHandler(event:NetStatusEvent)
		{
			switch (event.info.code){
				case "NetStream.Seek.Notify" :
					break;
				case "NetStream.Buffer.Empty" :
					break;
				case "NetStream.Buffer.Full" :
					break;
				case "NetStream.Buffer.Start" :
				     config['played'] = 'playing';
					break;
				case "NetStream.Play.Stop" :
				    config['played'] = 'ended';
					break;
				case "NetStream.Play.StreamNotFound" :
				     config['played'] = 'The requested video is not found or access denied.'
					break;
				case "NetStream.Play.FileStructureInvalid" :
				   	config['played'] = 'Flash Player detects an invalid file structure and will not try to play this type of file. Supported by Flash Player 9 Update 3 and later.'
					break;
				case "NetStream.Play.NoSupportedTrackFound" :
				 	config['played'] = 'Flash Player does not detect any supported tracks (video, audio or data) and will not try to play the file. Supported by Flash Player 9 Update 3 and later.'
					break;
			}
		}
		private function playYoutubeVideo()
		{
			YoutubeLoader = new Loader();
			config['played'] = 'unstarted';
			if (config['file'].indexOf('youtube.com') > -1 || config['file'].indexOf('youtu.be') > -1)
			{
				YoutubeLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, youtube_onLoaderInit);
				YoutubeLoader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3&autoplay=1"));
				
			}
		}
		private function youtube_onLoaderInit(e:Event)
		{
			config['ref'].addChild(YoutubeLoader);
			YoutubeLoader.content.addEventListener("onReady", onYoutubePlayerReady);
		}
		private function onYoutubePlayerReady(e:Event):void
		{
			config['YTPlayer'] = new Object()
			config['YTPlayer'] = YoutubeLoader.content;
			loadVideoByIdFun();
		}
		private function loadVideoByIdFun()
		{
			if (config['file'].indexOf('youtube.com') > -1 || config['file'].indexOf('youtu.be') > -1)
			{
				config['YTPlayer'].loadVideoById(getyoutube_ID(config['file']), 0, "default");
				if(config['autoplay'] == 'false')config['YTPlayer'].pauseVideo()
				config['YTPlayer'].setSize(config['width'],config['height'])
				config['YTPlayer'].addEventListener(Event.ENTER_FRAME,updateDisplay)
				config['YTPlayer'].addEventListener(MouseEvent.CLICK,playpausecontainer)
				config['YTPlayer'].buttonMode =true;
			}
		}
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
		function updateDisplay(eve:Event)
		{
			if(config['YTPlayer'].getPlayerState() == -1){
				config['played'] = 'unstarted';
			}else if(config['YTPlayer'].getPlayerState() == 0){
				config['played'] = 'ended';
			}else if(config['YTPlayer'].getPlayerState() == 1){
				config['played'] = 'playing';
			}else if(config['YTPlayer'].getPlayerState() == 2){
				config['played'] = 'paused';
			}else if(config['YTPlayer'].getPlayerState() == 3){
				config['played'] = 'buffering';
			}else if(config['YTPlayer'].getPlayerState() == 5){
				config['played'] = 'video cued';
			}
			config['currentTime'] = config['YTPlayer'].getCurrentTime();
			config['getVideoLoadedFraction'] = config['YTPlayer'].getVideoLoadedFraction()
			config['bytesLoaded'] = config['YTPlayer'].getVideoBytesLoaded();
			config['bytesTotal'] = config['YTPlayer'].getVideoBytesTotal();
			config['nDuration']  = config['YTPlayer'].getDuration();
		}
	}
}