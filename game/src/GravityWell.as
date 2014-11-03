

package {
	
	import flash.geom.Point;
	
	public class GravityWell extends SpaceComponent {
	
		public var position:Point;
		
		public function GravityWell() {
			collision_state = CollisionBits.BIT_WELL;
		}
		
		override protected function init():void {
			position = require(NewtonData).position;
		}
		
		public var mass:Number = 1.0;
		
	}
}