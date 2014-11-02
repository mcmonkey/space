

package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class Space {
		
		public static const G:Number = 1.0;
		
		public function get pallet():Sprite {
			return m_draw_pallet;
		}
		
		internal var m_draw_pallet:Sprite = null;
		
		internal var m_all_objects:Vector.<SolidObject> = new Vector.<SolidObject>();
		
		internal var m_mobile_objects:Vector.<SolidObject> = new Vector.<SolidObject>();
		
		internal var m_significant_objects:Vector.<SolidObject> = new Vector.<SolidObject>();
		
		internal var m_colliders:Vector.<SolidObject> = new Vector.<SolidObject>();
		
		internal var m_collision_lists:Dictionary = new Dictionary();
		
		internal var m_destroyed_objects:Dictionary = new Dictionary();
		
		internal var m_moved:int = 0;
		
		public function Space(draw_pallet:Sprite) {
			m_draw_pallet = draw_pallet;
			m_draw_pallet.addEventListener(Event.EXIT_FRAME, on_frame);
		}
		
		public function add_solid_object(solid_object:SolidObject):void {
			if(solid_object in m_destroyed_objects) {
				delete m_destroyed_objects[solid_object];
				return;
			}
			
			m_all_objects.push(solid_object);
			if(!solid_object.well.fixed) {
				m_mobile_objects.push(solid_object);
			}
			if(solid_object.well.significant) {
				m_significant_objects.push(solid_object);
			}
			
			if(m_collision_lists[solid_object.collision_state] == null) {
				m_collision_lists[solid_object.collision_state] = new Vector.<SolidObject>();
			}
			m_collision_lists[solid_object.collision_state].push(solid_object);
			
			if(solid_object.collides_with != 0) {
				m_colliders.push(solid_object);
			}
			
			solid_object.set_space(this);
		}
		
		public function destroy(space_object:SpaceObject):void {
			m_destroyed_objects[space_object] = true;
		}
		
		private function on_frame(event:*):void {
			var i:int = 0;
			var j:int = 0;
			m_moved = 0;
			for(; i < m_mobile_objects.length; i++) {
				var first:SolidObject = m_mobile_objects[i];
				
				
				for(j = 0; j < m_significant_objects.length; j++) {
					var second:SolidObject = m_significant_objects[j];
					if(first == second) continue;
					
					var d_pos_x:Number = second.newton.position.x - first.newton.position.x;
					var d_pos_y:Number = second.newton.position.y - first.newton.position.y;
					
					var dx:Number = d_pos_x;
					var dy:Number = d_pos_y;
					dx = dx * dx;
					dy = dy * dy;
					
					var r2:Number = dx + dy;
					var dist:Number = Math.sqrt(r2);
					
					dx = d_pos_x / dist;
					dy = d_pos_y / dist;
					
					var force:Number = G * ( first.well.mass * second.well.mass ) / r2;
					
					first.well.net_force.x += dx * force;
					first.well.net_force.y += dy * force;
					
					
				}
				
				first.newton.acceleration.x = first.well.net_force.x / first.well.mass;
				first.newton.acceleration.y = first.well.net_force.y / first.well.mass;
				
				m_moved++;
				
				first.newton.step(1.0);
				
				first.well.net_force.x = 0;
				first.well.net_force.y = 0;
			}
			
			for each(var collider:SolidObject in m_colliders) {
				for(var key:uint in  m_collision_lists) {
					if( (key & collider.collides_with) != 0) {
						var list:Vector.<SolidObject> = m_collision_lists[key];
						for each(var collidee:SolidObject in list) {
							if(collidee != collider) {
								var dist_sqr:Number = collider.newton.distance_squared(collidee.newton)
								var r:Number = collider.radius + collidee.radius;
								if(dist_sqr < r * r) {
									collider.dispatchEvent(new CollisionEvent(collidee));
								}
							}
						}
					}
				}
			}
			
			for(var destroyed:SolidObject in m_destroyed_objects) {
				remove_from_list(destroyed, m_collision_lists[destroyed.collision_state]);
				remove_from_list(destroyed, m_all_objects);
				if(destroyed.collides_with) {
					remove_from_list(destroyed, m_colliders);	
				}
				if(!destroyed.well.fixed) {
					remove_from_list(destroyed, m_mobile_objects);
				}
				if(destroyed.well.significant) {
					remove_from_list(destroyed, m_significant_objects);
				}
				
				
				destroyed.set_space(null);
				
			}
			m_destroyed_objects = new Dictionary();
		}
		
		public static function remove_from_list(object:*, list:*):void {
			if(list) {
				var index:int = list.indexOf(object);
				if(index != -1) {
					list.splice(index, 1);
				}
			}
		}
		
	}
}