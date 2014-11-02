

package {
	
	import flash.geom.Point;
	
	public class GravityWell {
		public var newton:NewtonData = new NewtonData();
		public var mass:Number = 1.0;
		
		public var net_force:Point = new Point();
		
		public var fixed:Boolean = false;
		
		public var significant:Boolean = true;
		
	}
}