

package {
	import flash.geom.Point;
	public class NewtonData {
		public var position:Point = new Point();
		public var velocity:Point = new Point();
		public var acceleration:Point = new Point();
		
		public function step(dt:Number):void {
			apply_delta(dt, velocity, position);
			apply_delta(dt, acceleration, velocity);
		}
		
		private function apply_delta(dt:Number, delta:Point, destination:Point):void {
			destination.x += delta.x * dt;
			destination.y += delta.y * dt;
		}
		
		public function distance_squared(other:NewtonData):Number {
			var dx:Number = position.x - other.position.x;
			var dy:Number = position.y - other.position.y;
			return dx * dx + dy * dy;
		}
	}
}