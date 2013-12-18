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
		private var playvideo:playVideo;
		private var currentTime:Number = 0;
		
		public function HLSandHDS(conFig,ref) 
		{
			config = conFig;
			reference = ref;
		}
		public function loadHDSHLS()
		{
			playvideo= new playVideo(config,reference);
			config['buffer_Mc'].visible = true;
			config['buffer_Mc'].alpha=1
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
			config['myVideo'].buttonMode = true;
			config['myVideo'].addChild( mediaContainer );
			mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onStateChange);
			var otherindex = reference.getChildIndex(config['backBg']);
			reference.setChildIndex(config['myVideo'], otherindex+1);
			config['org_width'] = config['stageWidth'];
			config['org_height'] = config['stageHeight'];
			config['vidscale'] = config['stageWidth'] / config['stageHeight'];
			config['shareClip'] = mediaContainer;
		}
		private function onStateChange(event:MediaPlayerStateChangeEvent):void
		{
			config['skinMc'].pro.buffer_end.visible = config['skinMc'].pro.seek_end.visible = config['skinMc'].pro.seekS.visible = config['skinMc'].pro.bufferS.visible = true;
			switch (event.state) 
			{ 
				case "ready":
					 config['nDuration'] = mediaPlayer.duration;
					 config['vidscale'] = config['myVideo'].width / config['myVideo'].height;
					 mediaPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, onCurrentTimeChange);
					 config['video'] = "stream";
					 config['stremPlayed'] = false;
					 break;
				case "buffering":
				     config['stremPlayed'] = false
					 config['nDuration'] = mediaPlayer.duration;
					 config['vidscale'] = config['myVideo'].width / config['myVideo'].height;
					 mediaPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, onCurrentTimeChange);
					 config['buffer_Mc'].visible = true;
					 config['buffer_Mc'].alpha=1
					 var videoscale = new videoScale(config,reference);
				     videoscale.videoResize();
					 config['video'] = "stream";
					break;
				case "playing":
				     playvideo.calledfun();
				     config['stremPlayed'] = false;
					 config['buffer_Mc'].visible = false;
					 /*if(curtim != 0 )
					 {
						 mediaPlayer.seek(curtim)
						 curtim = 0
						 config['buffer_Mc'].visible = true;
						 config['buffer_Mc'].alpha=1
					 }*/
					//if(errorPopup){removeChild(errorPopup);errorPopup=null;}
					var videoscale = new videoScale(config,reference);
				    videoscale.videoResize();
					break;
				case "paused":
					config['buffer_Mc'].visible = false;
					//if(errorPopup){removeChild(errorPopup);errorPopup=null;}
					break;	
			}
		}
		private function onCurrentTimeChange(event:TimeEvent)
		{
			config['currentime']= event.time
		}
		public function getcurrentTime()
		{
			return config['currentime'];
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
			config['video'] = ""
		}
		public function changeVolume(v)
		{
			mediaPlayer.volume = v
		}
	}
}