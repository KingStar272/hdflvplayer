package actionscript
{

	import flash.external.*;
	public class videoPlay
	{
		private var Tracker:tracker;
		public function videoPlay(config)
		{
			if (config['preval'] == false || config['file'].indexOf('.mp3') > -1 || config['file'].indexOf('.m4a') > -1)
			{
				config['isplayed'] = true;
				config['Playbtn'].visible = config['skinMc'].pp.play_btn.visible = false;
				config['skinMc'].pp.pause_btn.visible = true;
				Tracker = new tracker(config,config['ref']);
				Tracker.eventTracker("Play_video","Play","Play_btn",0);
				if (config['video'] == "stream")
				{
					if (config['file'].indexOf('.mp3') > -1)
					{
						config['audioChannel'] = config['audio'].play(config['lastPosition']);
					}
					else if(config['file'].indexOf('.f4m') > -1 || config['file'].indexOf('.m3u8') > -1)
					{
						if(config['HLSandHDSstream'])config['HLSandHDSstream'].playFun()
					}
					else if (config['isLive'] == 'true')
					{
						config['stream'].close();
						config['stream'].play(config['file']);
					}
					else
					{
						config['stream'].resume();
					}
				}
				else
				{
					config['YTPlayer'].playVideo();
				}
			}
		}

	}

}