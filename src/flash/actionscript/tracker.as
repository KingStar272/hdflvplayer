package actionscript
{

	import flash.display.*;
	import flash.text.*;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;

	public class tracker extends MovieClip
	{
		private var trackerG:AnalyticsTracker;
		private var config:Object;
		private var reference:Sprite;

		public function tracker(cfg,ref)
		{
			config = cfg;
			reference = ref;
		}
		public function trackPage()
		{
			if (config['embedplayer'] != "true" && config['local'] != "true")
			{
				trackerG = new GATracker(reference,config['trackCode'],"AS3",false);
				trackerG.trackPageview("/hdflvplayer/");
			}
		}
		public function eventTracker(page:String,act:String,fun:String,numm:Number)
		{
			if (String(config['trackCode'])!="" && config['embedplayer'] != "true" && config['local'] != "true")
			{
				trackerG = new GATracker(reference,config['trackCode'],"AS3",false);
				trackerG.trackEvent(page,act,fun,numm);
			}
		}
	}
}