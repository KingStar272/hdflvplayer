package actionscript
{
	import flash.external.*;
	public class getColor
	{
		private var config:Object;

		public function getColor(cfg)
		{
			config = cfg;
		}
		public function getSkinColor()
		{
			if (config['skin'].indexOf("blue") > -1)
			{
				config['skincolor'] = 0x00ADEF;
			}
			else if (config['skin'].indexOf("yellow") > -1)
			{
				config['skincolor'] = 0xF6D61E;
			}
			else if (config['skin'].indexOf("fancy_green") > -1)
			{
				config['skincolor'] = 0x00FF00;
			}
			else if (config['skin'].indexOf("green") > -1)
			{
				config['skincolor'] = 0x89BB04;
			}
			else if (config['skin'].indexOf("orange") > -1)
			{
				config['skincolor'] = 0xD3590C;
			}
			else
			{
				config['skincolor'] = 0xFFFFFF;
			}
			return config['skincolor'];
		}
	}
}