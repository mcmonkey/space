package {

	import flash.events.*;
	public class CollisionEvent extends Event {
		
		public static const COLLIDED:String = "space_collision_in_space!";
		
		public var collidee:SolidObject;
		
		public function CollisionEvent(collidee:SolidObject) {
			this.collidee = collidee;
			super(COLLIDED);
		}
	}
}