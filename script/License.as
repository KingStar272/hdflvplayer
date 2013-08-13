package script
{
	import flash.external.*;
	public class License
	{
		private var charInputBit:uint = 16;
		private var domain:String;
		private var config:Object;
		private var chars_array:Array;
		private var lookupObj:Object;

		public function License(cfg:Object, dmn:String):void
		{
			domain = dmn;
			config = cfg;
		}
		public function getLicense():String
		{
			chars_array = new Array();
			var urlPattern1:RegExp = new RegExp("(http:\/\/)?([^\/]+)","i");
			var arr1:Object = domain.match(urlPattern1);
			domain = arr1[2];

			var urlPattern2:RegExp = new RegExp("[^\.\/]+\.[^\.\/]+$");
			var arr2:Object = domain.match(urlPattern2);
			domain = arr2[0];
			domain = domain.replace('.','D');
			var code = generatekey(domain.toUpperCase());
			code = code.substr(0,25);
			code +=  'CONTUS';
			return (config['license'] == code) ? 'commercial' : 'demo';
		}
		function generatekey(val)
		{
			var message:String;
			if(config['ref'].root.loaderInfo.parameters['baserefW'])
			{
				message = "EW-VGMP0EFIL9XEV8YZAL7KCIUQ6NI5OREH4TSEB3TSRIF2SI1ROTAIDALG-JW"
			}
			else
			{
			    message = "ESA-HDFLVPMP0EFIL9XEV8YZAL7KCIUQ6NI5OREH4TSEB3TSRIF2SI1ROTAIDALG-JW";
			}
			
			GEFFEncryption();
			return encrypt(val, message);
		}
		function GEFFEncryption()
		{

			var chars_str = "WJ-GLADIATOR1IS2FIRST3BEST4HERO5IN6QUICK7LAZY8VEX9LIFEMP0";
			chars_array = chars_str.split("");
			lookupObj = new Object();
			var p:Number = chars_array.length - 1;
			for (var i=p; i>=0; i--)
			{
				lookupObj[chars_array[i].charCodeAt(0)] = i;
			}
		}

		function encrypt(tkey, message):String
		{
			var key_array = tkey.split("");

			var enc_message = "";
			var kPos = 0;
			for (var i = 0; i< message.length; i++)
			{
				var char = message.charAt(i);
				var offset = getOffset(key_array[kPos],char);
				enc_message +=  chars_array[offset];
				kPos++;
				if (kPos>=key_array.length)
				{
					kPos = 0;
				}
			}
			return enc_message;
		}
		function getOffset(start, end):Number
		{
			var sNum = lookupObj[start.charCodeAt(0)];
			var eNum = lookupObj[end.charCodeAt(0)];
			var offset = (eNum)-sNum;
			if (offset<0)
			{
				offset = chars_array.length+(offset);
			}
			return offset;
		}
	}
}