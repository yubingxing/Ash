package net.richardlord.ash.tick
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getTimer;
	import net.richardlord.signals.Signal1;

	/**
	 * Provides a frame tick where the frame duration is the time since the previous frame.
	 * There is a maximum frame time parameter in the constructor that can be used to limit
	 * the longest period a frame can be.
	 */
	public class FrameTickProvider extends Signal1 implements TickProvider
	{
		private var displayObject : DisplayObject;
		private var previousTime : Number;
		private var maximumFrameTime : Number;
		
		/**
		 * Applies a time adjustement factor to the tick, so you can slow down or speed up the entire game.
		 * The update tick time is multiplied by this value, so a value of 1 will run the game at the normal rate.
		 */
		public var timeAdjustment : Number = 1;
		
		public function FrameTickProvider( displayObject : DisplayObject, maximumFrameTime : Number = Number.MAX_VALUE )
		{
			super( Number );
			this.displayObject = displayObject;
			this.maximumFrameTime = maximumFrameTime;
		}
		
		public function start() : void
		{
			previousTime = getTimer();
			displayObject.addEventListener( Event.ENTER_FRAME, dispatchTick );
		}
		
		public function stop() : void
		{
			displayObject.removeEventListener( Event.ENTER_FRAME, dispatchTick );
		}
		
		private function dispatchTick( event : Event ) : void
		{
			var temp : Number = previousTime;
			previousTime = getTimer();
			var frameTime : Number = ( previousTime - temp ) / 1000;
			if( frameTime > maximumFrameTime )
			{
				frameTime = maximumFrameTime;
			}
			dispatch( frameTime * timeAdjustment );
		}
	}
}
