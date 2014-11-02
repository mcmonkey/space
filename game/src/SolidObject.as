package {

	import flash.geom.Point;
	public class SolidObject extends SpaceObject {
		public var radius:Number = 1.0;
		
		public var well:GravityWell = new GravityWell();
		
		public var collision_state:uint = 0;
		
		public var collides_with:uint = 0;
		
		public function get newton():NewtonData {
			return well.newton;
		}
		
	}
}