package {
	import flash.geom.Point;
	import util.CollisionPositionInfo;
	import flash.utils.*;
	
	public class Obstacle extends SpaceComponent {
		
		public var radius:Number = 0;
		
		private var position:Point;
		
		private static var ID:int = 0;
		public var id:int = ID++;
		
		override protected function init():void {
			position = require(PositionData).position;
		}

		public static const ROUTE_AVOIDANCE_PADDING:Number = 1.3;
		public static function simple_route(space:Space, start:Point, end:Point, radius:Number, route:Vector.<Point> = null, depth:int = 0):Vector.<Point> {
			depth++;
			var now:Number;
			if(depth == 1) now = getTimer();
			route = route || new Vector.<Point>();
			if(depth > 3) {
				route.push(end.clone());
				return route;
			}
			start = start.clone();
			end = end.clone();
			
			var obstacles:Vector.<SpaceObject> = space.tags[Obstacle];
			var unit:Point = new Point();
			var projection:Point = new Point();
			var new_start:Point = new Point();
			var obs_dir:Point = new Point();
			
			var radius_square:Number = radius * radius;
			var done:Boolean = false;
			var last_id:int = -1;
			while(!done) {
				done = true;
				var obstacle:Obstacle;
				var closest:Number = Number.POSITIVE_INFINITY;
				var closest_id:int = -1;
				var min:Number = Number.POSITIVE_INFINITY;
				
				unit.x = end.x - start.x;
				unit.y = end.y - start.y;
				
				var end_dot:Number = Obstacle.dot(unit, unit);
				
				unit.normalize(1);
				
				for each(var object:SpaceObject in obstacles) {
					obstacle = object.get_controller(Obstacle);
					
					obs_dir.x = obstacle.position.x - start.x;
					obs_dir.y = obstacle.position.y - start.y;
					
					if(Obstacle.dot(obs_dir, obs_dir) > end_dot) continue;
					
					var dot:Number = Obstacle.dot(obs_dir, unit);
					if(dot > 0 && dot < min) min = dot;
					
					if(dot > 0 && dot < closest ) {
						var x:Number;
						var y:Number;
						
						// Generate an actual projection.
						x = unit.x;
						y = unit.y;
						
						x *= dot;
						y *= dot;
						
						// Translate that back to world coordinates.
						x += start.x;
						y += start.y;
						
						// Represent the vector from the obstacle to the orthagonal intersection
						x = x - obstacle.position.x;
						y = y - obstacle.position.y;
						
						var dist_square:Number = x * x + y * y;
						
						var min_dist_square:Number = ROUTE_AVOIDANCE_PADDING * (radius_square + obstacle.radius * obstacle.radius)
						if(dist_square < min_dist_square) {
							closest = dot;
							closest_id = obstacle.id;
							var dist:Number = Math.sqrt(dist_square);
							var min_dist:Number = Math.sqrt(min_dist_square);
							
							x = x * (min_dist + 1) / dist;
							y = y * (min_dist + 1) / dist;
							
							x += obstacle.position.x;
							y += obstacle.position.y;
							new_start.x = x;
							new_start.y = y;
							done = false;
							
							if(Point.distance(obstacle.position, end) < min_dist) {
								done = true;
							}
						}
						
					}
				}
				if(last_id == closest_id) {
					done = true;
				}
				if(done) {
					route.push(end.clone());
				} else if(min < closest){ 
					simple_route(space, start, new_start, radius, route, depth);
					start = new_start.clone();
					last_id = closest_id;
				} else {
					start = new_start.clone();
					route.push(start);
					last_id = closest_id;
				}
				
			}
			if(depth == 1) trace("Took ", getTimer() - now);
			return route;
		}
		
		private static function dot(left:Point, right:Point):Number {
			return left.x * right.x + left.y * right.y;
		}
	}
}