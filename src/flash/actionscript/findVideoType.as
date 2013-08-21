package actionscript
{
	import flash.display.Sprite;
	import flash.external.*;
	import flash.net.*;
	public class findVideoType
	{
		private var adindex:Number;
		private var reference:Sprite;
		private var config:Object;
		private var playvideo:playVideo;
		private var preview:Preview;

		public function findVideoType(ref,cfg)
		{
			reference = ref;
			config = cfg;
			vidcon();
		}
		private function vidcon()
		{
			// ================================== find video type(preroll or mainvideo or postroll)====================================== 
			switch (config['mov'])
			{
				case 1 :
					if (config['allowpreroll'] == "true")
					{
						adindexcnt();
						pread();
					}
					else
					{
						config['mov']++;
						vidcon();
					}
					break;
				case 2 :
					config['buffer_Mc'].visible = true;
					playvideo = new playVideo(config,reference);
					playvideo.playFun();
					break;
				case 3 :
					if (config['allowpostroll'] == "true")
					{
						adindexcnt();
						postread();
					}
					else
					{
						postclosed();
					}
					break;
			}
		}
		// ===================================get ads Id for the specific video ====================================
		private function adindexcnt()
		{
			if (config['mov'] == 1)
			{
				if (reference.root.loaderInfo.parameters['pre_id'])
				{
					config['pread_id'] = reference.root.loaderInfo.parameters['pre_id'];
				}
				else
				{
					config['pread_id'] = config['preroll_id'][config['vid']];
				}
			}
			else
			{
				if (reference.root.loaderInfo.parameters['post_id'])
				{
					config['postad_id'] = reference.root.loaderInfo.parameters['post_id'];
				}
				else
				{
					config['postad_id'] = config['postroll_id'][config['vid']];
				}
			}
			if (config['adrandom'] == "true")
			{
				adindex = Math.round(Math.random() * (config['adsUrlArr'].length));
				config['adindex'] = adindex;
				return;
			}
			else
			{
				for (var _aid=0; _aid < config['adslistlength']; _aid++)
				{
					if (config['mov'] == 1 && (config['pread_id'] == config['ads_IdArr'][_aid]))
					{
						adindex = _aid;
						config['adindex'] = adindex;
						return;
					}
					else if (config['mov'] == 3 && (config['postad_id'] == config['ads_IdArr'][_aid]))
					{
						adindex = _aid;
						config['adindex'] = adindex;
						return;
					}
				}

			}
			if (adindex >config['adsUrlArr'].length)
			{
				config['adindex'] = 0;
				adindex = 0;
			}
		}
		// ===================================== get pre roll ads values =============================================================
		function pread()
		{
			//config['streamer'] = ""; 
			var file:String = "";
			if (reference.root.loaderInfo.parameters['pre-rollad'])
			{
				file = reference.root.loaderInfo.parameters['pre-rollad'];
			}
			else
			{
				file = config['adsUrlArr'][adindex];
			}
			if (reference.root.loaderInfo.parameters['pre-rolltrageturl'])
			{
				config['adtarget'] = reference.root.loaderInfo.parameters['pre-rolltrageturl'];
			}
			else
			{
				config['adtarget'] = config['adsTargetArr'][adindex];
			}
			if (reference.root.loaderInfo.parameters['pre-rollclickurl'])
			{
				config['adclickurl'] = reference.root.loaderInfo.parameters['pre-rollclickurl'];
			}
			else
			{
				config['adclickurl'] = config['adsClickArr'][adindex];
			}
			if (reference.root.loaderInfo.parameters['pre-rollimpressionurl'])
			{
				config['adimpressionurl'] = reference.root.loaderInfo.parameters['pre-rollimpressionurl'];
			}
			else
			{
				config['adimpressionurl'] = config['adsImpressionArr'][adindex];
			}
			if (reference.root.loaderInfo.parameters['adhits'])
			{
				config['adhitsurl'] = reference.root.loaderInfo.parameters['adhits'];
			}
			else
			{
				config['adhitsurl'] = config['adsHitsArr'][adindex];
			}
			if (reference.root.loaderInfo.parameters['impressionhits'])
			{
				config['impressionhits'] = reference.root.loaderInfo.parameters['impressionhits'];
			}
			else
			{
				config['impressionhits'] = config['adsImpressionHitsArr'][adindex];
			}
			if (reference.root.loaderInfo.parameters['ads_Id'])
			{
				config['ads_Id'] = reference.root.loaderInfo.parameters['ads_Id'];
			}
			else
			{
				config['ads_Id'] = config['ads_IdArr'][adindex];
			}
			if ( file == null)
			{
				config['mov']++;
				vidcon();
			}
			else
			{
				config['file'] = file;
				playvideo = new playVideo(config,reference);
				playvideo.playFun();
			}
		}
		// ===================================== get post roll ads values =============================================================
		function postread()
		{
			var pfile:String = "";
			if (reference.root.loaderInfo.parameters['postrollad'])
			{
				pfile = reference.root.loaderInfo.parameters['postrollad'];
			}
			else
			{
				pfile = config['adsUrlArr'][adindex];
			}
			if (reference.root.loaderInfo.parameters['postrolltargeturl'])
			{
				config['adtarget'] = reference.root.loaderInfo.parameters['postrolltargeturl'];
			}
			else
			{
				config['adtarget'] = config['adsTargetArr'][adindex];
			}
			if (reference.root.loaderInfo.parameters['postrollclickurl'])
			{
				config['adclickurl'] = reference.root.loaderInfo.parameters['postrollclickurl'];
			}
			else
			{
				config['adclickurl'] = config['adsClickArr'][adindex];
			}
			if (reference.root.loaderInfo.parameters['postrollimpressionurl'])
			{
				config['adimpressionurl'] = reference.root.loaderInfo.parameters['postrollimpressionurl'];
			}
			else
			{
				config['adimpressionurl'] = config['adsImpressionArr'][adindex];
			}
			if (reference.root.loaderInfo.parameters['adhits'])
			{
				config['adhitsurl'] = reference.root.loaderInfo.parameters['adhits'];
			}
			else
			{
				config['adhitsurl'] = config['adsHitsArr'][adindex];
			}
			if (reference.root.loaderInfo.parameters['impressionhits'])
			{
				config['impressionhits'] = reference.root.loaderInfo.parameters['impressionhits'];
			}
			else
			{
				config['impressionhits'] = config['adsImpressionHitsArr'][adindex];
			}
			if (reference.root.loaderInfo.parameters['ads_Id'])
			{
				config['ads_Id'] = reference.root.loaderInfo.parameters['ads_Id'];
			}
			else
			{
				config['ads_Id'] = config['ads_IdArr'][adindex];
			}
			if ( pfile == null)
			{
				postclosed();
			}
			else
			{
				config['file'] = pfile;
				playvideo = new playVideo(config,reference);
				playvideo.playFun();
			}
		}
		//=============================== closed post roll ads and play next video ================================================
		function postclosed()
		{
			config['mov'] = 1;
			if (config['playlist_autoplay'] == "true")
			{
				config['vid']++;
				if (config['vid'] >= config['plistlength'])
				{
					config['vid'] = 0;
				}
				config['fbpath'] = config['fbpath_arr'][config['vid']];
				if(String(config['fbpath']) != undefined && String(config['fbpath']) != "" && config['mtype'] != "playerModule")
				{
					navigateToURL(new URLRequest(config['fbpath']), '_self');
					return;
				}
				else var getVidData = new getinitialvidData(reference,config);
			}
			else if (config['relatedVideoView'] == 'center')
			{
				config['imageCount'] = 0;
				config['numofimg'] = 0;
				if (config['embedplayer'] != "true")
				{
					var relatedvideo = new relatedVideo(config,reference);
					relatedvideo.loadrelatedvideos(config);
				}
				config['skinMc'].pp.pause_btn.visible = false;
				config['skinMc'].pp.play_btn.visible = false;
				config['skinMc'].pp.Replay.visible = true;
				preview = new Preview(reference,config);
				preview.loadPreview();
			}
			else
			{
				var getVidData2 = new getinitialvidData(reference,config);
				config['skinMc'].pp.pause_btn.visible = false;
				config['skinMc'].pp.play_btn.visible = false;
				config['skinMc'].pp.Replay.visible = true;
			}
		}
	}
}