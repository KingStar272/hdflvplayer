package actionscript
{
	import flash.display.*;
	import flash.text.*;
	import flash.media.*;
	import flash.external.*;
	import flash.geom.ColorTransform;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import fl.transitions.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.system.System;
	import flash.text.TextFieldAutoSize;

	public class playerUi extends MovieClip
	{
		//======================= create object and movie clip name for player elements ============================================================== 
		private var galMc:gal;
		private var dailyBG:dailyBg;
		private var nopreviewMc:nopreview;
		private var cont:DisplayObjectContainer;
		private var logoMC:logoMc;
		private var adIndicator:adindicator;
		private var labelBt:labelMc;
		private var buffer_Mc:Buffer_mc;
		public var config:Object;
		public var logocon:MovieClip;
		private var logowidth:Number;
		private var logoheight:Number;
		private var Playbtn:play_btn;
		private var wid:Number;
		private var hei:Number;
		private var vidclose:MovieClip;
		private var tooltipMc:MovieClip;
		private var Textcolor:Number;
		private var Lbt:lbt;
		private var Rbt:rbt;
		private var mailcloseBt:clsbt;
		private var midRoll:midMC;
		private var tagline:captionMc;
		private var adv:adV;
		private var slideRelatedVideo:sliderelatedVideo;
		private var thuMc:thu;
		private var SkipIma:skipIma;
		private var MessageClass:Message;
		private var QualityBg:qualityBg;
		private var scrollbarVerticalMc:mcScrollbar;
		private var clikB:Boolean;
		private var MailPanel:mailMc;
		private var SocialPanel:socialBg;
		private var buttonS:MovieClip;
		private var SubMc:subMc;
		private var yclip:MovieClip;
		private var yt_logo:ytlogo;

		public function playerUi(Cont,cfg)
		{
			wid = cfg['stageWidth'];
			hei = cfg['stageHeight'];
			config = cfg;
			cont = Cont;
			clikB = false;
		}
		//======================= add player clips====================================== ============================================================== 
		public function addUi(cfg):void
		{
			
			if (cfg['stagecolor'] == undefined)
			{
				cfg['stagecolor'] = "0x000000";
			}
			changeColor(cfg['backBg'],cfg['stagecolor']);
			cfg['backBg'].tabEnabled = false;
			
			dailyBG = new dailyBg();
			cont.addChild(dailyBG);
			cfg['dailyBG'] = dailyBG;
			cfg['dailyBG'].visible = false;
			dailyBG.tabEnabled = false;
			dailyBG.name = "vvv"
			
			yclip = new MovieClip()
			cont.addChild(yclip)
			cfg['yclip'] = yclip
			
			Playbtn = new play_btn();
			cont.addChild(Playbtn);
			Playbtn.name = "PLAY";
			cfg['Playbtn'] = Playbtn;
			Playbtn.visible = false;
			Playbtn.tabEnabled = false;
			
			logocon = new MovieClip();
			cont.addChild(logocon);
			logocon.tabEnabled = false;
			logocon.alpha = 0;
			logocon.buttonMode = true;
			logocon.tabEnabled = false;
			cfg['logocon'] = logocon;

			Playbtn.x  = wid / 2;
			Playbtn.y  = (hei - 25) / 2;

			adIndicator = new adindicator();
			adIndicator.visible = false;
			cont.addChild(adIndicator);
			cfg['adIndicator'] = adIndicator;
			adIndicator.tabEnabled = false;
			
			labelBt = new labelMc();
			labelBt.visible = false;
			cont.addChild(labelBt);
			cfg['labelBt'] = labelBt;
			labelBt.tabEnabled = false;
			
			Lbt = new lbt();
			cont.addChild(Lbt);
			cfg['Lbt'] = Lbt;
			cfg['Lbt'].visible = false;
			Lbt.tabEnabled = false;
			
			Rbt = new rbt();
			cont.addChild(Rbt);
			cfg['Rbt'] = Rbt;
			cfg['Rbt'].visible = false;
			Rbt.tabEnabled = false;
			
			buttonS = new MovieClip();
			cont.addChild(buttonS);
			cfg['shareMc'] = buttonS;
			cfg['shareMc'].visible=false
			
			buttonS = new MovieClip();
			cont.addChild(buttonS);
			cfg['zoomInMc'] = buttonS;
			cfg['zoomInMc'].visible=false
			
			buttonS = new MovieClip();
			cont.addChild(buttonS);
			cfg['zoomOutMc'] = buttonS;
			cfg['zoomOutMc'].visible=false
			
			buttonS = new MovieClip();
			cont.addChild(buttonS);
			cfg['downloadMc'] = buttonS;
			cfg['downloadMc'].visible=false
			
			buttonS = new MovieClip();
			cont.addChild(buttonS);
			cfg['mailIcon'] = buttonS;
			cfg['mailIcon'].visible=false
			
			SubMc = new subMc();
			cont.addChild(SubMc);
            cfg['SubMc'] = SubMc;
			cfg['SubMc'].visible =false;
						
			
			MailPanel = new mailMc();
			cont.addChild(MailPanel);
			cfg['mailPanel'] = MailPanel;
			cfg['mailPanel'].visible = false;
			cfg['mailPanel'].form.from.tabIndex = 1;
			cfg['mailPanel'].form.to.tabIndex = 2;
			cfg['mailPanel'].form.Note.tabIndex = 3;
			cfg['mailPanel'].form.bt.tabIndex = 4;
			cfg['mailPanel'].form.from.tabIndex = 1;
			cont.dispatchEvent(new Event('focus'));
			config['mailPanel'].form.starmcc.visible =false
			
			mailcloseBt = new clsbt();
			cont.addChild(mailcloseBt);
			cfg['mailcloseBt'] = mailcloseBt;
			cfg['mailcloseBt'].visible = false;
			mailcloseBt.tabEnabled = false

			SocialPanel = new socialBg();
			cont.addChild(SocialPanel);
			cfg['SocialPanel'] = SocialPanel;
			cfg['SocialPanel'].visible = false;
			if (cfg['embed_visible'] == "false")
			{
				cfg['SocialPanel'].bgg.gotoAndStop(2);
				cfg['SocialPanel'].shadowBg.gotoAndStop(2);
				cfg['SocialPanel'].embedtext.visible = cfg['SocialPanel'].emb.visible = false;
			}
			cfg['SocialPanel'].ifra.visible = cfg['SocialPanel'].iframetext.visible = false
			//cfg['SocialPanel'].bgg.gotoAndStop(3);
			//cfg['SocialPanel'].shadowBg.gotoAndStop(3);
			if (String(config['sharepanel_up_BgColor']) != "" && config['sharepanel_up_BgColor'] != undefined)
			{
				changeColor(cfg['SocialPanel'].bgg.up_bg,cfg['sharepanel_up_BgColor']);
				changeColor(cfg['mailPanel'].bgg.up_bg,cfg['sharepanel_up_BgColor']);
				changeColor(config['errorMc'].bg2,cfg['sharepanel_up_BgColor']);
			}
			if (String(config['sharepanel_down_BgColor']) != "" && config['sharepanel_down_BgColor'] != undefined)
			{
				changeColor(cfg['SocialPanel'].bgg.down_bg,cfg['sharepanel_down_BgColor']);
				changeColor(cfg['mailPanel'].bgg.down_bg,cfg['sharepanel_down_BgColor']);
				changeColor(config['errorMc'].bg,cfg['sharepanel_down_BgColor']);
			}
			if (String(config['sharepanel_textBgColor']) != "" && config['sharepanel_textBgColor'] != undefined)
			{
				cfg['SocialPanel'].bgg.textBg.alpha =1;
				cfg['mailPanel'].bgg.textBg.alpha =1
				changeColor(cfg['SocialPanel'].bgg.textBg,cfg['sharepanel_textBgColor']);
				changeColor(cfg['mailPanel'].bgg.textBg,cfg['sharepanel_textBgColor']);
			}
			if (String(config['sendButtonColor']) != "" && config['sendButtonColor'] != undefined)
			{
				changeColor(config['mailPanel'].form.send.bg,cfg['sendButtonColor']);
				changeColor(config['errorMc'].buyButton.bg,cfg['sendButtonColor']);
			}
            if (String(config['sharepaneltextColor']) != "")
			{
				config['SocialPanel'].pMc.pageurl.textColor = config['sharepaneltextColor'];
				config['SocialPanel'].socialtext.textColor = config['sharepaneltextColor'];
				config['SocialPanel'].linktext.textColor = config['sharepaneltextColor'];
				config['SocialPanel'].embedtext.textColor = config['sharepaneltextColor'];
				config['SocialPanel'].emb.embedurl.textColor = config['sharepaneltextColor'];
				config['SocialPanel'].iframetext.textColor = config['sharepaneltextColor'];
				config['SocialPanel'].ifra.embedurl.textColor = config['sharepaneltextColor'];
			}
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
				config['errorMc'].buyButton.txt.textColor = config['sendButtonTextColor'];
			}
			cfg['downloadMc'].visible = cfg['shareMc'].visible = cfg['zoomInMc'].visible = cfg['zoomOutMc'].visible = false;

			if (String(config['playButtonColor']) != "" && config['playButtonColor'] != undefined)
			{
				changeColor(config['Playbtn'].iconMc,config['playButtonColor']);
			}
			else if (config['skincolor'] != undefined)
			{
				changeColor(config['Playbtn'].iconMc,config['skincolor']);
			}
			if (String(config['playButtonBgColor']) != "" && config['playButtonBgColor'] != undefined)
			{
				changeColor(config['Playbtn'].bg,config['playButtonBgColor']);
			}
			if(config['skin_opacity'] != "" && config['skin_opacity'] != undefined)
			{
				//config['Playbtn'].bg.alpha = config['skin_opacity']
			}
			midRoll = new midMC();
			midRoll.y = config['stageHeight']+ (midRoll.height+50) ;
			midRoll.visible = false;
			cont.addChild(midRoll);
			config['midRoll'] = midRoll;
			midRoll.lnk.width = midRoll.midbg.width = cfg['stageWidth'] / 1.8;
			midRoll.lnk.height = midRoll.midbg.height = cfg['stageHeight'] / 6.2;
			midRoll.msk.width = midRoll.midbg.width-25
			midRoll.msk.height = midRoll.midbg.height
			midRoll.midnxt.x = midRoll.midprev.x = midRoll.close.x = (cfg['stageWidth'] / 1.8)-12;
			midRoll.x = (config['stageWidth']/2)-(config['midRoll'].midbg.width/2);
			midRoll.buttonMode = true;

			midRoll.tabEnabled = false;
			adv = new adV();
			adv.visible = false;
			cont.addChild(adv);
			config['adv'] = adv;
			adv.tabEnabled = false;
			if (config['showTag'] == "true")
			{
				tagline = new captionMc();
				cont.addChild(tagline);
				tagline.visible = false;
				config['tagline'] = tagline;
			}
			yt_logo = new ytlogo()
			cont.addChild(yt_logo);
			yt_logo.visible = false;
			config['yt_logo'] = yt_logo;
			

			thuMc=new thu();
			cont.addChild(thuMc);
			thuMc.visible = false;
			config['thuMc'] = thuMc;
			scrollbarVerticalMc = new mcScrollbar();
			thuMc.addChild(scrollbarVerticalMc);
			config['scrollbarVerticalMc'] = scrollbarVerticalMc;

			QualityBg = new qualityBg();
			QualityBg.visible = false;
			cont.addChild(QualityBg);
			cfg['QualityBg'] = QualityBg;
			cfg['QualityBg'].name = "QA"
			
			QualityBg = new qualityBg();
			QualityBg.visible = false;
			cont.addChild(QualityBg);
			cfg['subTiltleBg'] = QualityBg;
			cfg['subTiltleBg'].name = "ST"
			
			
			cfg['mailIcon'].scaleX = cfg['zoomInMc'].scaleX = cfg['zoomOutMc'].scaleX = cfg['shareMc'].scaleX = cfg['downloadMc'].scaleX = 1;
			cfg['mailIcon'].scaleY = cfg['zoomInMc'].scaleY = cfg['zoomOutMc'].scaleY = cfg['downloadMc'].scaleY = cfg['shareMc'].scaleY = 1;

			setPos(cfg);

			tooltipMc = new toolTipMc();
			tooltipMc.visible = false;
			cont.addChild(tooltipMc);
			cfg['tooltipMc'] = tooltipMc;
			config = cfg;
		}
		public function addAdsSkip(cf)
		{
			SkipIma = new skipIma();
			cont.addChild(SkipIma);
			if (config['videoMc'].x > 0)
			{
				SkipIma.x = config['videoMc'].x + config['videoMc'].width;
			}
			else
			{
				SkipIma.x = cf['stageWidth'];
			}
			SkipIma.y = config['videoMc'].y + SkipIma.height;
			cf['SkipIma'] = SkipIma;
		}
		public function removeSkipAds(cfgg)
		{
			config['SkipIma'].visible = false
			if (cfgg['SkipIma'])
			{
				cont.removeChild(cfgg['SkipIma']);
			}
			config['adsLoader'] = undefined
		}//========================================== set position for player movieclips ============================================================== 
		public function setPos(conf):void
		{
			config = conf;
			if (config['backBg'] != null && Playbtn!= null && logocon != null)
			{
				wid = conf['stageWidth'];
				hei = conf['stageHeight'];
				config['backBg'].x = config['backBg'].y = 0;
				conf['dailyBG'].width = config['backBg'].width = wid;
				config['backBg'].height = hei;
				conf['dailyBG'].height = hei - 110;
				seiLogpPos();
			}
			//========================================== set position for Preview image ============================================================== 
			if (config['preval'] == true)
			{
				config['shareMc'].alpha = config['zoomOutMc'].alpha = config['zoomInMc'].alpha = config['downloadMc'].alpha = 0;
				var scaleratio = wid / hei;
				if (config["displayState"] == "normal")
				{
					config['videoscale'] = config['normalscale'];
				}
				if (config["displayState"] == "fullScreen")
				{
					config['videoscale'] = config['fullscreenscale'];
				}
				switch (String(config['videoscale']))
				{
						//Aspect ratio
					case "0" :
						if (config['vidscale'] > scaleratio)
						{
							config['precontainer'].width = wid;
							config['precontainer'].x = 0;
							config['precontainer'].height = config['org_height'] * config['precontainer'].width / config['org_width'];
							if ((hei/2)>(config['precontainer'].height/2))
							{
								config['precontainer'].y =(hei/2)-(config['precontainer'].height/2);
							}
							else
							{
								config['precontainer'].y =(config['precontainer'].height/2)-(hei/2);
							}
						}
						else
						{
							config['precontainer'].height = hei;
							config['precontainer'].scaleX = 100;
							config['precontainer'].width =(config['org_width'] * config['precontainer'].height / config['org_height'])-50;
							config['precontainer'].y = 0;
							if ((wid/2)>(config['precontainer'].width/2))
							{
								config['precontainer'].x =(wid/2)-(config['precontainer'].width/2);
							}
							else
							{
								config['precontainer'].x =(config['precontainer'].width/2)-(wid/2);
							}
						}
						break;
						//Original
					case "1" :
						config['precontainer'].width = config['org_width'];
						config['precontainer'].height = config['org_height'];
						config['precontainer'].x = (wid/2)-(config['org_width']/2);
						config['precontainer'].y = (hei/2)-(config['org_height']/2);
						break;
						//Fit to window
					case "2" :
						config['precontainer'].width = wid;
						config['precontainer'].height = hei;
						config['precontainer'].x = 0;
						config['precontainer'].y = 0;
						break;
				}
				config['w'] = config['precontainer'].width;
				config['h'] = config['precontainer'].height;
				config['x'] = config['precontainer'].x;
				config['y'] = config['precontainer'].y;
				if (config['showPlaylist'] == "true" && config['relatedVideoView'] == "side" && config['plistlength'] != 0)
				{
					config['thuMc'].visible = true;
					slideRelatedVideo = new sliderelatedVideo(config,cont);
					slideRelatedVideo.setrelatedposition();
					if (config['thuMc'].sh_hi.show.visible == true)
					{
						config['thuMc'].x = config['stageWidth'];
					}
					else
					{
						config['thuMc'].x = config['stageWidth'] - config['thuMc'].thubg.width;
					}
				}
			}
		}//========================================== set position for logo ============================================================== 
		function seiLogpPos()
		{
			if (config['license_Player'] == 'demo')
			{
				logocon.x = 5;
				logocon.y = config['stageHeight'] - (30 + config['logocon'].height);
				logocon.alpha = 1;
			}
			else
			{
				if (config['logoalign'] == "BL")
				{
					config['logocon'].x = 5;
					config['logocon'].y = config['stageHeight'] - (30 + config['logocon'].height);
				}
				else if (config['logoalign'] == "BR")
				{
					config['logocon'].x = config['stageWidth'] - (config['logocon'].width + 10);
					config['logocon'].y = config['stageHeight'] - (30 + config['logocon'].height);
				}
				else if (config['logoalign'] == 'TL')
				{
					config['logocon'].x = 15;
					config['logocon'].y = 22;
				}
				else if (config['logoalign'] == 'TR')
				{
					config['logocon'].x = config['stageWidth'] - (config['logocon'].width + 15);
					config['logocon'].y = 22;
				}
				else
				{
					config['logocon'].x = config['stageWidth'] / 2 - (config['logocon'].width / 2);
					config['logocon'].y = (config['stageHeight'] / 2) - (config['logocon'].height / 2);
				}
				config['logocon'].alpha = config['logoalpha'] / 100;
			}
		}
		public function changeColor(object:MovieClip, color:Number)
		{
			var colorchange:ColorTransform = new ColorTransform();
			colorchange.color = color;
			object.transform.colorTransform = colorchange;
		}
	}
}