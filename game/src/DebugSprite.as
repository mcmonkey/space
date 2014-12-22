

package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.getTimer;
	
	public class DebugSprite extends Sprite {
		public var text:TextField = new TextField();
		
		public var game:Game;
		
		private var _deltas:Vector.<Number> = new Vector.<Number>(10, true);
		private var _deltas_index:int = 0;
		
		private var _last_timer:Number = 0;
		
		public function DebugSprite(game:Game) {
			this.game = game;
			addChild(text);
			
			addEventListener(Event.ENTER_FRAME, on_frame);
			text.selectable = false;
			mouseEnabled = false;
			mouseChildren = false;
			text.background = true;
			text.backgroundColor = 0x00FF00;
			text.multiline = true;
			
		}
		
		public function on_frame(e:*):void {
			var delta_time:Number = getTimer() - _last_timer;
			_deltas[_deltas_index] = delta_time;
			
			var high_delta:int = 0;
			var low_delta:int = int.MAX_VALUE;
			
			var fps:Number = 0;
			for each(delta_time in _deltas) {
				fps += delta_time;
				high_delta = high_delta < delta_time ? delta_time : high_delta;
				low_delta = low_delta > delta_time ? delta_time : low_delta;
			}
			fps = fps / _deltas.length;
			fps = 1000 / fps;
			
			_deltas_index = (_deltas_index + 1) % _deltas.length;
			
			
			var space:Space = game.space;
			var info:String = "";
			info +=   "MEMORY: " + (System.privateMemory / 1024.0 / 1024.0).toPrecision(5);
			info += "\nALL:    " + space.m_all_objects.length;
			info += "\nCOLLID: " + space.m_colliders.length;
			info += "\nMOUSE_X:" + stage.mouseX;
			info += "\nMOUSE_Y:" + stage.mouseY;
			info += "\nFPS:        " + fps.toPrecision(2) + "(" + low_delta + "/" + high_delta + ")";
			
			text.text = info;
			text.width = text.textWidth + 10;
			
			_last_timer = getTimer();
		}
	}
}