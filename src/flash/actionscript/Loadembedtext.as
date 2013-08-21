package actionscript
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.display.*;
	import flash.external.*;
	import flash.text.*;

	public class Loadembedtext
	{
		public static var reference:Sprite;
		private var config:Object;
		private var embedText:String;

		public function Loadembedtext(ref:Sprite,cfg:Object):void
		{
			config = cfg;
			reference = ref;
			pageurlget();
			embedcall();
		}
		function pageurlget()
		{
			if (config['copylink'] != "" && config['copylink'] != null && config['copylink'] != undefined)
			{
				config['SocialPanel'].pMc.pageurl.text = String(config['copylink']);
			}
			else
			{
				if (config['local'] == 'true')
				{
					config['SocialPanel'].pMc.pageurl.text = String(config['pageURL']);
				}
				else
				{
					if (ExternalInterface.call("window.location.href.toString") != null)
					{
						config['SocialPanel'].pMc.pageurl.text = ExternalInterface.call("window.location.href.toString");
					}
					else
					{
						config['SocialPanel'].pMc.pageurl.text = String(config['pageURL']);
					}

				}
				if (config['SocialPanel'].pMc.pageurl.text.indexOf('?videoID=') > -1)
				{
					var arrss:Array = config['SocialPanel'].pMc.pageurl.text.split('?videoID=');
					config['SocialPanel'].pMc.pageurl.text = arrss[0] + "?videoID=" + config['vid'];
				}
				else
				{
					config['SocialPanel'].pMc.pageurl.text = config['SocialPanel'].pMc.pageurl.text + "?videoID=" + config['vid'];
				}
			}
		}
		function embedcall()
		{
			embedText = "";
			embedText +=  generateEmbed();
			embedText +=  ' style=';
			embedText +=  '"width:';
			embedText +=  config['stageWidth'] + 'px;height:';
			embedText +=  config['stageHeight'] + 'px" allowFullScreen="true" allowScriptAccess="always"';
			embedText +=  ' type="application/x-shockwave-flash" wmode="transparent"></embed>';
			config['SocialPanel'].emb.embedurl.text = String(embedText);
			config["embedText"] = embedText;
		}
		function generateEmbed()
		{
			var embedCode:String;
			if (reference.root.loaderInfo.parameters['baserefW'])
			{
				embedCode = '<embed id="player" src="' + config['basearW'] + 'hdplayer.swf" ';
				embedCode +=  'flashvars="baserefW=' + reference.root.loaderInfo.parameters['baserefW'] + '&playlist_auto=false';
				if (config['ref'].root.loaderInfo.parameters['pid'])
				{
					embedCode +=  '&pid=' + config['ref'].root.loaderInfo.parameters['pid'];
				}
				if (config['ref'].root.loaderInfo.parameters['vid'])
				{
					embedCode +=  '&vid=' + config['ref'].root.loaderInfo.parameters['vid'];
				}
				else
				{
					embedCode +=  '&vid=' + config['vid_id'];
				}
			}
			else
			{
				embedCode = '<embed id="player" src="' + config['baseurl'] + 'hdplayer.swf" ';
				embedCode +=  'flashvars="baseref=' + config['baseurl'] + '&playlist_auto=false';
				if(config['preview'] != "")embedCode +=  '&preview=' + config['preview'];
				if(config['streamer'] != "")embedCode +=  '&streamer=' + config['streamer'];
			    embedCode +=  '&file=' + config['file'];
				embedCode +=  '&skin=' + config['skin'];
				if (config['isLive'] == "true")
				{
					embedCode +=  '&isLive=true';
				}
				if (config['allowpostroll'] == 'true')
				{
					embedCode +=  "&allowpostroll=" + config['allowpostroll'];
					embedCode +=  "&post_id=" + config['postad_id'];
				}
				if (config['allowpreroll'] == 'true')
				{
					embedCode +=  "&allowpreroll=" + config['allowpreroll'];
					embedCode +=  "&pre_id=" + config['pread_id'];
				}
				embedCode += "&thumb="+config['thumb']
				if (config['plistlength'] != 0)
				{
					config['title'] = config['title'];
				}
				else if (config['ref'].root.loaderInfo.parameters['title'])
				{
					config['title'] = config['ref'].root.loaderInfo.parameters['title'];
				}
				else
				{
					config['title'] = "";
				}
				if(config['title'] != "")embedCode +=  "&title=" + config['title'];
				if (config['showTag'] == "true" && config['tagline'].txt.text != "")
				{
					embedCode +=  "&tagline=" + config['tagline'].txt.text;
				}
			}
			embedCode +=  "&showPlaylist=false&shareIcon=false&email=false&zoomIcon=false&playlist_autoplay=false";
			embedCode +=  "&videoID=" + config['vid'];
			embedCode += "&embedplayer=true"
			embedCode +=  '"';
			return embedCode;
		}
	}
}