

package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ResourceNode extends SpaceComponent implements IVisualComponent, IModelComponent {
	
		public static const DISPLAY_RADIUS_RATIO:Number = 1;
		
		
		public static function unit_to_pixel(units:Number):Number {
			return DISPLAY_RADIUS_RATIO * units;
		}
		
		
		private var shape:Shape = new Shape();
			
		private var m_needs_redraw:Boolean = false;
		
		private var radius:Number;
		
		private var resources_left:Number = 1000;
		
		public var position:PositionData;	
		
		public function ResourceNode() {
			collision_state |= CollisionBits.BIT_PLANET;
			collides_with |= CollisionBits.NONE;
		}
		
		override protected function init():void {
			position = require(PositionData);
			request_redraw();
			space_object.addEventListener(SpaceObject.EVENT_ADDED_TO_SPACE, added);
			space_object.addEventListener(SpaceObject.EVENT_REMOVED_FROM_SPACE, removed);
		}
		
		public function add_color(color:uint):void {
			request_redraw();
		}
		
		private function added(event:*):void {
			space_object.space.pallet.addChild(shape);
		}
		
		private function removed(event:*):void {
			if(shape.parent) {
				shape.parent.removeChild(shape);
			}
		}
		
		public function pixel_radius():Number {
			return unit_to_pixel(radius);
		}
		
		public function request_redraw():void {
			m_needs_redraw = true;
		}
		
		private function redraw():void {
			var pix_rad:Number = pixel_radius();
					
			
			var color:uint = 0xAAAAAA;
			with(shape.graphics) {
				clear();
				beginFill(color, 1);
				lineStyle(0, 1);
				drawCircle(0, 0, pix_rad);
				endFill();
			}
		}
		
		private function check_redraw():void {
			if(m_needs_redraw) {
				m_needs_redraw = false;
				redraw();
			}
		}
		
		public function on_model_update():void {
			if(resources_left <= 0) {
				space_object.destroy();
				radius = 0;
			} else {
				radius = Math.sqrt(resources_left);
			}
			
			request_redraw();
		}
		
		public function on_visual_update():void {	
			check_redraw();
			
			with(position.position) {
				shape.x = x;
				shape.y = y;
			}
		}
	}
}