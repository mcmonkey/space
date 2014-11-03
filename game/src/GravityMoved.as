package {
	
	import flash.geom.Point;
	
	public class GravityMoved extends SpaceComponent implements IModelComponent {
	
		public static const G:Number = 1.0;
				
		private var newton:NewtonData;
		
		private var net_force:Point = new Point();
		
		public var mass:Number = 1.0;
		
		public function GravityMoved() {
			collides_with = CollisionBits.BIT_WELL;
		}
		
		override protected function init():void {
			newton = require(NewtonData);
		}
		
		override internal function collide(other:SpaceObject):void {
			var well:GravityWell = other.get_controller(GravityWell);
			var other_newton:NewtonData = other.get_controller(NewtonData);
			
			var d_pos_x:Number = other_newton.position.x - newton.position.x;
			var d_pos_y:Number = other_newton.position.y - newton.position.y;
			
			var dx:Number = d_pos_x;
			var dy:Number = d_pos_y;
			dx = dx * dx;
			dy = dy * dy;
			
			var r2:Number = dx + dy;
			var dist:Number = Math.sqrt(r2);
			
			dx = d_pos_x / dist;
			dy = d_pos_y / dist;
			
			var force:Number = G * ( well.mass * this.mass ) / r2;
			
			net_force.x += dx * force;
			net_force.y += dy * force;
		}
		
		public function on_model_update():void {
			newton.acceleration.x = net_force.x / mass;
			newton.acceleration.y = net_force.y / mass;
			
			net_force.x = 0;
			net_force.y = 0;
		}
		
	}
}