package util {
	import flash.util.Dictionary;
	
	public class DictionaryUtil {
		public static function add_or_create(dictionary:Dictionary, key:*, type:Class):* {
			if(!(key in dictionary)) {
				dictionary[key] = new type();
			}
			return dictionary[key];
		}
	}
}