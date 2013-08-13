/**
 * AS3 Scrollbar
 
 */

package script
{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import script.gs.TweenMax;

	public class Scrollbar
	{

		// ___________________________________________________________________ CONSTANTS

		public static const VERTICAL: String = "vertical";
		public static const HORIZONTAL: String = "horizontal";

		private const STATUS_UP: String = "statusUp";
		private const STATUS_DOWN: String = "statusDown";
		private const STATUS_STOPPED: String = "statusStopped";

		// ___________________________________________________________________ CLASS PROPERTIES

		private var _initialized: Boolean;
		private var _direction: String;
		private var _position: String;
		private var _size: String;
		private var _status: String;
		private var _distance: Number;
		private var _transitionDuration: Number;
		private var _draggerTransitionDuration: Number;
		private var _showArrows: Boolean;
		private var _resizeDrag: Boolean;
		private var _blurIntensity: Number;
		private var _upArrowHeight: Number;
		private var _downArrowHeight: Number;
		private var _iniContainer: Number;
		private var _ratio: Number;
		private var _dragging: Boolean;
		private var _gap: Number;

		// ___________________________________________________________________ INSTANCE PROPERTIES

		private var _scope: MovieClip;
		private var _stage: Stage;
		private var _dragMc: MovieClip;
		private var _trackMc: MovieClip;
		private var _upArrowButton: MovieClip;
		private var _downArrowButton: MovieClip;
		private var _container: MovieClip;
		private var _mask: MovieClip;
		private var _transition: Function;
		private var _draggerTransition: Function;
		private var _dragRectangle: Rectangle;

		// ___________________________________________________________________ GETTERS AND SETTERS

		public function get scope():MovieClip
		{
			return _scope;
		}
		public function get dragMc():MovieClip
		{
			return _dragMc;
		}
		public function get trackMc():MovieClip
		{
			return _trackMc;
		}
		public function get upArrowButton():MovieClip
		{
			return _upArrowButton;
		}
		public function get downArrowButton():MovieClip
		{
			return _downArrowButton;
		}
		public function get container():MovieClip
		{
			return _container;
		}
		public function get transition():Function
		{
			return _transition;
		}
		public function get initialized():Boolean
		{
			return _initialized;
		}

		public function get gap():Number
		{
			return _gap;
		}
		public function set gap(value:Number):void
		{
			_gap = value;
			if (_initialized)
			{
				calculateRatio();
			}
		}

		// ___________________________________________________________________ CONSTRUCTOR

		/**
		 * Scrollbar constructor
		 * @paramscope MovieClip that contains the Scrollbar assets
		 */
		public function Scrollbar(scope:MovieClip, stage:Stage = null):void
		{
			_scope = scope;

			_stage = (stage == null) ? _scope.stage:stage;

			_dragMc = MovieClip(_scope.drag_mc);
			_dragMc.buttonMode = true;

			_trackMc = MovieClip(_scope.track_mc);

			_upArrowButton = MovieClip(_scope.up_arrow_mc);
			_upArrowButton.buttonMode = true;

			_downArrowButton = MovieClip(_scope.down_arrow_mc);
			_downArrowButton.buttonMode = true;

			_gap = 0;
		}

		// ___________________________________________________________________ PUBLIC METHODS

		/**
		 * Initialize the scrollbar
		 * @paramcontainer MovieClip with the content
		 * @parammask MovieClip with the mask. If it is null, a new one will be automatic created
		 * @paramdistance Distance that the container changes the Y coordinate each update
		 * @paramtransition Tween function transition
		 * @paramtransitionDuration Duration of the transition
		 * @paramdraggerTransition Tween function transition of the dragger
		 * @paramdraggerTransitionDuration Duration of the dragger transition
		 * @paramshowArrows Boolean value indicating if the arrows of Scrollbar should appear
		 * @paramresizeDrag Boolean value indicating if the dragger should resize
		 */
		public function initialize(container:MovieClip, mask:MovieClip = null, direction:String = "vertical",distance:Number = 5, transition:Function = null, transitionDuration:Number = .5, draggerTransition:Function = null, draggerTransitionDuration:Number = .25, showArrows:Boolean = true, resizeDrag:Boolean = false, blurIntensity:Number = 0):void
		{
			_initialized = true;
			_container = container;
			_direction = direction;
			_position = (_direction == VERTICAL) ? "y":"x";
			_size = (_direction == VERTICAL) ? "height":"width";
			_distance = distance;
			_transition = transition;
			_transitionDuration = transitionDuration;
			_draggerTransition = draggerTransition;
			_draggerTransitionDuration = draggerTransitionDuration;
			_showArrows = showArrows;
			_resizeDrag = resizeDrag;
			_blurIntensity = blurIntensity;

			if (_draggerTransition != null)
			{
				_distance *=  3;
			}

			_status = STATUS_STOPPED;
			_iniContainer = _container[_position];

			checkArrows();
			createMask(mask);
			checkScroll();
			setDragSize();
			calculateRatio();
			createDragRectangle();
			run();
		}

		/**
		 * Update the scrollbar
		 */
		public function update():void
		{
			setDragSize();
			checkScroll();
			calculateRatio();
			createDragRectangle();

			if (_dragMc.y > 0)
			{
				if (_dragMc.y == _trackMc.height - _dragMc.height)
				{
					updateContainerPosition(true);
				}
				else
				{
					updateDragPosition(true);
				}
			}
			else
			{
				updateContainerPosition(true);
			}
		}

		/**
		 * Reset the scrollbar
		 */
		public function reset():void
		{
			_dragMc.y = 0;
			_container[_position] = _iniContainer;
		}

		/**
		 * Run all events of scrollbar
		 */
		public function run():void
		{
			_dragMc.addEventListener(MouseEvent.MOUSE_DOWN, onDragMouseDown);

			_trackMc.addEventListener(MouseEvent.MOUSE_DOWN, onTrackMouseDown);

			_stage.addEventListener(MouseEvent.MOUSE_UP, onDragMouseUp);
			if (_direction == VERTICAL)
			{
				_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}

			if (_showArrows)
			{
				_upArrowButton.addEventListener(MouseEvent.MOUSE_DOWN, onUpArrowMouseDown);
				_upArrowButton.addEventListener(MouseEvent.MOUSE_UP, onUpArrowMouseUp);

				_downArrowButton.addEventListener(MouseEvent.MOUSE_DOWN, onDownArrowMouseDown);
				_downArrowButton.addEventListener(MouseEvent.MOUSE_UP, onDownArrowMouseUp);
			}

			_scope.addEventListener(Event.ENTER_FRAME, onUpdate);
		}

		/**
		 * Stop all events of scrollbar
		 */
		public function cancel():void
		{
			_dragMc.removeEventListener(MouseEvent.MOUSE_DOWN, onDragMouseDown);

			_trackMc.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackMouseDown);

			_stage.removeEventListener(MouseEvent.MOUSE_UP, onDragMouseUp);
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

			if (_showArrows)
			{
				_upArrowButton.removeEventListener(MouseEvent.MOUSE_DOWN, onUpArrowMouseDown);
				_upArrowButton.removeEventListener(MouseEvent.MOUSE_UP, onUpArrowMouseUp);

				_downArrowButton.removeEventListener(MouseEvent.MOUSE_DOWN, onDownArrowMouseDown);
				_downArrowButton.removeEventListener(MouseEvent.MOUSE_UP, onDownArrowMouseUp);
			}

			_scope.removeEventListener(Event.ENTER_FRAME, onUpdate);
		}

		/**
		 * Enable the mouse wheel
		 */
		public function enableMouseWheel():void
		{
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		/**
		 * Disable the mouse wheel
		 */
		public function disableMouseWheel():void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		/**
		 * Enable the click on the scrollbar tracker
		 */
		public function enableTracker():void
		{
			_trackMc.addEventListener(MouseEvent.MOUSE_DOWN, onTrackMouseDown);
		}

		/**
		 * Disable the click on the scrollbar tracker
		 */
		public function disableTracker():void
		{
			_trackMc.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackMouseDown);
		}

		/**
		 * Enable dragging capability
		 */
		public function enableDragger():void
		{
			_dragMc.addEventListener(MouseEvent.MOUSE_DOWN, onDragMouseDown);
		}

		/**
		 * Disable dragging capability
		 */
		public function disableDragger():void
		{
			_dragMc.removeEventListener(MouseEvent.MOUSE_DOWN, onDragMouseDown);
		}

		/**
		 * Change the scrollbar track size
		 * @paramsize Size of the track
		 */
		public function changeSize(size:Number):void
		{
			_trackMc.height = size;
			_downArrowButton.y = _trackMc.height;

			createDragRectangle();
		}

		/**
		 * Destroy the scrollbar
		 */
		public function destroy():void
		{
			cancel();

			_scope.parent.removeChild(_scope);
			_dragMc = null;
			_trackMc = null;
			_upArrowButton = null;
			_downArrowButton = null;
			_scope = null;
		}

		// ___________________________________________________________________ PRIVATE METHODS

		/**
		 * Check if the scroll is necessary
		 */
		private function checkScroll():void
		{
			if ((_container.height) <= _mask.height)
			{
				_scope.visible = false;
				_dragMc.y = 0;
			}
			else
			{
				_scope.visible = true;
			}
		}

		/**
		 * Check if the arrows are visible
		 */
		private function checkArrows():void
		{
			if (_showArrows)
			{
				_upArrowHeight = _upArrowButton.height;
				_downArrowHeight = _downArrowButton.height;
			}
			else
			{
				_upArrowHeight = 0;
				_downArrowHeight = 0;

				_upArrowButton.visible = false;
				_downArrowButton.visible = false;
			}
		}

		/**
		 * Create the mask if it doesn't exists
		 * @parammask Mask
		 */
		private function createMask(mask:MovieClip):void
		{
			if (mask == null)
			{
				_mask = new MovieClip();
				_mask.graphics.beginFill(0xFF0000);
				_mask.graphics.drawRect(_container.x, _container.y, _container.width, (_trackMc.height + _upArrowHeight + _downArrowHeight));
				_scope.parent.addChild(_mask);
				_container.mask = _mask;
			}
			else
			{
				_mask = mask;
			}
		}

		/**
		 * Set the size of the drag object
		 */
		private function setDragSize():void
		{
			if (_resizeDrag)
			{
				_dragMc.height = _trackMc.height + Math.round(100 - ((100 * _container[_size]) / _mask[_size]));
			}
		}/**
		 * Calculate the ratio between container height and mask height
		 */

		private function calculateRatio():void
		{
			_ratio = Math.round(_container[_size] - _mask[_size]) + (_gap);
		}

		/**
		 * Create the drag rectangle limits
		 */
		private function createDragRectangle():void
		{
			_dragRectangle = new Rectangle(0, 0, 0, (_trackMc.height - _dragMc.height));
		}

		/**
		 * Move the drag up
		 * @paramisMouseWheel Indicates if the input was the mouse wheel or not
		 */
		private function moveUp(isMouseWheel:Boolean = false):void
		{
			var s:Number = (isMouseWheel) ? (_distance * 3) : _distance;
			var posy:Number = Math.max(_trackMc.y,_dragMc.y - s);

			if (_draggerTransition != null)
			{
				TweenMax.to(_dragMc, _draggerTransitionDuration, { y:posy, ease:_draggerTransition } );
				updateContainerPosition(true, posy);
			}
			else
			{
				_dragMc.y = posy;
				updateContainerPosition(true);
			}
		}

		/**
		 * Move the drag down
		 * @paramisMouseWheel Indicates if the input was the mouse wheel or not
		 */
		private function moveDown(isMouseWheel:Boolean = false):void
		{
			var s:Number = (isMouseWheel) ? (_distance * 2) : _distance;
			var posy:Number = Math.min(_trackMc.height - _dragMc.height,_dragMc.y + s);

			if (_draggerTransition != null)
			{
				TweenMax.to(_dragMc, _draggerTransitionDuration, { y:posy, ease:_draggerTransition } );
				updateContainerPosition(true, posy);
			}
			else
			{
				_dragMc.y = posy;
				updateContainerPosition(true);
			}
		}

		/**
		 * Update the container based on the drag position
		 * @paramanimated Animated variable
		 * @paramsimulatedPosition Simulate the final position of the drag when animated
		 */
		private function updateContainerPosition(animated:Boolean = false, simulatedPosition:Number = -1):void
		{
			var posy:Number = _iniContainer - getUpdatedPosition(simulatedPosition);

			if (posy == _container[_position])
			{
				return;
			}

			if (! animated || _transition == null)
			{
				_container[_position] = posy;
			}
			else
			{
				var obj:Object = {};
				obj[_position] = posy;
				obj.ease = _transition;

				TweenMax.to(_container, _transitionDuration, obj );

				var diff:Number = Math.abs(posy - _container[_position]);
				if (diff > 2)
				{
					if (_blurIntensity > 0)
					{
						var splitTime:Number = _transitionDuration / 2;

						TweenMax.to(_container, splitTime, { blurFilter: { blurY:3, quality:2 }, ease:_transition } );
						TweenMax.to(_container, splitTime, { blurFilter: { blurY:0, quality:2, remove:true }, delay:splitTime, ease:_transition } );
					}
				}
			}
		}

		/**
		 * Calculate the position that container must go
		 * @paramsimulatedPosition Simulate the final position of the drag when animated
		 * @return
		 */
		private function getUpdatedPosition(simulatedPosition:Number = -1):Number
		{
			var p:Number = (simulatedPosition == -1) ? _dragMc.y:simulatedPosition;
			return Math.round(p / (_trackMc.height - _dragMc.height) * _ratio);
		}

		/**
		 * Update the drag position
		 * @paramanimated Animated variable
		 */
		private function updateDragPosition(animated:Boolean = false):void
		{
			var percent:Number =  Math.abs(_container[_position] - _iniContainer) / (_container[_size] - _mask[_size]);

			if (percent > 1)
			{
				_dragMc.y = _trackMc.height - _dragMc.height;
				updateContainerPosition(animated);
			}
			else
			{
				var r:Number = (percent) * (_trackMc.height - _dragMc.height);

				if (! animated || _draggerTransition == null)
				{
					_dragMc.y = r;
				}
				else
				{
					TweenMax.to(_dragMc, _draggerTransitionDuration, { y:r, ease:_draggerTransition } );
				}
			}
		}

		// ___________________________________________________________________ EVENTS

		/**
		 * Drag mouse down event
		 * @paramevt MouseEvent
		 */
		private function onDragMouseDown(evt:MouseEvent):void
		{
			_dragging = true;
			_dragMc.startDrag(false, _dragRectangle);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveScroll);
		}

		/**
		 * Drag mouse up event
		 * @paramevt MouseEvent
		 */
		private function onDragMouseUp(evt:MouseEvent):void
		{
			_dragging = false;
			_status = STATUS_STOPPED;

			_dragMc.stopDrag();
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveScroll);
		}

		/**
		 * Track mouse down event
		 * @paramevt MouseEvent
		 */
		private function onTrackMouseDown(evt:MouseEvent):void
		{
			var my:Number = _scope.mouseY;
			var posy:Number;

			if (my > _trackMc.height - _dragMc.height)
			{
				posy = _trackMc.height - _dragMc.height;
			}
			else
			{
				posy = my;

			}
			if (_draggerTransition == null)
			{
				_dragMc.y = posy;
				updateContainerPosition(true);
			}
			else
			{
				TweenMax.to(_dragMc, _draggerTransitionDuration, { y:posy, ease:_draggerTransition } );
				updateContainerPosition(true, posy);
			}


		}

		/**
		 * Mouse wheel event
		 * @paramevt MouseEvent
		 */
		private function onMouseWheel(evt:MouseEvent):void
		{
			if (! _scope.visible)
			{
				return;
			}

			if (evt.delta < 0)
			{
				moveDown(true);
			}
			else
			{
				moveUp(true);
			}
		}/**
		 * Up arrow mouse down event
		 * @paramevt MouseEvent
		 */

		private function onUpArrowMouseDown(evt:MouseEvent):void
		{
			_status = STATUS_UP;
		}

		/**
		 * Up arrow mouse up event
		 * @paramevt MouseEvent
		 */
		private function onUpArrowMouseUp(evt:MouseEvent):void
		{
			_status = STATUS_STOPPED;
		}

		/**
		 * Down arrow mouse down event
		 * @paramevt MouseEvent
		 */
		private function onDownArrowMouseDown(evt:MouseEvent):void
		{
			_status = STATUS_DOWN;
		}

		/**
		 * Down arrow mouse up event
		 * @paramevt MouseEvent
		 */
		private function onDownArrowMouseUp(evt:MouseEvent):void
		{
			_status = STATUS_STOPPED;
		}

		/**
		 * Enter frame event
		 * @paramevt Event
		 */
		private function onUpdate(evt:Event):void
		{
			switch (_status)
			{
				case STATUS_UP :
					moveUp(false);
					break;

				case STATUS_DOWN :
					moveDown(false);
					break;
			}
		}

		/**
		 * Mouse move event
		 * @paramevt MouseEvent
		 */
		private function onMoveScroll(evt:MouseEvent):void
		{
			updateContainerPosition(true);
			evt.updateAfterEvent();
		}
	}
}