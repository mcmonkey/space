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
		
		public static function on_collision(first:SolidObject, second:SolidObject):void {
			var pos_1:Point = first.newton.position;
			var pos_2:Point = second.newton.position;
			
			var dx:Number = pos_2.x - pos_1.x;
			var dy:Number = pos_2.y - pos_1.y;
			
			var center_x:Number = pos_1.x + dx / 2;
			var center_y:Number = pos_1.y + dy / 2;
			
			
		}
	}
}