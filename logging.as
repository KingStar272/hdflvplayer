package
{
	 import flash.external.ExternalInterface;
	
	public class logging 
	{
		private var  theAction,eventTrack,theCategory,theLabel,theValue,theCall;
		
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
			}
			//tracer.text = action;
		}
		function trackGAEvent(category:String, action:String,  optional_label:String, optional_value:Number) 
		{
			theCategory = "'" + category;
			theAction = "', '" + action + "'";
			//theLabel = (optional_label == null) ? "" : ", '" + optional_label + "'";
			
			
			theLabel = (optional_label == null) ? ",''," : ", '" + optional_label + "',";
			//theValue = (optional_value == 0) ? "" : ", " + optional_value;
			//theValue = (optional_value == undefined) ? undefined :optional_value;
			theCall = "pageTracker._trackEvent(" + theCategory + theAction + theLabel + optional_value + ")";
			ExternalInterface.call(theCall);
			//tracer.text = theCategory + theAction + theLabel + theValue;
		}
	}
}