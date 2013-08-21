package actionscript
{

	public class Strings
	{
		public static function decode(str:String):String
		{
			if (str.indexOf('asfunction') == -1)
			{
				return unescape(str);
			}
			else
			{
				return '';
			}
		}
		public static function digits(nbr:Number):String
		{
			var min:Number = Math.floor(nbr/60);
			var sec:Number = Math.floor(nbr%60);
			var str:String = Strings.zero(min) + ':' + Strings.zero(sec);
			return str;
		}
		public static function seconds(str:String):Number
		{
			str = str.replace(',','.');
			var arr:Array = str.split(':');
			var sec:Number = 0;
			if (str.substr(-1) == 's')
			{
				sec = Number(str.substr(0,str.length - 1));
			}
			else if (str.substr(-1) == 'm')
			{
				sec = Number(str.substr(0,str.length - 1)) * 60;
			}
			else if (str.substr(-1) == 'h')
			{
				sec = Number(str.substr(0,str.length - 1)) * 3600;
			}
			else if (arr.length > 1)
			{
				sec = Number(arr[arr.length - 1]);
				sec +=  Number(arr[arr.length - 2]) * 60;
				if (arr.length == 3)
				{
					sec +=  Number(arr[arr.length - 3]) * 3600;
				}
			}
			else
			{
				sec = Number(str);
			}
			return sec;
		}


		public static function serialize(val:String):Object
		{
			if (val == null)
			{
				return null;
			}
			else if (val == 'true')
			{
				return true;
			}
			else if (val == 'false')
			{
				return false;
			}
			else if (isNaN(Number(val)) || val.length > 5)
			{
				return Strings.decode(val);
			}
			else
			{
				return Number(val);
			}
		}


		public static function strip(str:String):String
		{
			var tmp:Array = str.split("\n");
			str = tmp.join("");
			tmp = str.split("\r");
			str = tmp.join("");
			var idx:Number = str.indexOf("<");
			while (idx != -1)
			{
				var end:Number = str.indexOf(">",idx + 1);
				end == -1 ? end = str.length - 1:null;
				str = str.substr(0,idx)+" "+str.substr(end+1,str.length);
				idx = str.indexOf("<",idx);
			}
			return str;
		}
		public static function zero(nbr:Number):String
		{
			if (nbr < 10)
			{
				return '0' + nbr;
			}
			else
			{
				return '' + nbr;
			}
		}
		public static function split(holder, searchfor, returnindex):String
		{
			if (holder.indexOf(searchfor) == -1)
			{
				return holder;
			}
			var temparray:Array = holder.split(searchfor);
			holder = temparray[returnindex];
			return holder;
		}
	}
}