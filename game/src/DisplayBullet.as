

package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class DisplayBullet extends Sprite {
	
		
		public var shape:Shape = new Shape();
		
		public var solid_object:SolidObject;
		
		
		public function DisplayBullet(solid_object:SolidObject) {
		
			solid_object.radius;
			
			addChild(shape);
			
			this.solid_object = solid_object;
			
			solid_object.well.fixed = false;
			solid_object.well.significant = false;
			
			solid_object.collision_state = CollisionBits.BIT_BULLET;
			solid_object.collides_with = CollisionBits.BIT_PLANET;
			
			shape.graphics.clear();
			shape.graphics.beginFill(0xFF0000, 1);
			shape.graphics.drawCircle(0, 0, 2);
			shape.graphics.endFill();
			
			addEventListener(Event.ENTER_FRAME, on_enter_frame);
			solid_object.addEventListener(SpaceObject.EVENT_ADDED_TO_SPACE, added);
			solid_object.addEventListener(SpaceObject.EVENT_REMOVED_FROM_SPACE, removed);
			solid_object.addEventListener(CollisionEvent.COLLIDED, collided);
		}
		
		private function collided(event:CollisionEvent):void {
			event.collidee.well.mass *= .99;
			event.collidee.radius *= .99;
		}
		
		private function added(event:*):void {
			solid_object.space.pallet.addChild(this);
		}
		
		private function removed(event:*):void {
			if(this.parent) {
				this.parent.removeChild(this);
			}
		}
		
		
		private function on_enter_frame(event:*):void {	
			var pos:Point = solid_object.newton.position;
			if(pos.x < 0) {
				pos.x = stage.stageWidth;
			}
			if(pos.x > stage.stageWidth) {
				pos.x = 0;
			}
			if(pos.y > stage.stageHeight) {
				pos.y = 0;
			}
			if(pos.y < 0) {
				pos.y = stage.stageHeight
			}
			this.x = pos.x;
			this.y = pos.y;
		}
	}
}