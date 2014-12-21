package {

	import flash.geom.Point;
	import flash.events.*;
	import flash.utils.Dictionary;
	import flash.display.DisplayObject;
	
	public class SpaceObject extends EventDispatcher {
	
		public static const EVENT_ADDED_TO_SPACE:String = "added_to_space";
		
		public static const EVENT_REMOVED_FROM_SPACE:String = "removed_from_space";
		
		public static function construct( ... components):* {
			var result:*;
			var object:SpaceObject = new SpaceObject();
			for each(var type:Class in components) {
				var component:* = object.add_controller(type);
				if(!result) {
					result = component;
				}
			}
			return component;
		}
		
		private var m_space:Space = null;
		
		private var m_controllers:Dictionary = new Dictionary();
		
		private var m_colliding_controllers:Vector.<SpaceComponent> = new Vector.<SpaceComponent>();
		
		internal var visuals:Vector.<IVisualComponent> = new Vector.<IVisualComponent>();
		
		internal var models:Vector.<IModelComponent> = new Vector.<IModelComponent>();
		
		internal var palettes:Vector.<DisplayObject> =  new Vector.<DisplayObject>();
		
		public var collision_state:uint;
		
		public var collides_with:uint;
		
		internal var tags:Dictionary = new Dictionary();
		
		public function add_controller(clazz:Class):* {
			if(!(clazz in m_controllers)) {
				var component:SpaceComponent = new clazz();
				m_controllers[clazz] = component;
				component.init_internal(this);
				if(component.collides_with != 0) {
					m_colliding_controllers.push(component);
				}
				tags[clazz] = clazz;
				for(var tag:* in component.tags) {
					tags[tag] = tag;
				}
			}
			return m_controllers[clazz];
		}
		
		public function get_controller(clazz:Class):* {
			return m_controllers[clazz];
		}
				
		internal function set_space(value:Space):void {
			
			var palette:DisplayObject;
			var comp:SpaceComponent;
			
			if(m_space) {
				dispatchEvent(new Event(EVENT_REMOVED_FROM_SPACE));
				for each(palette in palettes) {
					if(palette && palette.parent) {
						palette.parent.removeChild(palette);
					}
				}
				for each(comp in m_controllers) {
					comp.removed(m_space);
				}
			}
			
			m_space = value;
			
			if(m_space) {
				dispatchEvent(new Event(EVENT_ADDED_TO_SPACE));
				for each(var visual:IVisualComponent in visuals) {
					palette = visual.get_palette();
					if(palette) {
						palettes.push(palette);
						m_space.palette.addChild(palette);
					}
				}
				for each(comp in m_controllers) {
					comp.added(m_space);
				}
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