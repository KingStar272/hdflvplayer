package actionscript
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.xml.*;
	import flash.display.*;
	import flash.events.IOErrorEvent;

	public class adsXml extends EventDispatcher
	{
		private var adsLoader:URLLoader;
		private var midAdsLoader:URLLoader;
		private var config:Object;
		private var adsUrlArr:Array;
		private var adsTargetArr:Array;
		private var adsClickArr:Array;
		private var adsImpressionArr:Array;
		private var ads_IdArr:Array;
		private var adsHitsArr:Array;
		private var adsImpressionHitsArr:Array;
		private var adsDesArr:Array;
		private var midadd:Array = new Array();
		private var midtar:Array = new Array();
		private var midclick:Array = new Array();
		private var midimpression:Array = new Array();
		private var MessageClass:Message;

		public function adsXml(reference,Config)
		{
			
			adsUrlArr = new Array();
			adsTargetArr = new Array();
			adsClickArr = new Array();
			adsImpressionArr = new Array();
			ads_IdArr = new Array();
			adsHitsArr = new Array();
			adsImpressionHitsArr = new Array();
			adsDesArr = new Array();
			midadd = new Array();
			midtar = new Array();
			midclick = new Array();
			midimpression = new Array();
			config = Config;
			MessageClass = new Message(config,reference);
			config['midroll_ads'] = (reference.root.loaderInfo.parameters['midroll_ads']) ? reference.root.loaderInfo.parameters['midroll_ads'] : config['midroll_ads'];
			config['postroll_ads'] = (reference.root.loaderInfo.parameters['postroll_ads']) ? reference.root.loaderInfo.parameters['postroll_ads'] : config['postroll_ads'];
			config['preroll_ads'] = (reference.root.loaderInfo.parameters['preroll_ads']) ? reference.root.loaderInfo.parameters['preroll_ads'] : config['preroll_ads'];
			config['adXML'] = (reference.root.loaderInfo.parameters['adXML']) ? reference.root.loaderInfo.parameters['adXML'] : config['adXML'];
			if(config['adXML'] != undefined)
			{
				if (config['adXML'].indexOf('http') > -1)
				{
					config['adXML'] = config['adXML'];
				}
				else
				{
					config['adXML'] = config['baseurl'] + "" + config['adXML'];
				}
				
				if(config['pluginType'] == "") {config['adXML'] = config['adXML']+"?lanid="+config['ran']}
				if (config['preroll_ads'] == "true" || config['postroll_ads'] == "true")
				{
					//==================== load pre roll and post roll adsxml ======================================================
					adsLoader = new URLLoader();
					adsLoader.addEventListener(Event.COMPLETE,adsXmlHandler);
					adsLoader.addEventListener(IOErrorEvent.IO_ERROR, adxmlError);
					adsLoader.load(new URLRequest(config['adXML']));
				}
			}
			config['midrollXML'] = (reference.root.loaderInfo.parameters['midrollXML']) ? reference.root.loaderInfo.parameters['midrollXML'] : config['midrollXML'];
			if(config['midrollXML'] != undefined)
			{
				if (config['midrollXML'].indexOf('http') > -1)
				{
					config['midrollXML'] = config['midrollXML'];
				}
				else
				{
					config['midrollXML'] = config['baseurl'] + "" + config['midrollXML'];
				}
				if(config['pluginType'] == "") {config['midrollXML'] = config['midrollXML']+"?mdid="+config['ran']}
				if (config['midroll_ads'] == "true")
				{
					//==================== load midroll ads xml ======================================================
					midAdsLoader = new URLLoader();
					midAdsLoader.addEventListener(Event.COMPLETE,midsXmlHandler);
					midAdsLoader.addEventListener(IOErrorEvent.IO_ERROR, MidadxmlError);
					midAdsLoader.load(new URLRequest(config['midrollXML']));
				}
			}
		}
		// ===================== ads xml error function ==============================================================
		function adxmlError(evt:IOErrorEvent)
		{
			MessageClass.show("There is an Error in loading ads.xml");
		}

		function MidadxmlError(evt:IOErrorEvent)
		{
			MessageClass.show("There is an Error in loading midroll.xml");
		}
		private function adsXmlHandler(evt:Event):void
		{
			trace(evt.currentTarget.data)
			var adslistXml:XML = XML(evt.currentTarget.data);
			config['adslistlength'] = adslistXml.children().length();
			config['adrandom'] = adslistXml.. @ random;
			var adsDoc:XMLDocument = new XMLDocument();
			adsDoc.ignoreWhite = true;
			adsDoc.parseXML(adslistXml.toXMLString());
			for (var i = 0; i<adslistXml.children().length(); i++)
			{
				adsUrlArr.push(adslistXml.ad[i].@url);
				config['adsUrlArr'] = adsUrlArr;
				adsTargetArr.push(adslistXml.ad[i].@targeturl);
				config['adsTargetArr'] = adsTargetArr;
				adsClickArr.push(adslistXml.ad[i].@clickurl);
				config['adsClickArr'] = adsClickArr;
				adsImpressionArr.push(adslistXml.ad[i].@impressionurl);
				config['adsImpressionArr'] = adsImpressionArr;
				ads_IdArr.push(adslistXml.ad[i].@id);
				config['ads_IdArr'] = ads_IdArr;
				adsHitsArr.push(adslistXml.ad[i].@adhits);
				config['adsHitsArr'] = adsHitsArr;
				adsImpressionHitsArr.push(adslistXml.ad[i].@impressionhits);
				config['adsImpressionHitsArr'] = adsImpressionHitsArr;
				adsDesArr.push(adsDoc.firstChild.childNodes[i].childNodes[0].nodeValue);
				config['adsDesArr'] = adsDesArr;
			}
		}
		private function midsXmlHandler(evt:Event):void
		{
			var midadslistXml:XML = XML(evt.currentTarget.data);
			config['midslistlength'] = midadslistXml.children().length();
			config['midbegin'] = midadslistXml.. @ begin;
			config['adinterval'] = midadslistXml.. @ adinterval;
			config['adrotate'] = midadslistXml.. @ adrotate;
			config['random'] = midadslistXml.. @ random;
			for (var j = 0; j<config['midslistlength']; j++)
			{
				midadd.push(midadslistXml.children()[j].valueOf());
				config['midadd'] = midadd;
				midtar.push(midadslistXml.midroll[j].@targeturl);
				config['midtar'] = midtar;
				midclick.push(midadslistXml.midroll[j].@clickurl);
				config['midclick'] = midclick;
				midimpression.push(midadslistXml.midroll[j].@impressionurl);
				config['midimpression'] = midimpression;
			}
		}
	}

}