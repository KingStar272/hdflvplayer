package actionscript
{
	import flash.display.*;
	import flash.text.*;
	import flash.geom.ColorTransform;
	import flash.external.*;
	public class Message
	{
		private var config:Object;
		private var reference:Sprite;

		public function Message(cfg,ref)
		{
			config = cfg;
			reference = ref;
		}
		//================================ set position for alert message box =================================================
		public function setPos(wid, hei):void
		{
			config['errorMc'].width = 250;
			config['errorMc'].height = 50;
			config['errorMc'].x = (wid / 2) - (config['errorMc'].width / 2);
			config['errorMc'].y = (hei / 2) - (config['errorMc'].height / 2);
		}
		//================================ set alert message box text value ===================================================
		public function show(msg)
		{
			config['errorMc'].buyButton.visible= false
			config['buffer_Mc'].visible = false;
			config['errorMc'].visible = true;
			config['errorMc'].errortxt.autoSize = TextFieldAutoSize.LEFT;
			config['errorMc'].errortxt.text = msg;
			config['errorMc'].x = config['stageWidth'] / 2;
			config['errorMc'].y = config['stageHeight'] / 2;
			if (config['relatedview'] != true)
			{
				reference.setChildIndex(config['errorMc'],reference.numChildren-1);
			}
			else
			{
				reference.setChildIndex(config['errorMc'],reference.numChildren-1);
				reference.setChildIndex(config['relaMc'],reference.numChildren-1);
			}
			config['errorMc'].bg.height = config['errorMc'].errortxt.height + 14;
			if (String(config['sharepanel_up_BgColor']) != "" && config['sharepanel_up_BgColor'] != undefined)
			{
				changeColor(config['errorMc'].bg2,config['sharepanel_up_BgColor']);
			}
			if (String(config['sharepanel_down_BgColor']) != "" && config['sharepanel_down_BgColor'] != undefined)
			{
				changeColor(config['errorMc'].bg,config['sharepanel_down_BgColor']);
			}
			if (String(config['sharepaneltextColor']) != "" && config['sharepaneltextColor'] != undefined)
			{
				config['errorMc'].errortxt.textColor = config['sharepaneltextColor'];
			}
			if (config['skinMc'].name != undefined)
			{
				var videoscale = new videoScale(config,reference);
				videoscale.buttonInVis();
			}
		}
		//================================  hide alert message box ============================================================
		public function hide()
		{
			config['errorMc'].visible = false;
		}
		function changeColor(object:MovieClip, color:Number)
		{
			var colorchange:ColorTransform = new ColorTransform();
			colorchange.color = color;
			object.transform.colorTransform = colorchange;
		}


	}
}