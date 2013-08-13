package script
{

	public class lighttpd
	{

		private var config:Object;
		public function lighttpd(cfg)
		{
			config = cfg;
		}
		public function getlighttpdUrl():String
		{
			config['off'] = config['pixelOffset'];
			if (config['mp4'])
			{
				config['off'] = config['timeOffset'];
			}
			if (config['file'].indexOf('start=') > -1)
			{
				var arrd:Array = config['file'].split('start=');
				config['file'] = arrd[0] + "start=" + config['off'];
			}
			else
			{
				if (config['file'].indexOf('?') > -1)
				{
					config['file'] +=  '&start=' + config['off'];
				}
				else
				{
					config['file'] +=  '?start=' + config['off'];
				}
			}
			if (! config['mp4'])
			{
				config['off'] = 0;
			}
			return config['file'];
		}
		public function scrubit()
		{
			config['isplayed'] = true;

			var tofind = Math.round(((config['ref'].mouseX-config['skinMc'].pro.x+5) / config['skinMc'].pro.width) * config['nDuration']);
			if (tofind <= 0)
			{
				config['file'] = getlighttpdUrl();
				config['stream'].play(config['file']);
				return;
			}
			if (config['keyframes'] != undefined)
			{
				for (var i= 0; i < config['keyframes'].times.length; i++)
				{
					var j = i + 1;
					if ((config['keyframes'].times[i] <= tofind) && (config['keyframes'].times[j] >= tofind))
					{
						config['timeOffset'] = config['keyframes'].times[i];
						trace(config['keyframes'].filepositions);
						if (config['keyframes'].filepositions != undefined)
						{
							config['pixelOffset'] = config['keyframes'].filepositions[i];
						}
						else if (config['keyframes'].positions!=undefined)
						{
							config['pixelOffset'] = config['keyframes'].positions[i];
						}
						config['buffer_Mc'].visible = true;
						config['file'] = getlighttpdUrl();
						config['stream'].play(config['file']);
						break;
					}
				}
			}
		}
	}
}