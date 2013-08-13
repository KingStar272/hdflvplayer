package script
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.xml.*;
	import flash.display.*;

	public class ImaXml
	{
		private var ImaXmlLoader:URLLoader;
		private var config:Object;
		// ======================== load date for IMA ads parameter from imaAdsXML =====================================
		public function ImaXml(ref,Config)
		{
			config = Config;
			config['imaAdsXML'] = (ref.root.loaderInfo.parameters['imaAdsXML']) ? ref.root.loaderInfo.parameters['imaAdsXML'] : config['imaAdsXML'];
			if (String(config['imaAdsXML'])!="")
			{
				if (config['imaAdsXML'].indexOf('http') > -1)
				{
					config['imaAdsXML'] = config['imaAdsXML'];
				}
				else
				{
					config['imaAdsXML'] = config['baseurl'] + "" + config['imaAdsXML'];
				}
				ImaXmlLoader = new URLLoader();
				ImaXmlLoader.addEventListener(Event.COMPLETE,ImaXmlHandler);
				ImaXmlLoader.load(new URLRequest(config['imaAdsXML']+"?imaid="+config['ran']));
			}
		}
		private function ImaXmlHandler(evt:Event):void
		{
			var Imaxml:XML = XML(evt.target.data);
			for each (var prp:XML in Imaxml.children())
			{
				config[prp.name()] = prp.text();
			}
		}

	}

}