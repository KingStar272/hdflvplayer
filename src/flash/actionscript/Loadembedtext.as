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
		private var irameText:String;

		public function Loadembedtext(ref:Sprite,cfg:Object):void
		{
			config = cfg;
			reference = ref;
			pageurlget();
			embedcall();
			iframecall()
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
					if(config['fbpath'] != "" && config['fbpath'] != undefined)config['SocialPanel'].pMc.pageurl.text = config['fbpath']
					else if (ExternalInterface.call("window.location.href.toString") != null)
					{
						config['SocialPanel'].pMc.pageurl.text = ExternalInterface.call("window.location.href.toString");
					}
					else
					{
						config['SocialPanel'].pMc.pageurl.text = String(config['pageURL']);
					}
				}
				if(config['pluginType'] == "")
				{
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
			if (reference.root.loaderInfo.parameters['baserefW'] || reference.root.loaderInfo.parameters['baserefWP'])
			{
				embedCode = '<embed id="player" src="' + config['basearW'] + 'hdplayer.swf" ';
				if(reference.root.loaderInfo.parameters['baserefW'])embedCode +=  'flashvars="baserefW=' + reference.root.loaderInfo.parameters['baserefW'] + '&playlist_auto=false';
				else embedCode +=  'flashvars="baserefWP=' + reference.root.loaderInfo.parameters['baserefWP'] + '&playlist_auto=false';
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
			else if (reference.root.loaderInfo.parameters['baserefJ'] || reference.root.loaderInfo.parameters['baserefJHDV'])
			{
				if(reference.root.loaderInfo.parameters['baserefJHDV'])
				{
					embedCode = '<embed id="player" src="' + reference.root.loaderInfo.parameters['baserefJHDV'] + '/components/com_contushdvideoshare/hdflvplayer/hdplayer.swf" ';
				    embedCode +=  'flashvars="baserefJHDV=' + reference.root.loaderInfo.parameters['baserefJHDV'] + '&playlist_auto=false';
				}
				else
				{
					embedCode = '<embed id="player" src="' + reference.root.loaderInfo.parameters['baserefJ'] + '/components/com_hdflvplayer/hdflvplayer/hdplayer.swf" ';
				    embedCode +=  'flashvars="baserefJ=' + reference.root.loaderInfo.parameters['baserefJ'] + '&playlist_auto=false';
				}
				if(reference.root.loaderInfo.parameters['playid']) embedCode += "&playid=" + reference.root.loaderInfo.parameters['playid']
				if(reference.root.loaderInfo.parameters['id']) embedCode += "&id=" + reference.root.loaderInfo.parameters['id']
				if(reference.root.loaderInfo.parameters['mid']) embedCode += "&mid=" + reference.root.loaderInfo.parameters['mid']
				if(reference.root.loaderInfo.parameters['compid']) embedCode += "&compid=" + reference.root.loaderInfo.parameters['compid']
				if(reference.root.loaderInfo.parameters['jlang']) embedCode += "&lang="+ reference.root.loaderInfo.parameters['jlang']
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
			if(reference.root.loaderInfo.parameters['mtype']) embedCode += "&mtype=" + reference.root.loaderInfo.parameters['mtype']
			embedCode +=  "&showPlaylist=false&shareIcon=false&email=false&zoomIcon=false&playlist_autoplay=false";
			embedCode +=  "&videoID=" + config['vid'];
			embedCode += "&embedplayer=true"
			embedCode +=  '"';
			return embedCode;
		}
		function iframecall()
		{
			irameText = '<iframe frameborder="0"';
			irameText +=  ' width= "' +config['stageWidth']+ '" height="' +config['stageHeight']+ '" scrolling="no"';
			if (reference.root.loaderInfo.parameters['baserefJ'] || reference.root.loaderInfo.parameters['baserefJHDV'])
			{
			irameText +=  ' src="' + reference.root.loaderInfo.parameters['baserefJ'] + '/components/com_hdflvplayer/hdflvplayer/hdplayer.swf';
			irameText +=  '?baserefJ='+ reference.root.loaderInfo.parameters['baserefJ'] + '&playlist_auto=false';
			}
			else
			{
				irameText +=  ' src="' + config['baseurl'] + 'hdplayer.swf?playlist_auto=false';
			}
			if(reference.root.loaderInfo.parameters['playid']) irameText += "&playid=" + reference.root.loaderInfo.parameters['playid']
			if(reference.root.loaderInfo.parameters['id']) irameText += "&id=" + reference.root.loaderInfo.parameters['id']
			if(reference.root.loaderInfo.parameters['mid']) irameText += "&mid=" + reference.root.loaderInfo.parameters['mid']
			if(reference.root.loaderInfo.parameters['compid']) irameText += "&compid=" + reference.root.loaderInfo.parameters['compid']
			if(reference.root.loaderInfo.parameters['jlang']) irameText += "&lang="+ reference.root.loaderInfo.parameters['jlang']
			if(reference.root.loaderInfo.parameters['mtype']) irameText += "&mtype=" + reference.root.loaderInfo.parameters['mtype']
			irameText +=  "&showPlaylist=false&shareIcon=false&email=false&zoomIcon=false&playlist_autoplay=false";
			irameText +=  "&videoID=" + config['vid'];
			irameText += "&embedplayer=true"
			irameText += '"></iframe>'
			config['SocialPanel'].ifra.embedurl.text = String(irameText);
		}
	}
}