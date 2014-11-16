package {
	import flash.geom.Point;
	import util.CollisionPositionInfo;
	
	public class PositionData extends SpaceComponent {
		public var position:Point = new Point();
		
		private var collision_info:CollisionPositionInfo = new CollisionPositionInfo();
		
		public function collide_data(position_data:PositionData):CollisionPositionInfo {
			collision_info.init(position, position_data.position);
			return collision_info;
		}
		
		public function collide_object(object:SpaceObject):CollisionPositionInfo {
			var other:PositionData = object.get_controller(PositionData);
			if(!other) throw new Error("Object missing PositionData component");
			return collide_data(other);
		}
		
		public static function collide(local_obj:SpaceObject, other_obj:SpaceObject):CollisionPositionInfo {
			var local:PositionData = local_obj.get_controller(PositionData);
			if(!local) throw new Error("Object missing PositionData component");
			return local.collide_object(other_obj);
		}
	}
}