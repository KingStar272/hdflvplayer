package actionscript
{
	import flash.external.*;
	public class getvideoData
	{

		private var arr:Array;
		private var bArr:Array;
		private var id:Number;

		public function getvideoData(config)
		{
			if (! config['playeruI'].root.loaderInfo.parameters['file'] && ! config['playeruI'].root.loaderInfo.parameters['hdpath'])
			{
				config['vid_id'] = config['video_id'][config['vid']];

				if (config['Download'] == 'true')
				{
					if(config['playeruI'].root.loaderInfo.parameters['allow_download'] == 'true')config['PDownload'] = 'true'
					else config['PDownload'] = config['allow_download'][config['vid']];
				}
				else
				{
					config['PDownload'] = 'false';

				}
				if (config['midroll_ads'] == "true")
				{
					config['allowmidroll'] = config['allow_midroll'][config['vid']];
				}
				else
				{
					config['allowmidroll'] = 'false';

				}
				if (config['imaAds'] == 'true')
				{
					config['allow_imaAds'] = config['allow_ima'][config['vid']];
				}
				else
				{
					config['allow_imaAds'] = 'false';

				}
				if (config['preroll_ads'] == 'true')
				{
					config['allowpreroll'] = config['allow_preroll'][config['vid']];
				}
				else
				{
					config['allowpreroll'] = 'false';

				}
				if (config['postroll_ads'] == 'true')
				{
					config['allowpostroll'] = config['allow_postroll'][config['vid']];
				}
				else
				{
					config['allowpostroll'] = 'false';

				}
				config['thumb'] = config['thumb_image'][config['vid']];
				config['streamer'] = config['streamer_path'][config['vid']];
				config['preview'] = config['preview_image'][config['vid']];
				config['copylink'] = config['disply_copylink'][config['vid']];
				config['isLive'] = config['video_isLive'][config['vid']];
				config['title'] = config['video_title'][config['vid']];
				config['fbpath'] = config['fbpath_arr'][config['vid']];
				config['uid'] = config['uid_arr'][config['vid']];
				config['member'] = config['member_arr'][config['vid']];
			}
			else
			{
				config['showPlaylist'] = "false"
				if (config['playeruI'].root.loaderInfo.parameters['pre-roll_ads'] && config['preroll_ads'] == 'true')
				{
					config['allowpreroll'] = config['playeruI'].root.loaderInfo.parameters['pre-roll_ads'];
				}
				else
				{
					config['allowpreroll'] = 'false';

				}
				if (config['playeruI'].root.loaderInfo.parameters['post-roll_ads'] && config['postroll_ads'] == 'true')
				{
					config['allowpreroll'] = config['playeruI'].root.loaderInfo.parameters['post-roll_ads'];
				}
				else
				{
					config['allowpostroll'] = 'false';

				}
				if (config['playeruI'].root.loaderInfo.parameters['mid-roll_ads'] && config['midroll_ads'] == 'true')
				{
					config['allowmidroll'] = config['playeruI'].root.loaderInfo.parameters['mid-roll_ads'];
				}
				else
				{
					config['allowmidroll'] = 'false';

				}
				if (config['playeruI'].root.loaderInfo.parameters['allow_imaAds'] && config['imaAds'] == 'true')
				{
					config['allow_imaAds'] = config['playeruI'].root.loaderInfo.parameters['allow_imaAds'];
				}
				else
				{
					config['allow_imaAds'] = 'false';
				}
			}
			if(config['embedplayer'] != "true")
			{
				var thumb:String;
				if (config['ref'].root.loaderInfo.parameters['thumb'])
				{
					thumb = config['ref'].root.loaderInfo.parameters['thumb'];
				}
				else if (config['plistlength'] != 0)
				{
					thumb = config['thumb_image'][config['vid']];
				}
				if (thumb == "")
				{
					thumb = "images/default_thumb.jpg";
				}
				if (thumb != null && (thumb.indexOf('http') > -1 || thumb.indexOf('https') > -1))
				{
					thumb = thumb;
				}
				else
				{
					thumb = config['baseurl'] + "" + thumb;
				}
				thumb = decodeURI(thumb);
				var video_des:String;
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
				if(config['local'] != 'true')
				{
					if(config['autoplay'] == 'false' && config['mov'] == 1)
					{
						ExternalInterface.call('videoDetails',config['title'],thumb,video_des);
						ExternalInterface.call('videoData',config['vid_id'],config['title']);
					}
					else if(config['mov'] == 1)
					{
						ExternalInterface.call('videoDetails',config['title'],thumb,video_des);
						ExternalInterface.call('videoData',config['vid_id'],config['title']);
					}
				}
			}
		}
		private function shuffle(a,b):int
		{
			var num = Math.round(Math.random() * 2 - 1);
			return num;
		}
	}
}