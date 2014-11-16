

package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class DisplayStation extends Sprite {
	
		
		public var shape:Shape = new Shape();
		
		public var solid_object:SolidObject;
		
		private var m_color:uint;
		
		private static var m_count:uint = 0;
		
		public function DisplayStation(solid_object:SolidObject) {
		
			m_color = 0xFFFFFF * Math.random();
			
			solid_object.radius;
			
			addChild(shape);
			
			this.solid_object = solid_object;
			
			solid_object.well.fixed = true;
			solid_object.well.significant = false;
			
			shape.graphics.clear();
			shape.graphics.beginFill(m_color, 1);
			shape.graphics.drawRect(-2, -2, 4, 4);
			shape.graphics.endFill();
			
			solid_object.addEventListener(SpaceObject.EVENT_ADDED_TO_SPACE, added);
			solid_object.addEventListener(SpaceObject.EVENT_REMOVED_FROM_SPACE, removed);
		}
		
		
		private function added(event:*):void {
			addEventListener(Event.ENTER_FRAME, on_enter_frame);
			solid_object.space.pallet.addChild(this);
		}
		
		private function removed(event:*):void {
			removeEventListener(Event.ENTER_FRAME, on_enter_frame);
			removeChild(shape);
			shape.x = solid_object.newton.position.x;
			shape.y = solid_object.newton.position.y;
			new SpaceEffect(solid_object.space, shape, 0.4, function(t:Number):void {
				shape.scaleX = 1 + t;
				shape.scaleY = 1 + t;
				shape.alpha = 1 - t;
			});
			if(this.parent) {
				this.parent.removeChild(this);
			}
			
		}
		
		
		private function on_enter_frame(event:*):void {
			var pos:Point = solid_object.newton.position;	
			this.x = pos.x;
			this.y = pos.y;
			
			if(Math.random() > .3) return;
			if(m_count > 200) return;
			
			m_count++;
			
			
			var object:SolidObject = new SolidObject();
			object.newton.position.x = pos.x;
			object.newton.position.y = pos.y;
			object.newton.velocity.x = Math.random() * 50  -25;
			object.newton.velocity.y = Math.random() * 50  -25;
			object.addEventListener(SpaceObject.EVENT_REMOVED_FROM_SPACE, on_bullet_death);
			
			var bullet:DisplayBullet = object.add_controller(DisplayBullet);
			bullet.color = this.m_color;
			solid_object.space.add_solid_object(object);
			
			
		}
		
		private function on_bullet_death(e:*):void {
			m_count--;
			e.target.removeEventListener(SpaceObject.EVENT_REMOVED_FROM_SPACE, on_bullet_death);
		}
	}
}