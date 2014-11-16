package util {
	import flash.utils.Dictionary;
	
	public class DictionaryUtil {
		public static function get_or_create(dictionary:Dictionary, key:*, type:Class):* {
			if(!(key in dictionary)) {
				dictionary[key] = new type();
			}
			return dictionary[key];
		}
	}
}