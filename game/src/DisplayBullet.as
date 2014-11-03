

package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class DisplayBullet extends SpaceComponent implements IVisualComponent {
	
		
		public var shape:Shape = new Shape();
		
		private var m_color:uint;
		
		private var newton:NewtonData;
		
		public function DisplayBullet() {
			collision_state |= CollisionBits.BIT_BULLET;
			collides_with   |= CollisionBits.BIT_PLANET;
		}
		
		public function get color():uint {
			return m_color;
		}
		
		public function set color(value:uint):void {
			m_color = value;
			redraw();
		}
		
		override protected function init():void {
			m_color = 0;
						
			newton = require(NewtonData);
			require(GravityMoved);
			
			redraw();
			
			space_object.addEventListener(SpaceObject.EVENT_ADDED_TO_SPACE, added);
			space_object.addEventListener(SpaceObject.EVENT_REMOVED_FROM_SPACE, removed);
		}
		
		private function redraw():void {
			shape.graphics.clear();
			shape.graphics.beginFill(m_color, 1);
			shape.graphics.drawCircle(0, 0, 2);
			shape.graphics.endFill();
		}
		
		override internal function collide(other:SpaceObject):void {
			var planet:DisplayPlanet = other.get_controller(DisplayPlanet);
			if(planet) {
				if(planet.newton.distance_squared(this.newton) < planet.radius * planet.radius) {
				
					planet.add_color(m_color);
					space_object.destroy();
				}
			}
		}
		
		private function added(event:*):void {
			space_object.space.pallet.addChild(shape);
		}
		
		private function removed(event:*):void {
			shape.x = newton.position.x;
			shape.y = newton.position.y;
			
			if(shape.parent) {
				shape.parent.removeChild(shape);
			}
			new SpaceEffect(space_object.space, shape, 0.4, function(t:Number):void {
				shape.scaleX = 1 + t;
				shape.scaleY = 1 + t;
				shape.alpha = 1 - t;
			});
		}
				
		public function on_visual_update():void {
			var pos:Point = newton.position;
			shape.x = pos.x;
			shape.y = pos.y;
		}
	}
}