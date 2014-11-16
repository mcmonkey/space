

package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class FactionNexus extends SpaceComponent implements IVisualComponent {
	
		
		private var shape:Shape = new Shape();
			
		private var m_needs_redraw:Boolean = false;
		
		private var radius:Number;
		
		private var resources_left:Number = 0;
		
		public var position:PositionData;	
		
		private var faction:FactionOwned;
		
		override protected function init():void {
			position = require(PositionData);
			faction = require(FactionOwned);
			faction.faction = new Faction();
			
			redraw();
			space_object.addEventListener(SpaceObject.EVENT_ADDED_TO_SPACE, added);
			space_object.addEventListener(SpaceObject.EVENT_REMOVED_FROM_SPACE, removed);
		}
		
		private function added(event:*):void {
			space_object.space.pallet.addChild(shape);
		}
		
		private function removed(event:*):void {
			if(shape.parent) {
				shape.parent.removeChild(shape);
			}
		}
		
		
		private function redraw():void {
			var size:Number = 20;
			var half_size:Number = size / 2;
			var height:Number = Math.sqrt(size * size - half_size * half_size);
			var half_height:Number = height / 2;
			
			var color:uint = faction.faction.color;
			with(shape.graphics) {
				clear();
				beginFill(color, 1);
				moveTo(-half_size, -half_height);
				lineTo(half_size, -half_height);
				lineTo(0, half_height);
				endFill();
				beginFill(color, 1);
				moveTo(-half_size, half_height);
				lineTo(half_size, half_height);
				lineTo(0, -half_height);
				endFill();
			}
		}
		
		public function on_visual_update():void {			
			with(position.position) {
				shape.x = x;
				shape.y = y;
			}
		}
	}
}