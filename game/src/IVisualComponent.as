package {
	import flash.display.DisplayObject;
	
	public interface IVisualComponent {
		
		function get_palette():DisplayObject;
		
		function on_visual_update():void;
	
	}
}