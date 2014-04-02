package actionscript
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
	import flash.geom.Rectangle;
	import flash.net.URLVariables;

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
		private var onOff:onOffSwitch;
		//========================================== share video in social networks ==============================================================================
		public function socialShare(conFig)
		{
			config = conFig;
			autoOv = false;
			IconArr = new Array();
			IconindexArr = new Array();
			IconArr = [config['SocialPanel'].facebook,config['SocialPanel'].tumblr,config['SocialPanel'].google,config['SocialPanel'].tweet,config['skinMc'].pp.play_btn,config['skinMc'].pp.pause_btn,config['skinMc'].FullScreen,config['skinMc'].hd.hdOffmode,config['skinMc'].hd.hdOnmode,config['skinMc'].Volume,config['shareMc'],config['zoomInMc'],config['zoomOutMc'],config['downloadMc'],config['skinMc'].PlayListView,config['skinMc'].autoPlayButton,config['skinMc'].pp.Replay,config['mailIcon'],config['skinMc'].cc];
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
			config['subTiltleBg'].visible= false;
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
			if(eve.currentTarget.id == 18)
			{
				config['subTiltleBg'].visible= true;
				config['subTiltleBg'].x = eve.currentTarget.x-config['subTiltleBg'].width/2;
				config['subTiltleBg'].y =  config['skinMc'].y - (config['subTiltleBg'].height);
				config['tooltipMc'].visible = false;
			}
			else if (eve.currentTarget.id == 17)
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
				config['tooltipMc'].visible = false;
				
				var s = Number(config['vid']);
				config['autopImgArr'] = new Array();
				config['autopL'].visible = true;
				onOff = new onOffSwitch()
				config['autopL'].addChild(onOff)
				config['onOff'] = onOff;
				config['onOff'].toolTip.tips.autoSize = TextFieldAutoSize.CENTER;
			    config['onOff'].toolTip.tips.textColor = config['textColor'];
				config['onOff'].onBt.addEventListener(MouseEvent.MOUSE_DOWN,channgePlaylistAutoplay);
				config['onOff'].offBt.addEventListener(MouseEvent.MOUSE_DOWN,channgePlaylistAutoplay);
			    config['onOff'].offBt.buttonMode = true;
				config['onOff'].onBt.buttonMode = true;
				if (config['playlist_autoplay'] == "true")
				{
					config['onOff'].toolTip.tips.text = config['autoplayOff'];
					config['onOff'].onBt.gotoAndStop(1);
				    config['onOff'].offBt.gotoAndStop(2);
				}
				else
				{
					config['onOff'].toolTip.tips.text = config['autoplayOn'];
					config['onOff'].onBt.gotoAndStop(2);
				    config['onOff'].offBt.gotoAndStop(1);
				}
				config['onOff'].toolTip.tipm.width = config['onOff'].toolTip.tips.width + 12;
				var otherindex:Number;
				var td:Number;
				if(config['plistlength']>=3)td = 3;
				else td = config['plistlength']
				for (var f=0; f<td; f++)
				{
					galMc = new gal3();
					config['autopL'].addChild(galMc);
					config['autopImgArr'].push(galMc);
					galMc.mark.visible = false;
					galMc.x= f*(galMc.width-2);
					config['autopL'].x = eve.currentTarget.x - galMc.width;
					config['autopL'].y = config['skinMc'].skin_bg.y - (config['autopL'].height-48);
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
				if(config['relatedview'] == true)
				{
					otherindex = config['ref'].getChildIndex(config['relaMc']);
					//config['ref'].setChildIndex(config['autopL'], otherindex+1);
					config['ref'].setChildIndex(config['tooltipMc'], otherindex+1);
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
		// ==================================== change playlist auto play value from user ============================================================;
		function channgePlaylistAutoplay(eve:MouseEvent)
		{
			if(eve.currentTarget.currentFrame == 2)
			{
				config['QualityBg'].visible = false;
				if (config['playlist_autoplay'] == "true")
				{
					for (var g=1; g<config['autopImgArr'].length; g++)
					{
						config['autopImgArr'][g].img.alpha = 0.1;
					}
					config['playlist_autoplay'] = "false";
					config['onOff'].onBt.gotoAndStop(2);
					config['onOff'].offBt.gotoAndStop(1);
					config['onOff'].toolTip.tips.text = config['autoplayOn'];
				}
				else
				{
					for (var g1=1; g1<config['autopImgArr'].length; g1++)
					{
						config['autopImgArr'][g1].img.alpha = 1;
					}
					config['onOff'].onBt.gotoAndStop(1);
					config['onOff'].offBt.gotoAndStop(2);
					config['playlist_autoplay'] = "true";
					config['onOff'].toolTip.tips.text = config['autoplayOff'];
				}
			}
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
			if(thuimage.indexOf('i3.ytimg.com/vi') > -1 || thuimage.indexOf('img.youtube.com') > -1)thuimage = "http://i3.ytimg.com/vi/" + getyoutube_ID(config['file']) + "/hqdefault.jpg";
			
			//if(thuimage.indexOf('i3.ytimg.com/vi') > -1 || thuimage.indexOf('img.youtube.com') > -1)thuimage=primage
			
			thuimage = decodeURI(thuimage);
			if (config['streamer'] != undefined && config['streamer'].indexOf("rtmp") > -1 && config['file'].indexOf(":") > -1)
			{
				var arrd8:Array = config['file'].split(':');
				config['file'] = arrd8[1];
			}
			var video_src:String = "";
			video_src = config['baseurl'] + 'hdplayer.swf?file=' + config['file'];
			video_src +=  '&embedplayer=true&HD_default=true&showPlaylit=false&zoomIcon=false&email=false&playlist_auto=false&shareIcon=false';
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
			else if (config['ref'].root.loaderInfo.parameters['baserefWP'])
			{
				video_src +=  '&baserefWP=' + config['ref'].root.loaderInfo.parameters['baserefWP'];
			}
			else if (config['ref'].root.loaderInfo.parameters['baserefJHDV'])
			{
				video_src +=  '&baserefJHDV=' + config['ref'].root.loaderInfo.parameters['baserefJHDV'];
			}
			else if (config['ref'].root.loaderInfo.parameters['baserefJ'])
			{
				video_src +=  '&baserefJ=' + config['ref'].root.loaderInfo.parameters['baserefJ'];
			}
			if (config['ref'].root.loaderInfo.parameters['pid'])
			{
				video_src +=  '&pid=' + config['ref'].root.loaderInfo.parameters['pid'];
			}
			if(config['ref'].root.loaderInfo.parameters['playid']) video_src += "&playid=" + config['ref'].root.loaderInfo.parameters['playid']
			if(config['ref'].root.loaderInfo.parameters['id']) video_src += "&id=" + config['ref'].root.loaderInfo.parameters['id']
			if(config['ref'].root.loaderInfo.parameters['mid']) video_src += "&mid=" + config['ref'].root.loaderInfo.parameters['mid']
			if(config['ref'].root.loaderInfo.parameters['compid']) video_src += "&compid=" + config['ref'].root.loaderInfo.parameters['compid']
			if(config['ref'].root.loaderInfo.parameters['jlang']) video_src += "&lang="+ config['ref'].root.loaderInfo.parameters['jlang']
			if (config['ref'].root.loaderInfo.parameters['vid'])
			{
				video_src +=  '&vid=' + config['ref'].root.loaderInfo.parameters['vid'];
			}
			else
			{
				video_src +=  '&vid=' + config['vid_id'];
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
			/*bookmark  = 'http://www.facebook.com/sharer.php?s=100';
			bookmark += '&p[title]='     + encodeURIComponent(config['title']);
			bookmark += '&p[summary]='   + encodeURIComponent(video_des);
			bookmark += '&p[url]='       + encodeURIComponent(config['SocialPanel'].pMc.pageurl.text);
			bookmark += '&p[images][0]=' + encodeURIComponent(thuimage);*/
			//+"&swfurl="+escape(utftextFun(video_src))
		   // bookmark = "http://api.addthis.com/oexchange/0.8/forward/facebook/offer?url="+ escape(utftextFun(config['SocialPanel'].pMc.pageurl.text)) +"&title="+utftextFun(config['title'])+"&screenshot="+escape(thuimage)+"&height=350&width=400&description="+utftextFun(video_des)+"pubid=ra-52b8287f2d76101a";
		    bookmark = "http://www.facebook.com/sharer.php?s=100&p[title]="+escape(utftextFun(config['title']))+"&p[summary]="+escape(utftextFun(video_des))+"&p[medium]="+escape('103')+"&p[url]="+escape(utftextFun(config['SocialPanel'].pMc.pageurl.text))+"&p[images][0]="+escape(thuimage);
		   //bookmark = "https://www.facebook.com/sharer/sharer.php?u=100&p[title]=" + escape(utftextFun(config['title'])) + "&p[summary]=" + escape(utftextFun(video_des)) + "&p[medium]=" + escape('103') + "&p[video][src]=" + escape(utftextFun(video_src)) + "&p[url]=" + escape(utftextFun(config['SocialPanel'].pMc.pageurl.text)) + "&p[images][0]=" + escape(thuimage);
			navigateToURL(new URLRequest(bookmark) , "_blank");
			
			
			/*var req:URLRequest = new URLRequest();
			req.url = "http://www.facebook.com/dialog/feed";
			var vars:URLVariables = new URLVariables();
			vars.app_id = String(config['FB_app_id'])// your application's id)
			//vars.app_id = "422645514466422"
			vars.link = config['SocialPanel'].pMc.pageurl.text;
			vars.picture = thuimage;
			vars.name = config['title'];
			//vars.caption = video_des;
			vars.description = video_des;
			//vars.message = "message message message message message";
			vars.redirect_uri = "http://www.facebook.com/";
			req.data = vars;
			req.method = URLRequestMethod.POST;
			navigateToURL(req, "_blank");*/
		}
		private function getyoutube_ID(url:String):String
		{
			if (url.indexOf('youtu.be/') > -1)
			{
				var arrsY:Array = url.split('youtu.be/');
				var strY = arrsY[1];
				return strY;
			}
			else
			{
				url = url.replace('v/','v=');
				var arrss:Array = url.split('v=');
				var str = arrss[1];
				arrss=new Array();
				arrss = str.split('&');
				str = arrss[0];
				arrss=new Array();
				arrss = str.split('feature');
				str = arrss[0];
				arrss=new Array();
				arrss = str.split('?');
				str = arrss[0];
				return str;
			}
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
			if (config['ref'].root.loaderInfo.parameters['baserefW'] || config['ref'].root.loaderInfo.parameters['baserefWP'])
			{
				embedCode = '<embed id="player" src="' + config['basearW'] + 'hdplayer.swf" ';
				if (config['ref'].root.loaderInfo.parameters['baserefW'])embedCode +=  'flashvars="file=' + config['file'] + '&baserefW=' + config['ref'].root.loaderInfo.parameters['baserefW'] + '&autoplay=false&playlist_auto=false';
				else embedCode +=  'flashvars="file=' + config['file'] + '&baserefWP=' + config['ref'].root.loaderInfo.parameters['baserefWP'] + '&autoplay=false&playlist_auto=false';
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
			else if (config['ref'].root.loaderInfo.parameters['baserefJ'] || config['ref'].root.loaderInfo.parameters['baserefJHDV'])
			{
				if(config['ref'].root.loaderInfo.parameters['baserefJHDV'])
				{
					embedCode = '<embed id="player" src="' + config['ref'].root.loaderInfo.parameters['baserefJHDV'] + '/components/com_contushdvideoshare/hdflvplayer/hdplayer.swf" ';
				    embedCode +=  'flashvars="baserefJHDV=' + config['ref'].root.loaderInfo.parameters['baserefJHDV'] + '&playlist_auto=false';
				}
				else
				{
					embedCode = '<embed id="player" src="' + config['ref'].root.loaderInfo.parameters['baserefJ'] + '/components/com_hdflvplayer/hdflvplayer/hdplayer.swf" ';
				    embedCode +=  'flashvars="baserefJ=' + config['ref'].root.loaderInfo.parameters['baserefJ'] + '&playlist_auto=false';
				}
				if(config['ref'].root.loaderInfo.parameters['playid']) embedCode += "&playid=" + config['ref'].root.loaderInfo.parameters['playid']
				if(config['ref'].root.loaderInfo.parameters['id']) embedCode += "&id=" + config['ref'].root.loaderInfo.parameters['id']
				if(config['ref'].root.loaderInfo.parameters['mid']) embedCode += "&mid=" + config['ref'].root.loaderInfo.parameters['mid']
				if(config['ref'].root.loaderInfo.parameters['compid']) embedCode += "&compid=" + config['ref'].root.loaderInfo.parameters['compid']
				if(config['ref'].root.loaderInfo.parameters['jlang']) embedCode += "&lang="+ config['ref'].root.loaderInfo.parameters['jlang']
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
			bookmark = "https://plus.google.com/share?url="+escape(config['SocialPanel'].pMc.pageurl.text)
			//bookmark = "https://plusone.google.com/_/+1/confirm?hl=ru&url=" + escape(config['SocialPanel'].pMc.pageurl.text) + "&message=" + escape(config['title'])+"&content="+escape(config['SocialPanel'].pMc.pageurl.text);
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