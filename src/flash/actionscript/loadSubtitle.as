package actionscript
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.display.*;
	import flash.external.*;
	import flash.text.*;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
        import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;

	public class loadSubtitle
	{
		private var loader:URLLoader;
		private var subloader:URLLoader;
		private var _subtitles:Array;
		private var subTitleParser:SubTitleParser
		protected var _curSub:SubTitleData;
		private var config:Object;
		private var txt:TextField;
		public function loadSubtitle(cfg:Object,pth)
		{
			config = cfg;
			while (config['SubMc'].numChildren > 0)
			{
				config['SubMc'].removeChildAt(0);
			}
			txt = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			config['SubMc'].addChild(txt);
			if (String(config['subTitleFontFamily']) != "" && config['subTitleFontFamily'] != undefined)config['subTitleFontFamily'] = config['subTitleFontFamily'];
			else config['subTitleFontFamily'] = "Arial";
			
			if (String(config['subTitleFontSize']) != "" && config['subTitleFontSize'] != undefined)config['subTitleFontSize'] = config['subTitleFontSize'];
			else config['subTitleFontSize'] = config['stageWidth'] / 40;
			
			txt.defaultTextFormat = new TextFormat(config['subTitleFont'],config['subTitleFontSize']);
			if (String(config['subTitleColor']) != "" && config['subTitleColor'] != undefined)txt.textColor = config['subTitleColor'];
			else txt.textColor = config['textColor'];
			if (String(config['subTitleBgColor']) != "" && config['subTitleBgColor'] != undefined)
			{
				txt.background=true;
			    txt.backgroundColor = config['subTitleBgColor'];
			}
			else txt.background=false;;
			txt.mouseEnabled = false
			config['SubMc'].mouseEnabled = false
			loadSub(pth)
			
		}
		private function loadSub(url)
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, doSubtitlesLoaded);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			if (url.indexOf('http') > -1)loader.load(new URLRequest(url));
			else loader.load(new URLRequest(config['baseurl']+"subtitle/"+config['vid_id']+"_"+url));
		}
		private function doSubtitlesLoaded(evt:Event):void
		{
			subloader = evt.currentTarget as URLLoader;
			var data:String = String(subloader.data);
			_subtitles = new Array()
			subTitleParser = new SubTitleParser()
			_subtitles = subTitleParser.parseSRT(data);
			
		}
		public function getSubtitleAt(seconds:Number):SubTitleData
		{
			if (_subtitles == null)
				return null;
				
			var sub:SubTitleData;
			
			for (var i:Number = 0; i < _subtitles.length; i++)
			{
				sub = _subtitles[i] as SubTitleData;
				if (sub.end < seconds)
					continue;
					
				else if (sub.start > seconds)
					return null;
					
				else if (sub.start < seconds && sub.end > seconds)
					return sub;
			}
			
			return null;
		}
		public function setSubTitle(sub:SubTitleData):void
		{
			if (_curSub != sub)
			{
				_curSub = sub;
				renderSubTitle();
			}	
		}
		protected function renderSubTitle():void
		{
			if (_curSub != null && _curSub != undefined )
			{
				txt.text = String(_curSub.text);
				config['SubMc'].x = (config['stageWidth']/2)-(txt.width/2);
			        config['SubMc'].y = (config['stageHeight']-25) - (config['SubMc'].height+8);
				show();
			}
			else
			{
                                txt.text = ""
				hide();
			}
		}
		
		protected function show():void
		{
			config['SubMc'].visible = true
		}
		
		protected function hide():void
		{
			config['SubMc'].visible = false
		}
	}
}