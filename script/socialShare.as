package script
{
	import flash.display.Sprite;
	import flash.display.*;
	import flash.external.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.navigateToURL;
	import flash.text.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.utils.*;
	import flash.net.*;

	public class socialShare extends Sprite
	{
		private var video_des:String;
		private var config:Object;
		private var bookmark:String;
		private var IconArr:Array;
		private var IconindexArr:Array;
		private var myTM:TransitionManager;
		private var galMc:gal3;
		private var nopreviewMc:nopreview;
		private var autoOv:Boolean;
		//========================================== share video in social networks ==============================================================================
		public function socialShare(conFig)
		{
			config = conFig;
			autoOv = false;
			IconArr = new Array();
			IconindexArr = new Array();
			IconArr = [config['SocialPanel'].facebook,config['SocialPanel'].tumblr,config['SocialPanel'].google,config['SocialPanel'].tweet,config['skinMc'].pp.play_btn,config['skinMc'].pp.pause_btn,config['skinMc'].FullScreen,config['skinMc'].hd.hdOffmode,config['skinMc'].hd.hdOnmode,config['skinMc'].Volume,config['shareMc'],config['zoomInMc'],config['zoomOutMc'],config['downloadMc'],config['skinMc'].PlayListView,config['skinMc'].autoPlayButton,config['skinMc'].pp.Replay,config['mailIcon']];
			IconindexArr = ["facebook","tumblr","google+","tweet","Play","Pause","FullScreen","hdOnmode","hdOffmode","Volume","share","zoomIn","zoomOut","download","Replay","Mail"]
			config['SocialPanel'].tweet.buttonMode = config['SocialPanel'].facebook.buttonMode = true;
			config['SocialPanel'].facebook.addEventListener(MouseEvent.MOUSE_DOWN,facebookFun);
			config['SocialPanel'].tweet.addEventListener(MouseEvent.CLICK,tweetFun);
			config['SocialPanel'].tumblr.addEventListener(MouseEvent.CLICK,tumblrFun);
			config['SocialPanel'].google.addEventListener(MouseEvent.CLICK,googlebtFun);
			for (var i=0; i<IconArr.length; i++)
			{
				IconArr[i].buttonMode = true;
				IconArr[i].id = i;
				if (config['local'] != 'true')
				{
					IconArr[i].addEventListener(MouseEvent.MOUSE_OVER,toolTipShown);
				}
				IconArr[i].addEventListener(MouseEvent.MOUSE_OUT,toolTipOff);
			}
		}
		//========================================== show tooltip  ==============================================================================
		private function toolTipShown(eve:MouseEvent)
		{
			if (config['local'] != 'true')
			{
				config['tooltipMc'].visible = true;
			}
			config['tooltipMc'].tips.autoSize = TextFieldAutoSize.CENTER;
			config['tooltipMc'].tips.textColor = config['textColor'];
			if (eve.currentTarget.id != 9)
			{
				new Tween(config['skinMc'].Volume.vol_bar,"y",null,config['skinMc'].Volume.vol_bar.y,config['skinMc'].Volume.vol_bar.height,0.3,true);
			}
			if (eve.currentTarget.id != 7 && eve.currentTarget.id != 8)
			{
				config['QualityBg'].visible = false;
			}
			if (eve.currentTarget.id == 17)
			{
				config['tooltipMc'].tips.text = config['Mail'];
			}
			else if (eve.currentTarget.id == 6)
			{
				if (config["displayState"] == "normal")
				{
					config['tooltipMc'].tips.text = config['FullScreen'];
				}
				else
				{
					config['tooltipMc'].tips.text = config['ExitFullScreen'];
				}
			}
			else if (eve.currentTarget.id ==16)
			{
				config['tooltipMc'].tips.text = config['Replay'];
			}
			else if (eve.currentTarget.id == 14)
			{
				if (config['relatedview'] == true)
				{
					config['tooltipMc'].tips.text = config['PlayListHide'];
				}
				else
				{
					config['tooltipMc'].tips.text = config['PlayListView'];
				}
			}
			else if (eve.currentTarget.id == 15)
			{
				autoOv = false;
				if (config['playlist_autoplay'] == "true")
				{
					config['tooltipMc'].tips.text = config['autoplayOff'];
				}
				else
				{
					config['tooltipMc'].tips.text = config['autoplayOn'];
				}
				var s = Number(config['vid']);
				config['autopImgArr'] = new Array();
				config['autopL'].visible = true;
				for (var f=0; f<3; f++)
				{
					galMc = new gal3();
					config['autopL'].addChild(galMc);
					config['autopImgArr'].push(galMc);
					galMc.mark.visible = false;
					galMc.x= f*(galMc.width-2);
					config['autopL'].x = eve.currentTarget.x - galMc.width;
					config['autopL'].y = config['skinMc'].skin_bg.y - (config['autopL'].height);
					if (config['autopL'].x > config['stageWidth'] - config['autopL'].width)
					{
						config['autopL'].x = config['stageWidth'] - config['autopL'].width;
					}
					var tex:String = config['video_title'][f + config['vid']];
					galMc.tle.htmlText = String(tex);
					galMc.tle.mouseEnabled = false;
					galMc.tle.visible = false;
					var d = Number(f) + Number(s);
					if (d==config['thumb_image'].length)
					{
						s = d = 0;
					}
					if (config['thumb_image'][d] == undefined || config['thumb_image'][d] == "")
					{
						nopreviewMc=new nopreview();
						galMc.img.addChild(nopreviewMc);
						nopreviewMc.tex.text = String(config['nothumbnail']);
						nopreviewMc.width = 72;
						nopreviewMc.height = 41.5;
						galMc.thu_buf.visible = false;
					}
					else
					{
						var loadThum = new autoImage(galMc,config,d);
					}
					if (f!=0)
					{
						if (config['playlist_autoplay'] == "true")
						{
							galMc.mark.visible = true;
							galMc.img.alpha = 1;
						}
						else
						{
							galMc.mark.visible = true;
							galMc.img.alpha = 0.1;
						}
						config['autopL'].addEventListener(MouseEvent.MOUSE_OVER,autoPlayOver);
					}
				}

			}
			else if (eve.currentTarget.id == 7 || eve.currentTarget.id == 8)
			{
				config['tooltipMc'].tips.text = config['Changequality'];
			}
			else
			{
				config['tooltipMc'].tips.text = config[IconindexArr[eve.currentTarget.id]];

			}
			config['tooltipMc'].tipm.width = config['tooltipMc'].tips.width + 12;
			if ((eve.currentTarget.id <= 3 || eve.currentTarget.id>9) && eve.currentTarget.id<14 )
			{
				config['tooltipMc'].ti.visible = false;
				if (eve.currentTarget.id > 9)
				{
					config['tooltipMc'].x= (eve.currentTarget.x+ eve.currentTarget.width+config['tooltipMc'].width/2)+5;
					config['tooltipMc'].y = eve.currentTarget.y + eve.currentTarget.height / 2;
				}
				else
				{
					config['tooltipMc'].x = mouseX;
					config['tooltipMc'].y = mouseY - 20;
				}
			}
			else if (eve.currentTarget.id==17)
			{
				config['tooltipMc'].ti.visible = false;
				config['tooltipMc'].x= (eve.currentTarget.x+ eve.currentTarget.width+config['tooltipMc'].width/2)+5;
				config['tooltipMc'].y = eve.currentTarget.y + eve.currentTarget.height / 2;
			}
			else if (eve.currentTarget.id==15)
			{
				config['tooltipMc'].x = mouseX;
				config['tooltipMc'].y = config['stageHeight']-(config['skinMc'].skin_bg.height+35+config['tooltipMc'].height);
			}
			else if (eve.currentTarget.id != 9)
			{
				config['tooltipMc'].ti.visible = true;
				config['tooltipMc'].x = mouseX;
				config['tooltipMc'].ti.x = 0;
				config['tooltipMc'].y = config['stageHeight']-(config['skinMc'].skin_bg.height+15);
			}
			else
			{
				config['tooltipMc'].visible = false;
			}
			if (eve.currentTarget.id != 15)
			{
				config['autopL'].visible = false;
			}
			if (config['tooltipMc'].x>(config['stageWidth']-(config['tooltipMc'].tipm.width/2)))
			{
				config['tooltipMc'].x = (config['stageWidth']-(config['tooltipMc'].tipm.width/2))-2;
				config['tooltipMc'].ti.x = (config['tooltipMc'].tipm.width/2)-10;
			}
			else if (config['tooltipMc'].x<(config['tooltipMc'].tipm.width/2))
			{
				config['tooltipMc'].x = (config['tooltipMc'].tipm.width/2)+2;
				config['tooltipMc'].ti.x = -((config['tooltipMc'].tipm.width/2)-10);
			}
			eve.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER,toolTipShown);
			eve.updateAfterEvent();

		}
		//========================================== hide tooltip  ==============================================================================
		private function toolTipOff(eve:MouseEvent)
		{
			if (eve.currentTarget.id != 15)
			{
				config['tooltipMc'].visible = false;
			}
			eve.currentTarget.addEventListener(MouseEvent.MOUSE_OVER,toolTipShown);
			eve.updateAfterEvent();
		}
		private function autoPlayOver(eve:MouseEvent)
		{
			autoOv = true;
		}
		private function removeautopL()
		{
			if (autoOv == false)
			{
				while (config['autopL'].numChildren > 0)
				{
					config['autopL'].removeChildAt(0);
				}
				config['tooltipMc'].visible = false;
			}
		}
		private function facebookFun(eve:MouseEvent)
		{
			config['QualityBg'].visible = false;
			if (config['caption_video'][config['vid']] == undefined)
			{
				video_des = config['SocialPanel'].pMc.pageurl.text;
			}
			else
			{
				var removeHtmlRegExp2:RegExp = new RegExp("<[^<]+?>","gi");
				config['caption_video'][config['vid']] = String(config['caption_video'][config['vid']]).replace(removeHtmlRegExp2,"");
				video_des = config['caption_video'][config['vid']];
			}
			if (config['video'] == "youtube")
			{
				var chars_array = config['file'].split("&");
				config['file'] = chars_array[0];
			}

			var primage:String = config['preview'];
			if (config['ref'].root.loaderInfo.parameters['preview'])
			{
				primage = config['ref'].root.loaderInfo.parameters['preview'];
			}
			else if (config['plistlength'] != 0)
			{
				primage = primage;
			}
			if (primage == "" || primage == null)
			{
				primage = "images/default_preview.jpg";
			}
			if (primage != null &&( primage.indexOf('http') > -1 || primage.indexOf('https') > -1))
			{
				primage = primage;
			}
			else
			{
				primage = config['baseurl'] + "" + primage;
			}


			var thuimage:String;
			if (config['ref'].root.loaderInfo.parameters['thumb'])
			{
				thuimage = config['ref'].root.loaderInfo.parameters['thumb'];
			}
			else if (config['plistlength'] != 0)
			{
				thuimage = config['thumb_image'][config['vid']];
			}
			if (thuimage == "" || thuimage == null)
			{
				thuimage = "images/default_thumb.jpg";
			}
			if (thuimage != null && (thuimage.indexOf('http') > -1 || thuimage.indexOf('https') > -1))
			{
				thuimage = thuimage;
			}
			else
			{
				thuimage = config['baseurl'] + "" + thuimage;
			}
			thuimage = decodeURI(thuimage);
			if (config['streamer'] != undefined && config['streamer'].indexOf("rtmp") > -1 && config['file'].indexOf(":") > -1)
			{
				var arrd8:Array = config['file'].split(':');
				config['file'] = arrd8[1];
			}
			var video_src:String = "";
			video_src = config['baseurl'] + 'hdplayer.swf?file=' + config['file'];
			video_src +=  '&embedplayer=true&HD_default=true&showPlaylist=false&zoomIcon=false&email=false&playlist_auto=false';
			video_src +=  '&skin_autohide=' + config['skin_autohide'];
			video_src +=  '&preview=' + primage;
			video_src +=  '&thumb=' + thuimage;
			video_src +=  '&skin=' + config['skin'];
			video_src +=  '&autoplay=' + config['autoplay'];
			video_src +=  '&volume=' + config['volume'];
			video_src += '&timer=' + config['timer']
			if (config['ref'].root.loaderInfo.parameters['baserefW'])
			{
				video_src +=  '&baserefW=' + config['ref'].root.loaderInfo.parameters['baserefW'];
			}
			if (config['ref'].root.loaderInfo.parameters['pid'])
			{
				video_src +=  '&pid=' + config['ref'].root.loaderInfo.parameters['pid'];
			}
			if (config['ref'].root.loaderInfo.parameters['vid'])
			{
				video_src +=  '&vid=' + config['ref'].root.loaderInfo.parameters['vid'];
			}
			else
			{
				video_src +=  '&vid=' + config['vid_id'];
			}

			if (String(config['stagecolor']) != "")
			{
				video_src +=  "&stagecolor=" + config['stagecolor'];
			}
			else
			{
				video_src +=  "&stagecolor=";
			}
			if (String(config['relatedVideoBgColor']) != "")
			{
				video_src +=  "&relatedVideoBgColor=" + config['relatedVideoBgColor'];
			}
			else
			{
				video_src +=  "&relatedVideoBgColor=";
			}
			if (String(config['textColor']) != "")
			{
				video_src +=  "&textColor=" + config['textColor'];
			}
			else
			{
				video_src +=  "&textColor=";
			}
			if (String(config['seek_barColor']) != "")
			{
				video_src +=  "&seek_barColor=" + config['seek_barColor'];
			}
			else
			{
				video_src +=  "&seek_barColor=";
			}
			if (String(config['buffer_barColor']) != "")
			{
				video_src +=  "&buffer_barColor=" + config['buffer_barColor'];
			}
			else
			{
				video_src +=  "&buffer_barColor=";
			}
			if (String(config['pro_BgColor']) != "")
			{
				video_src +=  "&pro_BgColor=" + config['pro_BgColor'];
			}
			else
			{
				video_src +=  "&pro_BgColor=";
			}
			if (String(config['skinIconColor']) != "")
			{
				video_src +=  "&skinIconColor=" + config['skinIconColor'];
			}
			else
			{
				video_src +=  "&skinIconColor=";

			}
			if (config['showTag'] == "true" && config['tagline'].txt.text != "")
			{
				video_src +=  "&tagline=" + config['tagline'].txt.text;
			}

			if (config['isLive'] == "true")
			{
				video_src +=  "&isLive=" + config['isLive'];
			}
			if (config['allowpostroll'] == 'true')
			{
				video_src +=  "&allowpostroll=" + config['allowpostroll'];
				video_src +=  "&post_id=" + config['postad_id'];
			}
			if (config['allowpreroll'] == 'true')
			{
				video_src +=  "&allowpreroll=" + config['allowpreroll'];
				video_src +=  "&pre_id=" + config['pread_id'];
			}
			if (config['streamer'] != "" && config['streamer'] != null)
			{
				video_src +=  "&streamer=" + config['streamer'];
			}
			bookmark = "http://www.facebook.com/sharer.php?s=100&p[title]=" + escape(utftextFun(config['title'])) + "&p[summary]=" + escape(utftextFun(video_des)) + "&p[medium]=" + escape('103') + "&p[video][src]=" + escape(utftextFun(video_src)) + "&p[url]=" + escape(utftextFun(config['SocialPanel'].pMc.pageurl.text)) + "&p[images][0]=" + escape(thuimage);
			navigateToURL(new URLRequest(bookmark) , "_blank");
		}
		function tweetFun(evt:MouseEvent)
		{
			config['QualityBg'].visible = false;
			bookmark = "http://twitter.com/home?status=" + escape(utftextFun(config['title'])) + ":+" + escape(config['SocialPanel'].pMc.pageurl.text);
			navigateToURL(new URLRequest(bookmark) , "_blank");
		}
		function tumblrFun(evt:MouseEvent)
		{
			config['QualityBg'].visible = false;
			if (config['caption_video'][config['vid']] == undefined)
			{
				video_des = config['SocialPanel'].pMc.pageurl.text;
			}
			else
			{
				video_des = config['caption_video'][config['vid']];
			}
			var embedCode:String = "";


			var primag:String = config['preview'];
			if (config['ref'].root.loaderInfo.parameters['preview'])
			{
				primag = config['ref'].root.loaderInfo.parameters['preview'];
			}
			else if (config['plistlength'] != 0)
			{
				primag = primag;
			}
			if (primag == "" || primag == "")
			{
				primag = "images/default_preview.jpg";
			}
			if (primag != null &&( primag.indexOf('http') > -1 || primag.indexOf('https') > -1))
			{
				primag = primag;
			}
			else
			{
				primag = config['baseurl'] + "" + primag;
			}

			var thuimag:String;
			if (config['ref'].root.loaderInfo.parameters['thumb'])
			{
				thuimag = config['ref'].root.loaderInfo.parameters['thumb'];
			}
			else if (config['plistlength'] != 0)
			{
				thuimag = config['thumb_image'][config['vid']];
			}
			if (thuimag == "" || thuimag == "")
			{
				thuimag = "images/default_thumb.jpg";
			}
			if (thuimag != null && (thuimag.indexOf('http') > -1 || thuimag.indexOf('https') > -1))
			{
				thuimag = thuimag;
			}
			else
			{
				thuimag = config['baseurl'] + "" + thuimag;
			}
			thuimag = decodeURI(thuimag);
			if (config['ref'].root.loaderInfo.parameters['baserefW'])
			{
				embedCode = '<embed id="player" src="' + config['basearW'] + 'hdplayer.swf" ';
				embedCode +=  'flashvars="file=' + config['file'] + '&baserefW=' + config['ref'].root.loaderInfo.parameters['baserefW'] + '&autoplay=false&playlist_auto=false';
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
				embedCode +=  'flashvars="file=' + config['file'] + '&baseref=' + config['baseurl'] + '&autoplay=false&playlist_auto=false';
			}
			
			if (config['streamer'] != undefined && config['streamer'].indexOf("rtmp") > -1 && config['file'].indexOf(":") > -1)
			{
				var arrd8:Array = config['file'].split(':');
				config['file'] = arrd8[1];
			}


			if (config['streamer'] != "" && config['streamer'] != null)
			{
				embedCode +=  "&streamer=" + config['streamer'];
			}
			embedCode +=  "&preview=" + primag;
			embedCode +=  "&thumb=" + thuimag;
			embedCode +=  '&skin=' + config['skin'];
			if (config['isLive'] == "true")
			{
				embedCode +=  '&isLive=true';
			}
			embedCode +=  "&showPlaylist=false";
			embedCode +=  "&allowpostroll=false&&allowpreroll=false";
			embedCode +=  "&videoID=" + config['vid'];
			embedCode +=  "&embedplayer=true&autoplay=true&email=false&zoomIcon=false&shareIcon=false&email=false";
			if (String(config['stagecolor']) != "")
			{
				embedCode +=  "&stagecolor=" + config['stagecolor'];
			}
			else
			{
				embedCode +=  "&stagecolor=";
			}
			if (String(config['skinBgColor']) != "")
			{
				embedCode +=  "&skinBgColor=" + config['skinBgColor'];
			}
			else
			{
				embedCode +=  "&skinBgColor=";
			}
			if (String(config['relatedVideoBgColor']) != "")
			{
				embedCode +=  "&relatedVideoBgColor=" + config['relatedVideoBgColor'];
			}
			else
			{
				embedCode +=  "&relatedVideoBgColor=";
			}
			if (String(config['textColor']) != "")
			{
				embedCode +=  "&textColor=" + config['textColor'];
			}
			else
			{
				embedCode +=  "&textColor=";
			}
			if (String(config['seek_barColor']) != "")
			{
				embedCode +=  "&seek_barColor=" + config['seek_barColor'];
			}
			else
			{
				embedCode +=  "&seek_barColor=";
			}
			if (String(config['buffer_barColor']) != "")
			{
				embedCode +=  "&buffer_barColor=" + config['buffer_barColor'];
			}
			else
			{
				embedCode +=  "&buffer_barColor=";
			}
			if (String(config['pro_BgColor']) != "")
			{
				embedCode +=  "&pro_BgColor=" + config['pro_BgColor'];
			}
			else
			{
				embedCode +=  "&pro_BgColor=";
			}
			if (String(config['skinIconColor']) != "")
			{
				embedCode +=  "&skinIconColor=" + config['skinIconColor'];
			}
			else
			{
				embedCode +=  "&skinIconColor=";
			}
			embedCode +=  '"';
			embedCode +=  ' style=';
			embedCode +=  '"width:';
			embedCode +=  config['stageWidth'] + 'px;height:';
			embedCode +=  config['stageHeight'] + 'px" allowFullScreen="true" allowScriptAccess="always"';
			embedCode += ' type="application/x-shockwave-flash" wmode="transparent"></embed>'
			bookmark = "http://www.tumblr.com/share/video?embed="+escape(utftextFun(embedCode))+"&caption="+escape(utftextFun(video_des))+"&title="+escape(utftextFun(config['title']))
			navigateToURL(new URLRequest(bookmark) , "_blank");
		}
		function googlebtFun(evt:MouseEvent)
		{
			config['QualityBg'].visible = false;
			bookmark = "https://plus.google.com/share?url=" + escape(config['SocialPanel'].pMc.pageurl.text) + "&message=" + escape(config['title']);
			navigateToURL(new URLRequest(bookmark) , "_blank");
		}
		//========================================== convet text in UTF format  ==============================================================================
		function utftextFun(string:String)
		{
			if (string!=null)
			{
				var utftext = "";
				for (var n = 0; n < string.length; n++)
				{

					var c = string.charCodeAt(n);
					if (c < 128)
					{
						utftext +=  String.fromCharCode(c);
					}
					else if ((c > 127) && (c < 2048))
					{
						utftext += String.fromCharCode((c >> 6) | 192);
						utftext += String.fromCharCode((c & 63) | 128);
					}
					else
					{
						utftext += String.fromCharCode((c >> 12) | 224);
						utftext += String.fromCharCode(((c >> 6) & 63) | 128);
						utftext += String.fromCharCode((c & 63) | 128);
					}
				}
				return utftext;
			}
		}
	}
}