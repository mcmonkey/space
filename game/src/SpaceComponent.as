package {
	public class SpaceComponent {
		public var collides_with:uint;
		public var collision_state:uint;
		
		protected var space_object:SpaceObject;
						
		internal final function init_internal(space_object:SpaceObject):void {
			if(space_object.space) throw new Error("Cannot add components while in space.");
			
			this.space_object = space_object;
			if(this is IVisualComponent) {
				space_object.visuals.push(this as IVisualComponent);
			}
			if(this is IModelComponent) {
				space_object.models.push(this as IModelComponent);
			}
			space_object.collides_with |= collides_with;
			space_object.collision_state |= collision_state;
			
			init();
		}
		
		internal function collide(other:SpaceObject):void {
		}
		
		protected function require(component:Class):* {
			return space_object.add_controller(component);
		}
		
		protected function init():void {}
	}
}