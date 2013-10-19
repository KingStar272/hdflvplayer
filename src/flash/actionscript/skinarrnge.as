package actionscript
{
	import flash.display.StageQuality;
	import flash.external.*;
	public class skinarrnge
	{
		public function skinarrnge(config)
		{
			if(config['skinVisible'] != "false")
			{
				config['skinMc'].pro.progress_bg.width = config['stageWidth'];
				config['skinMc'].skin_bg.width = config['stageWidth'] + 3;
				if (config['skinout'] == false)
				{
					config['skinMc'].y = config['stageHeight']-(config['skinMc'].skin_bg.height);
				}
				var xposi = 11;
				var yposi = config['stageWidth'] - 13;
				config['skinMc'].pp.x = xposi;
				xposi = xposi + config['skinMc'].pp.width;
				if (config['showPlaylist'] != "false")
				{
					if (config['relatedVideoView'] == "center")
					{
						config['showPlaylistB'] = "true";
					}
					else
					{
						config['showPlaylistB'] = "false";
					}
				}
				else
				{
					config['showPlaylistB'] = "false";
				}
				if (config['timer'] != "false")
				{
					config['skinMc'].ti.x = xposi;
					xposi = xposi + config['skinMc'].ti.width + 8;
				}
				else
				{
					config['skinMc'].ti.visible = false;
				}
				if (config['fullscreen'] != "false")
				{
					yposi = yposi - (config['skinMc'].FullScreen.width-4);
					config['skinMc'].FullScreen.x = yposi;
				}
				else
				{
					config['skinMc'].FullScreen.visible = false;
				}
				if (config['volumecontrol'] != "false")
				{
					if (config['fullscreen'] != "false")
					{
						yposi = yposi - (config['skinMc'].Volume.width+3);
					}
					else
					{
						yposi = yposi - (config['skinMc'].Volume.width-12);
					}
					config['skinMc'].Volume.x = yposi;
				}
				else
				{
					config['skinMc'].Volume.visible = false;
				}
				config['yposi'] = yposi;
				if (config['hd'] != "false" && config['mov'] == 2)
				{
					yposi = yposi - (config['skinMc'].hd.width+11);
					config['skinMc'].hd.x = yposi;
					config['skinMc'].hd.visible = true;
				}
				else
				{
					config['skinMc'].hd.visible = false;
				}
				if (config['cc'] != "false" && config['mov'] == 2)
				{
					yposi = yposi - (config['skinMc'].cc.width+11);
					config['skinMc'].cc.x = yposi;
					config['skinMc'].cc.visible = true;
					config['skinMc'].cc.buttonMode = true;
				}
				else
				{
					config['skinMc'].cc.visible = false;
				}
				if (config['playlist_auto'] == "true")
				{
					if (config['hd'] != "false" && config['mov'] == 2)
					{
						yposi = yposi - (config['skinMc'].autoPlayButton.width+8);
					}
					else
					{
						yposi = yposi - (config['skinMc'].autoPlayButton.width+11);
					}
					config['skinMc'].autoPlayButton.x = yposi;
				}
				else
				{
					config['skinMc'].autoPlayButton.visible = false;
				}
				if (config['showPlaylistB'] != "false")
				{
					yposi = yposi - (config['skinMc'].PlayListView.width+6);
					config['skinMc'].PlayListView.x = yposi;
				}
				else
				{
					config['skinMc'].PlayListView.visible = false;
				}
	
				if (config['timer'] != "false")
				{
					config['skinMc'].ti2.x=yposi-(config['skinMc'].ti2.width-1);
					yposi = yposi - config['skinMc'].ti2.width;
					xposi = xposi + 5;
				}
				else
				{
					config['skinMc'].ti2.visible = false;
				}
				if (config['timer'] == "false")
				{
					xposi = xposi + 10;
				}
				config['skinMc'].pro.x = xposi;
				if (config['progressControl'] == "false" || config['isLive'] == "true")
				{
					config['skinMc'].pro.visible = false;
				}
				else if(config['mov'] == 2) config['skinMc'].pro.visible = true;
				if (config['timer'] == "false")
				{
					config['skinMc'].pro.bar.visible = true;
					if(yposi - (xposi + 18)>10){config['skinMc'].pro.progress_bg.width = yposi - (xposi + 18);}
					else {config['skinMc'].pro.visible = false;}
					config['skinMc'].pro.bar.x = config['skinMc'].pro.progress_bg.width + 10;
				}
				else
				{
					if (config['timer'] != "false" && config['nDuration'] > 3599)
					{
						config['skinMc'].ti2.x = config['skinMc'].ti2.x - 4;
					}
					if(yposi-(xposi+config['skinMc'].ti2.width-26)>10){config['skinMc'].pro.progress_bg.width  = yposi-(xposi+config['skinMc'].ti2.width-26);}
					else{ config['skinMc'].pro.visible = false;}
				}
				config['ProgbarWidth'] = config['skinMc'].pro.progress_bg.width;
				config['skinMc'].pro.seek_end.x = config['skinMc'].pro.seek_bar.x + config['skinMc'].pro.seek_bar.width;
				config['skinMc'].pro.buffer_end.x = config['skinMc'].pro.buffer_bar.x + config['skinMc'].pro.buffer_bar.width;
				config['skinMc'].pro.bg_end.x = config['skinMc'].pro.progress_bg.x + config['skinMc'].pro.progress_bg.width;
				config['skinMc'].pro.seek_end.alpha = config['skinMc'].pro.buffer_end.alpha = config['skinMc'].pro.bg_end.alpha = 1;
			}
			else 
			{
				config['skinMc'].ti.visible = false;
				config['skinMc'].ti2.visible = false;
				config['skinMc'].pro.visible = false;
				config['skinMc'].PlayListView.visible = false;
				config['skinMc'].autoPlayButton.visible = false;
				config['skinMc'].hd.visible = false;
				config['skinMc'].Volume.visible = false;
				config['skinMc'].FullScreen.visible = false;
				config['skinMc'].pp.visible = false;
				config['skinMc'].skin_bg.visible = false;
			}
		}
	}
}