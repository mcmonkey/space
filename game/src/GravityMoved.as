package {
	
	import flash.geom.Point;
	import util.CollisionPositionInfo;
	
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

			var info:CollisionPositionInfo = PositionData.collide(space_object, other);
			
			var force:Number = G * ( well.mass * this.mass ) / info.distance_squared;
			
			net_force.x += info.delta_position.x / info.distance * force;
			net_force.y += info.delta_position.y / info.distance * force;
		}
		
		public function on_model_update():void {
			newton.acceleration.x = net_force.x / mass;
			newton.acceleration.y = net_force.y / mass;
			
			net_force.x = 0;
			net_force.y = 0;
		}
		
	}
}