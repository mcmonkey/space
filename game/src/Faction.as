package {
	import flash.utils.Dictionary;
	import util.*;
	
	public class Faction  {		
		public var color:uint;
		
		public var second_color:uint;
		
		public var objects:Vector.<FactionOwned> = new Vector.<FactionOwned>();
				
		public var tags:Dictionary = new Dictionary();
		
		public function Faction() {
			color = Math.random() * uint.MAX_VALUE;
			second_color = color * 0.7;
		}
		
		public function add(owned:FactionOwned):void {
			objects.push(owned);
			for(var tag:* in owned.object.tags) {
				DictionaryUtil.get_or_create(tags, tag, Class(Vector.<SpaceObject>)).push(owned.object);
			}
		}
		
		public function remove(owned:FactionOwned):void {
			Space.remove_from_list(owned.object, objects);
			for(var tag:* in owned.object.tags) {
				Space.remove_from_list(owned.object, tags[tag]);
			}
		}
	}
}