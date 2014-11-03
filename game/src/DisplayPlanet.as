

package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class DisplayPlanet extends SpaceComponent implements IVisualComponent {
	
		public static const DISPLAY_RADIUS_RATIO:Number = 1;
		
		
		public static function unit_to_pixel(units:Number):Number {
			return DISPLAY_RADIUS_RATIO * units;
		}
		
		
		public var shape:Shape = new Shape();
				
		private var m_needs_redraw:Boolean = false;
		
		public var r:Number = 1.0;
		public var g:Number = 1.0;
		public var b:Number = 1.0;
		
		public var radius:Number;
		
		public var newton:NewtonData;
		
		public var well:GravityWell;
		
		public function DisplayPlanet() {
			collision_state |= CollisionBits.BIT_PLANET;
			collides_with |= CollisionBits.NONE;
		}
		
		override protected function init():void {
			well = require(GravityWell);
			newton = require(NewtonData);
			request_redraw();
			space_object.addEventListener(SpaceObject.EVENT_ADDED_TO_SPACE, added);
			space_object.addEventListener(SpaceObject.EVENT_REMOVED_FROM_SPACE, removed);
		}
		
		public function add_color(color:uint):void {
			var r:Number = ((color >>> 16) & 0xFF) / 255.0;
			var g:Number = ((color >>> 8 ) & 0xFF) / 255.0;
			var b:Number = ((color       ) & 0xFF) / 255.0;
			this.r += r;
			this.g += g;
			this.b += b;
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
			var max:Number = Math.max(this.r, this.g, this.b);
			
			var r:Number,g:Number,b:Number;
			r = 255 * this.r / max
			g = 255 * this.g / max;
			b = 255 * this.b / max;
			
			var color:uint = (uint(r) << 16) | (uint(g) << 8) | uint(b);
			
			
			shape.graphics.clear();
			shape.graphics.beginFill(color, 1);
			shape.graphics.lineStyle(0, 1);
			shape.graphics.drawCircle(0, 0, pixel_radius());
			shape.graphics.endFill();
		}
		
		private function check_redraw():void {
			if(m_needs_redraw) {
				m_needs_redraw = false;
				redraw();
			}
		}
		
		public function on_visual_update():void {	
			check_redraw();
			var pos:Point = newton.position;
			shape.x = pos.x;
			shape.y = pos.y;
		}
	}
}