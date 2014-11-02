package {

	import flash.geom.Point;
	import flash.events.*;
	
	public class SpaceObject extends EventDispatcher {
	
		public static const EVENT_ADDED_TO_SPACE:String = "added_to_space";
		
		public static const EVENT_REMOVED_FROM_SPACE:String = "removed_from_space";
		
		private var m_space:Space = null;
		
				
		internal function set_space(value:Space):void {
			if(m_space) {
				dispatchEvent(new Event(EVENT_REMOVED_FROM_SPACE));
			}
			m_space = value;
			if(m_space) {
				dispatchEvent(new Event(EVENT_ADDED_TO_SPACE));
			}
		}
		
		public function get space():Space {
			return m_space;
		}
	}
}