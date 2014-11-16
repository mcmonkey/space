

package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import util.*;
	
	public class Space {
		
		public static const G:Number = 1.0;
		
		public function get pallet():Sprite {
			return m_draw_pallet;
		}
		
		internal var m_draw_pallet:Sprite = null;
		
		internal var m_all_objects:Vector.<SpaceObject> = new Vector.<SpaceObject>();
		
		internal var m_colliders:Vector.<SpaceObject> = new Vector.<SpaceObject>();
		
		internal var m_collision_lists:Dictionary = new Dictionary();
		
		internal var m_destroyed_objects:Dictionary = new Dictionary();
				
		internal var tags:Dictionary = new Dictionary();
		
		public function Space(draw_pallet:Sprite) {
			m_draw_pallet = draw_pallet;
			m_draw_pallet.addEventListener(Event.EXIT_FRAME, on_frame);
		}
		
		public function add_space_object(space_object:SpaceObject):void {
			if(space_object in m_destroyed_objects) {
				delete m_destroyed_objects[space_object];
				return;
			}
			
			m_all_objects.push(space_object);
			
			if(m_collision_lists[space_object.collision_state] == null) {
				m_collision_lists[space_object.collision_state] = new Vector.<SpaceObject>();
			}
			m_collision_lists[space_object.collision_state].push(space_object);
			
			if(space_object.collides_with != 0) {
				m_colliders.push(space_object);
			}
			
			for each(var tag:* in space_object.tags) {
				DictionaryUtil.add_or_create(tags, tag, Class(Vector.<SpaceObject>)).push(space_object);
			}
			
			space_object.set_space(this);
		}
		
		public function get_by_tag(tag:*):Vector.<SpaceObject> {
			return tags[tag];
		}
		
		public function destroy(space_object:SpaceObject):void {
			m_destroyed_objects[space_object] = true;
		}
		
		private function on_frame(event:*):void {
			
			
			for each(var collider:SpaceObject in m_colliders) {
				for(var key:uint in  m_collision_lists) {
					if( (key & collider.collides_with) != 0) {
						var list:Vector.<SpaceObject> = m_collision_lists[key];
						for each(var collidee:SpaceObject in list) {
							if(collidee != collider) {
								collider.collide(collidee, key);
							}
						}
					}
				}
			}
			
			var iter:SpaceObject;
			for each(iter in m_all_objects) {
				iter.on_model_update();
			}
			
			for each( iter in m_all_objects) {
				iter.on_visual_update();
			}
			
			for(var destroyed:SpaceObject in m_destroyed_objects) {
				remove_from_list(destroyed, m_collision_lists[destroyed.collision_state]);
				remove_from_list(destroyed, m_all_objects);
				for each(var tag:String in destroyed.tags) {
					remove_from_list(destroyed, tags[tag]);
				}
				if(destroyed.collides_with) {
					remove_from_list(destroyed, m_colliders);	
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