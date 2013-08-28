package actionscript
{
	import flash.display.Sprite;
	import flash.display.*;
	import flash.external.*;
	import flash.events.*;
	import fl.transitions.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.utils.setTimeout;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.display.*;
	import flash.text.*;
	public class email
	{
		private var config:Object;
		private var variables:URLVariables;
		private var requ:URLRequest;
		private var reference:Sprite;
		private var urlLoader:URLLoader;

		public function email(cfg,ref)
		{
			config = cfg;
			reference = ref;
		}
		public function emailFun()
		{
			config['tooltipMc'].visible = false;
			config['mailPanel'].alpha = 1;
			config['mailPanel'].closeBut.addEventListener(MouseEvent.MOUSE_DOWN,mailcloseFun);
			config['mailPanel'].closeBut.buttonMode = true;
			var urlgets = new Loadembedtext(reference,config);
			urlgets.pageurlget();
			urlgets.embedcall();
			config['mailPanel'].scaleX = config['stageHeight'] / 310;
			config['mailPanel'].scaleY = config['stageHeight'] / 310;
			config['mailPanel'].form.Sendanemail.autoSize = TextFieldAutoSize.LEFT;
			config['mailPanel'].form.Sendanemail.text = String(config['sendanemail']);
			config['mailPanel'].form.Totxt.autoSize = TextFieldAutoSize.RIGHT;
			config['mailPanel'].form.Totxt.text = String(config['to'] + "" + " :");
			config['mailPanel'].form.Fromtxt.autoSize = TextFieldAutoSize.RIGHT;
			config['mailPanel'].form.Fromtxt.text = String(config['from'] + "" + " :");
			config['mailPanel'].form.Notetxt.autoSize = TextFieldAutoSize.RIGHT;
			config['mailPanel'].form.Notetxt.text = String(config['note'] + "" + " :");
			config['mailPanel'].form.send.txt.autoSize = TextFieldAutoSize.LEFT;
			config['mailPanel'].form.send.txt.text = String(config['send']);

			config['mailPanel'].form.send.bg.width = config['mailPanel'].form.send.txt.width + 12;
			config['mailPanel'].form.send.x = (config['mailPanel'].form.Note.x+config['mailPanel'].form.Note.width)- (config['mailPanel'].form.send.width+2);
			config['mailPanel'].form.bt.width = config['mailPanel'].form.send.txt.width + 6;
			config['mailPanel'].form.bt.x = config['mailPanel'].form.send.x;
			if (String(config['sharepaneltextColor']) != "")
			{
				config['mailPanel'].form.Totxt.textColor = config['sharepaneltextColor'];
				config['mailPanel'].form.Fromtxt.textColor = config['sharepaneltextColor'];
				config['mailPanel'].form.Notetxt.textColor = config['sharepaneltextColor'];

				config['mailPanel'].form.from.textColor = config['sharepaneltextColor'];
				config['mailPanel'].form.to.textColor = config['sharepaneltextColor'];
				config['mailPanel'].form.Note.textColor = config['sharepaneltextColor'];
				config['mailPanel'].form.output.textColor = config['sharepaneltextColor'];
				config['mailPanel'].result.textColor = config['sharepaneltextColor'];
			}
			if (String(config['sendButtonTextColor']) != "")
			{
				config['mailPanel'].form.send.txt.textColor = config['sendButtonTextColor'];
			}
			config['mailPanel'].mouseEnabled = false;
			config['mailPanel'].closeBut.scaleX = config['mailPanel'].closeBut.scaleY = 1;
			config['mailPanel'].form.starmcc.visible = false;
			if (config['mailB'] == false)
			{
				config['mailPanel'].y =  -  config['mailPanel'].height;
				config['mailPanel'].x=(config['stageWidth']/2)-(config['mailPanel'].width/2);
				new Tween(config['mailPanel'] , "y", null , config['mailPanel'].y  , (config['stageHeight']/2)-(config['mailPanel'].height/2) , 0.3 , true);
				config['shareClip'].alpha = 0.5;
				config['midRoll'].alpha = 0;
				config['mailPanel'].visible = true;
				if (config['isplayed'] == true && config['file'] != undefined)
				{
					var videopause = new videoPause(config);
				}
				config['mailB'] = true;
				config['adv'].visible = false;
				if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
				{
					if (config['thuMc'].x < config['stageWidth'])
					{
						var slideRelatedVideo = new sliderelatedVideo(config,config['ref']);
						slideRelatedVideo.hideRelatedVideo();
					}
				}
			}
			else
			{
				if (config['pauseState'] == true && config['file'] != undefined)
				{
					var videoplay = new videoPlay(config);
				}
				else
				{
					config['Playbtn'].alpha = 1;
				}
				mailclosed();
			}
			setTimeout(shareEnable,400);
		}
		function mailcloseFun(eve:MouseEvent)
		{
			config['QualityBg'].visible = false;
			if (config['mailB'] == true)
			{
				if (config['pauseState'] == true && config['file'] != undefined)
				{
					var videoplay = new videoPlay(config);
				}
				else
				{
					config['Playbtn'].alpha = 1;
				}
				mailclosed();
			}
		}
		public function mailclosed()
		{
			config['shareClip'].alpha = 1;
			config['midRoll'].alpha = 1;
			config['mailB'] = false;
			new Tween(config['mailPanel'],"y",null,config['mailPanel'].y,config['stageHeight'] + config['mailPanel'].height,0.3,true);
			var videoscale = new videoScale(config,reference);
			videoscale.buttonVis();
			if (config['midvis'])
			{
				config['adv'].visible = true;

			}
		}
		function shareEnable()
		{
			config['shareMc'].mouseEnabled = true;
		}
		public function sendEmailFun()
		{
			if (config['mailPanel'].form.to.text == "" || config['mailPanel'].form.from.text == "")
			{
				config['mailPanel'].result.text = config['fill_required_fields'];
				config['mailPanel'].form.starmcc.visible = true;
			}
			else if (!isValidEmail(config['mailPanel'].form.to.text) || !isValidEmail(config['mailPanel'].form.from.text))
			{
				config['mailPanel'].result.text = config['wrong_email'];
				config['mailPanel'].form.starmcc.visible = true;
			}
			else
			{
				if (config['shareURL'] != "")
				{
					if (config['shareURL'].indexOf('http') > -1)
					{
						config['shareURL'] = config['shareURL'];
					}
					else
					{
						config['shareURL'] = config['baseurl'] + "" + config['shareURL'];
					}
					config['mailPanel'].result.text = config['email_wait'];
					variables = new URLVariables();
					variables.to = config['mailPanel'].form.to.text;
					variables.from = config['mailPanel'].form.from.text;
					variables.url = config['SocialPanel'].pMc.pageurl.text;
					variables.title = config['title'];
					variables.Note = config['mailPanel'].form.Note.text;
					requ = new URLRequest();
					if (config['shareURL'].indexOf('http') > -1)
					{
						config['shareURL'] = config['shareURL'];
					}
					else
					{
						config['shareURL'] = config['baseurl'] + "" + config['shareURL'];
					}
					requ = new URLRequest(config['shareURL']);
					requ.method = URLRequestMethod.POST;
					requ.data = variables;
					urlLoader = new URLLoader();
					urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
					urlLoader.addEventListener(Event.COMPLETE, responseReceived);
					urlLoader.load(requ);
				}
			}
		}
		function responseReceived(evt:Event)
		{
			if (String(config['mailPanel'].form.output.text) == "sent")
			{
				config['mailPanel'].result.text = "Thank you! Video has been sent.";
			}
			else
			{
				config['mailPanel'].result.text = config['email_sent'];
			}
		}
		function isValidEmail(email:String):Boolean
		{
			var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return emailExpression.test(email);
		}
	}
}