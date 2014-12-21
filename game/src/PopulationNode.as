package {

	import flash.geom.Point;
	import flash.display.*;
	
	public class PopulationNode extends SpaceComponent implements IVisualComponent {
		
		public var position:Point;
		
		public var population:uint = 0;
	
		public function init():void {
			position = require(PositionData).position;
			_sprite.graphics.clear();
		}
			
		private var _sprite:Sprite = new Sprite();
		
		private var _redraw:Boolean = true;
		
		public function get_palette():DisplayObject {
			return _sprite;
		}
		
		public function on_visual_update():void {
			if(_redraw) {
				with(_sprite.graphics) {
					clear();
					beginFill(0x00FF00, 1.0);
					lineStyle(0x0, 1.0);
					drawCircle(0, 0, 5);
					endFill();
				}
				_redraw = false;
			}
		}
		
	}
}
		