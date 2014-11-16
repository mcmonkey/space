package {

	import flash.geom.Point;
	import flash.events.*;
	import flash.utils.Dictionary;
	
	public class SpaceObject extends EventDispatcher {
	
		public static const EVENT_ADDED_TO_SPACE:String = "added_to_space";
		
		public static const EVENT_REMOVED_FROM_SPACE:String = "removed_from_space";
		
		private var m_space:Space = null;
		
		private var m_controllers:Dictionary = new Dictionary();
		
		private var m_colliding_controllers:Vector.<SpaceComponent> = new Vector.<SpaceComponent>();
		
		internal var visuals:Vector.<IVisualComponent> = new Vector.<IVisualComponent>();
		
		internal var models:Vector.<IModelComponent> = new Vector.<IModelComponent>();
		
		public var collision_state:uint;
		
		public var collides_with:uint;
		
		public function add_controller(clazz:Class):* {
			if(!(clazz in m_controllers)) {
				var component:SpaceComponent = new clazz();
				m_controllers[clazz] = component;
				component.init_internal(this);
				if(component.collides_with != 0) {
					m_colliding_controllers.push(component);
				}
			}
			return m_controllers[clazz];
		}
		
		public function get_controller(clazz:Class):* {
			return m_controllers[clazz];
		}
				
		internal function set_space(value:Space):void {
			if(m_space) {
				dispatchEvent(new Event(EVENT_REMOVED_FROM_SPACE));
			}
			m_space = value;
			if(m_space) {
				dispatchEvent(new Event(EVENT_ADDED_TO_SPACE));
			}
		}
		
		internal function collide(collidee:SpaceObject, bits:uint):void {
			for each(var component:SpaceComponent in m_colliding_controllers) {
				if((bits & component.collides_with) != 0) {
					component.collide(collidee);
				}
			}
		}
		
		public function on_visual_update():void {
			for each(var comp:IVisualComponent in visuals) {
				comp.on_visual_update();
			}
		}
		
		
		public function on_model_update():void {
			for each(var comp:IModelComponent in models) {
				comp.on_model_update();
			}
		}
		
		public function get space():Space {
			return m_space;
		}
		
		public function destroy():void {
			if(m_space) {
				m_space.destroy(this);
			}
		}
	}
}