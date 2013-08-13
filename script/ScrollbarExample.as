

package 
{

	import com.sandrohaag.extensions.scrollbar.Scrollbar;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import gs.easing.Cubic;
	import gs.TweenMax;

	public class ScrollbarExample extends MovieClip
	{
		// ___________________________________________________________________ CONSTANTS

		// ___________________________________________________________________ CLASS PROPERTIES

		// ___________________________________________________________________ INSTANCE PROPERTIES

		private var _container: MovieClip;
		private var _mask: MovieClip;
		private var _scrollbarVerticalMc: MovieClip;
		private var _scrollbarHorizontalMc: MovieClip;
		private var _sizeButton: MovieClip;
		private var _runButton: MovieClip;
		private var _cancelButton: MovieClip;
		private var _resetButton: MovieClip;
		private var _scrollbarVertical: Scrollbar;
		private var _scrollbarHorizontal: Scrollbar;

		// ___________________________________________________________________ GETTERS AND SETTERS

		// ___________________________________________________________________ CONSTRUCTOR

		public function ScrollbarExample()
		{
			_container = this.container_mc;
			_mask = this.mask_mc;
			_scrollbarVerticalMc = this.scrollbar_vertical_mc;
			_scrollbarHorizontalMc = this.scrollbar_horizontal_mc;

			_sizeButton = this.size_btn;
			_sizeButton.addEventListener(MouseEvent.CLICK, onSizeButtonClick);
			_sizeButton.buttonMode = true;

			_runButton = this.run_btn;
			_runButton.addEventListener(MouseEvent.CLICK, onRunButtonClick);
			_runButton.buttonMode = true;

			_cancelButton = this.cancel_btn;
			_cancelButton.addEventListener(MouseEvent.CLICK, onCancelButtonClick);
			_cancelButton.buttonMode = true;

			_resetButton = this.reset_btn;
			_resetButton.addEventListener(MouseEvent.CLICK, onResetButtonClick);
			_resetButton.buttonMode = true;

			_scrollbarVertical = new Scrollbar(_scrollbarVerticalMc);
			_scrollbarVertical.initialize(_container, _mask, Scrollbar.VERTICAL, 5, Cubic.easeOut, .5, Cubic.easeOut, .25, true, false, 0);
			_scrollbarVertical.changeSize(286);

			_scrollbarHorizontal = new Scrollbar(_scrollbarHorizontalMc);
			_scrollbarHorizontal.initialize(_container, _mask, Scrollbar.HORIZONTAL, 5, Cubic.easeOut, .5, Cubic.easeOut, .25, true, false, 0);
			_scrollbarHorizontal.changeSize(517);
		}

		private function onSizeButtonClick(evt:MouseEvent):void
		{
			var a:Array = [-1,1];
			var r:Number = a[int(Math.random() * a.length)];
			var h:Number = 50 * r;
			_container.width +=  h;
			_container.height +=  h;
			_scrollbarVertical.update();
			_scrollbarHorizontal.update();
		}

		private function onRunButtonClick(evt:MouseEvent):void
		{
			_scrollbarVertical.run();
			_scrollbarHorizontal.run();
		}

		private function onCancelButtonClick(evt:MouseEvent):void
		{
			_scrollbarVertical.cancel();
			_scrollbarHorizontal.cancel();
		}

		private function onResetButtonClick(evt:MouseEvent):void
		{
			_scrollbarVertical.reset();
			_scrollbarHorizontal.reset();
		}

		// ___________________________________________________________________ PUBLIC METHODS;

		// ___________________________________________________________________ PRIVATE METHODS

		// ___________________________________________________________________ EVENTS
	}
}