package {

	import flash.geom.Point;
	public class CollisionBits {
		public static const NONE:uint = 0;
		public static const ALL:uint = 0xFFFFFFFF;
		
		public static const BIT_PLANET:uint = 1 << 0;
		public static const BIT_BULLET:uint = 1 << 1;
	}
}