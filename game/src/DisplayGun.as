

package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class DisplayGun extends SpaceComponent implements IModelComponent, IVisualComponent {
	
		
		public var shape:Shape = new Shape();
		
		private var m_color:uint;
		
		private static var m_count:uint = 0;
		
		public var newton:NewtonData;
		
		override protected function init():void {
			
			m_color = 0xFFFFFF * Math.random();
					
			newton = require(NewtonData);
			
			shape.graphics.clear();
			shape.graphics.beginFill(m_color, 1);
			shape.graphics.drawRect(-2, -2, 4, 4);
			shape.graphics.endFill();
			
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
		
		public function on_visual_update():void {
			
			var pos:Point = newton.position;	
			shape.x = pos.x;
			shape.y = pos.y;
		}
		
		public function on_model_update():void {
			
			if(Math.random() > .3) return;
			if(m_count > 200) return;
			
			m_count++;
			
			
			var pos:Point = newton.position;
			
			var object:SpaceObject = new SpaceObject();
			
			var new_newton:NewtonData = object.add_controller(NewtonData);
			new_newton.position.x = pos.x;
			new_newton.position.y = pos.y;
			new_newton.velocity.x = Math.random() * 50  -25;
			new_newton.velocity.y = Math.random() * 50  -25;
			object.addEventListener(SpaceObject.EVENT_REMOVED_FROM_SPACE, on_bullet_death);
			
			var bullet:DisplayBullet = object.add_controller(DisplayBullet);
			bullet.color = this.m_color;
			space_object.space.add_space_object(object);
			
		}
		
		private function on_bullet_death(e:*):void {
			m_count--;
			e.target.removeEventListener(SpaceObject.EVENT_REMOVED_FROM_SPACE, on_bullet_death);
		}
	}
}