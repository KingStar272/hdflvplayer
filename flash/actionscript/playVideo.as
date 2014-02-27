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
		
		public function playVideo(obj,re){
			config = obj;
			ref = re;
			playStreamVideo();
		}
		private function playStreamVideo(){
			config['myVideo'] = new MovieClip();
			config['ref'].addChild(config['myVideo']);
			nc = new NetConnection();
			nc.objectEncoding = flash.net.ObjectEncoding.AMF0;
			nc.connect(null);
			config['stream']  = new NetStream(nc);
			objClient= new Object();
			config['stream'].client = objClient;
			objClient.onMetaData = flvOnMetaData;
			myVideo = new Video(config['stageWidth'],config['stageHeight']);
			config['myVideo'].addChild(myVideo);
			myVideo.attachNetStream(config['stream']);
			myVideo.smoothing = true;
			myVideo.deblocking = 1;
			config['bytesLoaded'] = config['currentTime'] = config['bytesTotal'] = 0
			setDim(config['width'],config['height']);
			config['myVideo'].buttonMode = true
			config['stream'].addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			config['myVideo'].addEventListener(MouseEvent.CLICK,playpausecontainer)
		}
		private function playpausecontainer(eve:MouseEvent)
		{
			playpause();
		}
		private function flvOnMetaData(obj:Object):void{
			config['nDuration'] = obj.duration;
			config['currentTime'] = 0;
			myVideo.addEventListener(Event.ENTER_FRAME, updateStremDisplay);
		}
		public function playpause():void{
			if(config['played'] == "initial"){
				config['stream'].play(config['file']);
				config['played'] = "true";
			}else if(config['played'] == "false"){
				config['stream'].resume();
				config['played'] = "true"
			}else{
				config['stream'].pause();
				config['played'] = "false"
			}
		}
		private function updateStremDisplay(eve:Event){
			config['currentTime'] = config['stream'].time;
			config['bytesLoaded'] = config['stream'].bytesLoaded;
			config['bytesTotal'] = config['stream'].bytesTotal;
		}
		public function setDim(wid,hei):void{
			myVideo.width = wid;
			myVideo.height = hei;
			myVideo.x=myVideo.y =0
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
					break;
				case "NetStream.Play.Stop" :
				    config['played'] = 'initial';
					break;
				case "NetStream.Play.StreamNotFound" :
					break;
				case "NetStream.Play.FileStructureInvalid" :
					break;
				case "NetStream.Play.NoSupportedTrackFound" :
					break;
			}
		}
	}
}