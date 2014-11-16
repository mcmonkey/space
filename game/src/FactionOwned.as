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
		
	}
}