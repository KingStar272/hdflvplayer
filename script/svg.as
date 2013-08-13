package script
{

	import flash.display.MovieClip;
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.processing.ProcessExecutor;

	public class svg extends MovieClip
	{
		private var svgDocument:SVGDocument;
		public function svg(mClip,con)
		{
			ProcessExecutor.instance.initialize(con);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;

			svgDocument = new SVGDocument();
			svgDocument.load("http://192.168.1.8/pack/source/n/hdflvplayer/bg.svg");
			mClip.addChild(svgDocument);
		}
	}
}