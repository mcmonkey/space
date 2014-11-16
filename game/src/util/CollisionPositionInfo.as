package util {
	import flash.geom.Point;
	
	public class CollisionPositionInfo  {
	
		public var local_position:Point;
		
		public var other_position:Point;
		
		public var delta_position:Point = new Point();
		
		public var distance_squared:Number = NaN;
		
		private var m_distance:Number = NaN;
		private var m_calc_dist:Boolean = true;
		
		public function get distance():Number {
			if(m_calc_dist) {
				m_distance = Math.sqrt(distance_squared);
			}
			return m_distance;
		}
		
		public function init(local:Point, other:Point):void {
			local_position = local;
			other_position = other;
			with(delta_position) {
				x = other.x - local.x;
				y = other.y - local.y;
				distance_squared = x * x + y * y;
			}
			m_calc_dist = true;
		}
		
	}
}