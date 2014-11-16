

package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ConstructionDrone extends SpaceComponent implements IVisualComponent {
	
		
		private var shape:Shape = new Shape();
			
		private var m_needs_redraw:Boolean = false;
		
		private var radius:Number;
		
		public var position:PositionData;	
		
		public var faction:FactionOwned;
		
		private var route:Vector.<Point> = null;
		
		override protected function init():void {
			position = require(PositionData);
			faction = require(FactionOwned);
			
			space_object.addEventListener(SpaceObject.EVENT_ADDED_TO_SPACE, added);
			space_object.addEventListener(SpaceObject.EVENT_REMOVED_FROM_SPACE, removed);
		}
		
		private function added(event:*):void {
			space_object.space.pallet.addChild(shape);
			var destination:Point = new Point();
			destination.x = shape.stage.stageWidth;
			destination.y = shape.stage.stageHeight;
			destination.x *= Math.random();
			destination.y *= Math.random();
			var r:int = Math.random() * 4;
			switch(r) {
				case 0: destination.x = 0; break;
				case 1: destination.x = shape.stage.stageWidth; break;
				case 2: destination.y = 0; break;
				case 3: destination.y = shape.stage.stageHeight; break;
			}
			
			route = Obstacle.simple_route(space_object.space, position.position, destination, SIZE / 2);
			redraw();
		}
		
		private function removed(event:*):void {
			if(shape.parent) {
				shape.parent.removeChild(shape);
			}
		}
		
		
		private function redraw():void {
			with(shape.graphics) {
				var half:Number = SIZE / 2;
				clear();
				beginFill(faction.faction.color, 1);
				lineStyle(2, faction.faction.second_color);
				drawRect(-half, -half, SIZE, SIZE);
				endFill();
				lineStyle(2, faction.faction.second_color);
				moveTo(position.position.x, position.position.y);
				for each(var pos:Point in route) {
				
					lineTo(pos.x, pos.y);
				}
			}
		}
		
		public static const SIZE:Number = 5;
			
		public function on_visual_update():void {	
			
		}
	}
}