package {
	import flash.geom.Point;
	
	public class FactionOwned extends SpaceComponent {
	
		private var m_faction:Faction;
		
		public function get faction():Faction {
			return m_faction;
		}
		
		public function set faction(value:Faction):void {
			if(m_faction) throw new Error();
			m_faction = value;
			m_faction.objects.push(this);
		}
		
		override protected function init():void {
			
			space_object.addEventListener(SpaceObject.EVENT_ADDED_TO_SPACE, added);
			space_object.addEventListener(SpaceObject.EVENT_REMOVED_FROM_SPACE, removed);
		}
		
		private function added(event:*):void {
			faction.add(this);
		}
		
		private function removed(event:*):void {
			faction.remove(this);
		}
	}
}