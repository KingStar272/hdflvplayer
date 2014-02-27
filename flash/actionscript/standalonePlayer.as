package actionscript{
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
	import flash.media.SoundTransform;
	import flash.system.System;
	import flash.system.Security;
	import flash.net.*;
	import flash.display.MovieClip;
	import flash.events.FullScreenEvent;
    import flash.geom.*;
	import flash.geom.ColorTransform;
		
	public class standalonePlayer extends MovieClip{
		private var PlayVideo:playVideo;
		public var hdflv_option:Object ={
			played:String
		}
		public function standalonePlayer(){
			hdflv_option['nDuration'] = 0;
			hdflv_option['currentTime'] = 0;
			hdflv_option['played'] = 'false';
			ExternalInterface.addCallback('playfun',playvideo)
			ExternalInterface.addCallback('getDuration',getDuration)
			ExternalInterface.addCallback('getCurrentTime',getCurrentTime)
			ExternalInterface.addCallback('getbytesLoaded',getbytesLoaded)
			ExternalInterface.addCallback('getbytesTotal',getbytesTotal)
			ExternalInterface.addCallback('seekVideo',seekVideo)
			ExternalInterface.addCallback('setVolume',setVolume)
			ExternalInterface.addCallback('getplayerstate',getplayerstate)
			
			hdflv_option['played'] = 'initial';
			hdflv_option['file'] = this.root.loaderInfo.parameters['file']
			hdflv_option['ref'] = this;
			hdflv_option['width'] = stage.stageWidth;
			hdflv_option['height'] = stage.stageHeight;
			hdflv_option['ref'] = this;
			PlayVideo = new playVideo(hdflv_option,this)
			stage.addEventListener(Event.RESIZE, resizeFun);
			this.buttonMode= true
		}
		public function playvideo(){
			PlayVideo.playpause();
		}
		private function getDuration(){
			return hdflv_option['nDuration'];
		}
		private function getCurrentTime(){
			return hdflv_option['currentTime'];
		}
		private function getbytesLoaded(){
			return hdflv_option['bytesLoaded'];
		}
		private function getbytesTotal(){
			return hdflv_option['bytesTotal'];
		}
		private function seekVideo(sec){
			hdflv_option['stream'].seek(sec);
		}
		private function setVolume(Volume){
			var sndTransform= new SoundTransform(Volume);
			hdflv_option['stream'].soundTransform= sndTransform;
		}
		private function resizeFun(evt:Event=null):void{
			PlayVideo.setDim(stage.stageWidth,stage.stageHeight);
		}
		private function getplayerstate(){
			return hdflv_option['played'];
		}
	}
}