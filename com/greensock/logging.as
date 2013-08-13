package 
{
	 import flash.external.ExternalInterface;
	 import flash.display.MovieClip;
	
	public class logging 
	{
		private var  theAction,eventTrack,theCategory,theLabel,theValue,theCall;
		
		private var _container:DisplayObjectContainer;
		
		public function trackGA(categoryOrPageTrack:String, action:String, optional_label:String, optional_value:Number) 
		{
			if (categoryOrPageTrack == "page") 
			{
				trackGAPage(action);
			}
			else 
			{
				trackGAEvent(categoryOrPageTrack, action, optional_label, optional_value);
			}
		}
		var prefix:String = "flashGA";
		function trackGAPage(action:String) 
		{
			if (prefix != null && !eventTrack)
			{
				var call = "/" + prefix + "/" + action;
				ExternalInterface.call("urchinTracker('"+call+"')");
				ExternalInterface.call("pageTracker._trackPageview('"+call+"')");
				trace("==GATC==pageTracker._trackPageview('"+call+"')");
			}
			//root.tracer.text = action;
		}
		function trackGAEvent(category:String, action:String,  optional_label:String, optional_value:Number) 
		{
			theCategory = "'" + category;
			theAction = "', '" + action + "'";
			theLabel = (optional_label == null) ? "" : ", '" + optional_label + "'";
			//theValue = (optional_value == null) ? "" : ", " + optional_value;
			theCall = "pageTracker._trackEvent(" + theCategory + theAction + theLabel + theValue + ")";
			ExternalInterface.call(theCall);
			trace("====GATC===="+theCall);
			//root.tracer.text = theCategory + theAction + theLabel + theValue;
		}
	}
}