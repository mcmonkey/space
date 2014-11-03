

package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.System;
	
	public class DebugSprite extends Sprite {
		public var text:TextField = new TextField();
		
		public var game:Game;
		
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
			
			var space:Space = game.space;
			var info:String = "";
			info +=   "MEMORY: " + (System.privateMemory / 1024.0 / 1024.0).toPrecision(5);
			info += "\nALL:    " + space.m_all_objects.length;
			info += "\nCOLLID: " + space.m_colliders.length;
			
			text.text = info;
			text.width = text.textWidth + 10;
			
		}
	}
}