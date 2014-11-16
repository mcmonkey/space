

package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ResourceCollectionNode extends SpaceComponent implements IVisualComponent {
	
		
		private var shape:Shape = new Shape();
			
		private var m_needs_redraw:Boolean = false;
		
		private var radius:Number;
		
		private var resources_left:Number = 0;
		
		public var position:PositionData;	
		
		private var faction:FactionOwned;
		
		override protected function init():void {
			position = require(PositionData);
			faction = require(FactionOwned);
			
			space_object.addEventListener(SpaceObject.EVENT_ADDED_TO_SPACE, added);
			space_object.addEventListener(SpaceObject.EVENT_REMOVED_FROM_SPACE, removed);
		}
		
		private function added(event:*):void {
			space_object.space.pallet.addChild(shape);
			redraw();
		}
		
		private function removed(event:*):void {
			if(shape.parent) {
				shape.parent.removeChild(shape);
			}
		}
		
		
		private function redraw():void {
			var size:Number = 10;
			var half_size:Number = size / 2;
			var height:Number = Math.sqrt(size * size - half_size * half_size);
			var half_height:Number = height / 2;
			
			var color:uint = faction.faction.color;
			with(shape.graphics) {
				clear();
				beginFill(color, 1);
				lineStyle(0, color * .7);
				drawCircle(0, 0, 10);
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