package {

	import flash.display.*;
	import flash.utils.*;
	import flash.events.Event;
	
	public class SpaceEffect {
		
		public var space:Space;
		
		public var display:DisplayObject;
		
		public var callback:Function;
		
		public var duration_ms:Number;
		
		private var m_start:Number;
				
		public function SpaceEffect(space:Space, display:DisplayObject, duration_s:Number, callback:Function) {
			this.space = space;
			this.display = display;
			this.callback = callback;
			duration_ms = duration_s * 1000;
			m_start = getTimer();
			
			space.pallet.addChild(display);
			display.addEventListener(Event.ENTER_FRAME, on_frame);
			callback(0);
		}
		
		private function on_frame(e:*):void {
			var t:Number = getTimer() - m_start;
			t = t / duration_ms;
			if(t > 1) t = 1;
			
			callback(t);
			
			if(t == 1) destroy();
		}
		
		private function destroy():void {
			display.removeEventListener(Event.ENTER_FRAME, on_frame);
			if(display.parent) {
				display.parent.removeChild(display);
			}
			
			callback = null;
			display = null;
			space = null;
			
		}
	}
}