package actionscript
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.xml.*;
	import flash.display.*;

	public class languageXml
	{

		private var languageLoader:URLLoader;
		private var config:Object;
		// =========================== get languge for all display text in player =======================
		public function languageXml(ref,Config)
		{
			config = Config;
			config['languageXML'] = (ref.root.loaderInfo.parameters['languageXML']) ? ref.root.loaderInfo.parameters['languageXML'] : config['languageXML'];
			if (config['languageXML'].indexOf('http') > -1)
			{
				config['languageXML'] = config['languageXML'];
			}
			else
			{
				config['languageXML'] = config['baseurl'] + "" + config['languageXML'];
			}
			languageLoader = new URLLoader();
			languageLoader.addEventListener(Event.COMPLETE,languageXmlHandler);
			languageLoader.load(new URLRequest(config['languageXML']+"?lanid="+config['ran']));
		}
		private function languageXmlHandler(evt:Event):void
		{
			var langxml:XML = XML(evt.target.data);
			for each (var prp:XML in langxml.children())
			{
				config[prp.name()] = prp.text();
			}
		}
	}
}