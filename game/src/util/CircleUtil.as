package util {
	import flash.geom.Point;
	
	public class CircleUtil {
		
		public static function even_point(index:int, count:int, radius:Number, clock_wise:Boolean = true):Point {
			const HALF_RADIAN:Number = 0.5
			const FULL_CIRCLE:Number = 2.0;
			var arc_length:Number = (1.0 / count) * FULL_CIRCLE;
			var start_arc:Number = arc_length / 2 + HALF_RADIAN;
			
			arc_length *= clock_wise ? -1 : 1;
			var final_arc:Number = start_arc + arc_length * index;
			
			final_arc *= Math.PI;
			
			var result:Point = new Point();
			result.x = Math.cos(final_arc) * radius;
			result.y = Math.sin(final_arc) * radius;
			return result;
		}
		
		public static function radius_for_radial_menu(count:int, item_radius:Number, padding:Number, min_radius:Number = Number.POSITIVE_INFINITY):Number {
			var circumference:Number = count * (item_radius + 2 * padding);
			return Math.max(circumference / 2 / Math.PI, min_radius + item_radius);
		}
	}
}