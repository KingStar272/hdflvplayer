package actionscript 
{
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
	
	import org.osmf.events.BufferEvent;
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.events.MediaFactoryEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.containers.MediaContainer;
	import org.osmf.elements.VideoElement;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.utils.URL;
	import org.osmf.media.PluginInfoResource;
	import actionscript.at.matthew.httpstreaming.HLSPluginInfo;
	import actionscript.at.matthew.httpstreaming.HTTPStreamingM3U8NetLoader;	
	import org.osmf.net.DynamicStreamingResource ;
	import org.osmf.net.DynamicStreamingItem ;
	
	public class HLSandHDS 
	{
		private var config:Object;
		private var reference:Sprite
		private var element:MediaElement;
		private var resource:URLResource;
		private var mediaPlayer:MediaPlayer;
		private var mediaContainer:MediaContainer;
		private var currentTime:Number = 0;
		private var HLS_Con:_hls;
		
		public function HLSandHDS(conFig,ref) 
		{
			config = conFig;
			reference = ref;
		}
		public function loadHDSHLS()
		{
			HLS_Con = new _hls()
			reference.addChild(HLS_Con);
			if(config['file'].indexOf('.m3u8') > -1)
			{
				var mediaFactory:MediaFactory = new MediaFactory();
				mediaFactory.loadPlugin(new PluginInfoResource(new HLSPluginInfo()));
				resource = new URLResource( config['file'] );
				element = mediaFactory.createMediaElement( resource );
			}
			else
			{
				var mediaFactory2:MediaFactory = new DefaultMediaFactory();
				resource = new URLResource( config['file'] );
				element = mediaFactory2.createMediaElement( resource );
			}
			mediaPlayer = new MediaPlayer( element );
			mediaContainer = new MediaContainer();
			mediaContainer.addMediaElement( element );
			config['myVideo'] = new MovieClip();
			reference.addChild(config['myVideo']);
			config['played'] = 'playing';
			config['myVideo'].buttonMode = true;
			config['myVideo'].addChild( mediaContainer );
			mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
			HLS_Con.width = mediaContainer.width = config['width'];
			HLS_Con.height = mediaContainer.height = config['height'];
			
		}
		private function onStateChange(event:MediaPlayerStateChangeEvent):void
		{
			switch (event.state) 
			{ 
				case "ready":
					 config['nDuration'] = mediaPlayer.duration;
					 config['played'] = 'playing';
					 mediaPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, onCurrentTimeChange);
					 HLS_Con.addEventListener(MouseEvent.CLICK,playpausecontainer)
				     HLS_Con.buttonMode =true;
					 break;
				case "buffering":
					 config['played'] = 'playing';
					 mediaPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, onCurrentTimeChange);
					break;
				case "playing":
				    config['played'] = 'playing';
					break;
				case "paused":
				    config['played'] = 'paused';
					break;	
			}
		}
		private function onCurrentTimeChange(event:TimeEvent)
		{
			config['currentTime'] = event.time
			config['nDuration'] = mediaPlayer.duration;
		}
		public function HDSandHLSseek(sec)
		{
			mediaPlayer.seek(sec)
		}
		public function pauseFun()
		{
			mediaPlayer.pause();
		}
		public function playFun()
		{
			mediaPlayer.play();
		}
		public function closeFun()
		{
			mediaPlayer.stop()
			mediaPlayer.removeEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
			mediaPlayer.removeEventListener(TimeEvent.CURRENT_TIME_CHANGE, onCurrentTimeChange);
			reference.removeChild(config['myVideo']);
		}
		public function changeVolume(v)
		{
			mediaPlayer.volume = v
		}
		private function setvidSize(wid,hei)
		{
			HLS_Con.width = mediaPlayer.width = wid;
			HLS_Con.height = mediaPlayer.height = hei;
		}
		private function playpausecontainer(eve:MouseEvent)
		{
			playpause();
		}
		public function playpause():void{
			if(config['played'] == "initial"){
				mediaPlayer.play();
				config['played'] = 'playing';
			}else if(config['played'] == "paused"){
				mediaPlayer.play();
				config['played'] = 'playing';
			}else{
				mediaPlayer.pause();
				config['played'] = 'paused';
			}
		}
	}
}