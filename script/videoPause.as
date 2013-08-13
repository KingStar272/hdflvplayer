package  script
{
	import flash.external.*;
	import fl.transitions.Tween;
    import fl.transitions.easing.*
	public class videoPause 
	{

		public function videoPause(config) 
		{
			if(config['preval'] == false || config['file'].indexOf('.mp3') > -1)
			{
				if(config['imA'] == false || config['AdsManagerTypes'] == "flash")
				{
					config['Playbtn'].visible = true;
				}
				config['skinMc'].pp.play_btn.visible = true;
				config['skinMc'].pp.pause_btn.visible = false;
				config['buffer_Mc'].alpha = 0
				if(config['currentTime'] !=0)
				{
					config['isplayed'] = false;
					if(config['video'] == "stream")
					{
						if(config['file'].indexOf('.mp3') > -1)
						{
							config['lastPosition'] = config['audioChannel'].position;
							config['audioChannel'].stop();
						}
						if(config['isLive'] == 'true')
						{
							config['stream'].close()
						}
						else
						{
							config['stream'].pause()
						}
					}
					else 
					{
						config['YTPlayer'].pauseVideo()
					}
				}
			}
		}

	}
	
}
 