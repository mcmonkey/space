package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.System;
	
	public class Faction  {		
		public var color:uint;
		
		public var objects:Vector.<FactionOwned> = new Vector.<FactionOwned>();
				
		public function Faction() {
			color = Math.random() * uint.MAX_VALUE;
		}
		
	}
}