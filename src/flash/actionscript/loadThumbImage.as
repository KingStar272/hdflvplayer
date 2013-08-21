package actionscript
{
	import flash.display.*;
	import flash.text.*;
	import flash.media.*;
	import flash.external.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.NetStream;
	import flash.display.Bitmap;
	import flash.system.System;
	import flash.system.Security;

	public class loadThumbImage
	{
		private var galMc:MovieClip;
		private var config:Object;
		private var imgLoader:Loader;
		private var imagePath:URLRequest;
		private var numn:Number;
		private var imagepath:String;
		// ================ load thumb images from palylist xml values =========================================
		public function loadThumbImage(gal,con,num)
		{
			config = con;
			galMc = gal;
			numn = num;
			loadImage();
		}
		private function loadImage()
		{
			imgLoader  = new Loader();
			imagepath = String(config['thumb_image'][numn]);
			if (imagepath.indexOf('http') > -1)
			{
				imagepath = imagepath;
			}
			else
			{
				imagepath = config['baseurl'] + "" + imagepath;
			}
			Security.allowDomain(imagepath);
			imagePath = new URLRequest(imagepath);
			imgLoader.load(imagePath);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,imgLoaded);
			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageError);
			galMc.img.addChild(imgLoader);
		}
		function imgLoaded(evt:Event)
		{
			var premc = (evt.target.loader.parent.parent.thu_buf);
			premc.visible = false;
			evt.target.loader.width = 115.5;
			evt.target.loader.height = 65.5;
			Bitmap(evt.target.loader.content).smoothing = true;
		}
		private function imageError(evt:IOErrorEvent)
		{
			if (config['thumb_image'][numn].indexOf("maxresdefault.jpg") > -1)
			{
				config['thumb_image'][numn] = String(config['thumb_image'][numn]).replace('maxresdefault.jpg','hqdefault.jpg');
				loadImage();
			}
			else if (config['thumb_image'][numn].indexOf("hqdefault.jpg") > -1)
			{
				config['thumb_image'][numn] = String(config['thumb_image'][numn]).replace('hqdefault.jpg','mqdefault.jpg');
				loadImage();
			}
			else if (config['imageDefault'] == true && config['thumb_image'][numn].indexOf("default_thumb.jpg") <= -1)
			{
				config['thumb_image'][numn] = config['baseurl'] + "images/default_thumb.jpg";
				loadImage();
			}
			else
			{
				var premc = (evt.target.loader.parent.parent.thu_buf);
				premc.visible = false;
			}
		}
	}
}