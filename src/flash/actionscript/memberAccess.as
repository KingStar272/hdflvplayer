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

	public class memberAccess
	{
		public static var reference:Sprite;
		private var config:Object;
		private var MessageClass:Message;

		public function memberAccess(ref:Sprite,cfg:Object)
		{
			config = cfg;
			reference = ref;
			MessageClass = new Message(config,reference);
			config['errorMc'].buyButton.visible= false
			if(config['uid'] == 0) 
			{
				if(config['not_permission'] == undefined || config['not_permission'] == ""){config['not_permission'] = "Sorry! You don't have permission to view this video. Please Login to watch this video."}
				MessageClass.show(config['not_permission'])
				if(config['login'] == undefined || config['login'] == ""){config['login'] = "login"}
				config['errorMc'].buyButton.txt.text = String(config['login'])
				config['errorMc'].buyButton.y = config['errorMc'].bg.y+config['errorMc'].bg.height+3
			    config['errorMc'].bg.height = config['errorMc'].errortxt.height+40
				config['errorMc'].buyButton.visible=true
				config['errorMc'].buyButton.buttonMode = true
				config['errorMc'].buyButton.txt.mouseEnabled = false
				config['errorMc'].buyButton.addEventListener(MouseEvent.CLICK,gotoShopPage)
			}
			else 
			{
				if(config['not_authorized'] == undefined || config['not_authorized'] == ""){config['not_authorized'] = "Sorry! You are not authorized to view this video."}
				MessageClass.show(config['not_authorized'])
			}
		}
		private function gotoShopPage(eve:MouseEvent)
		{
			if(config['registerpage'])
			{
				navigateToURL(new URLRequest(String(config['registerpage'])) , "_self");
			}
		}
	}
}