package util {

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.*;
	import flash.text.TextField;
	
	public class Grid {
		
		public var _width:int = 0;
		public var _width_max:int;
		
		public var _height:int = 0;
		public var _height_max:int;
		
		public var _size:Number = 128;

		private var _grid:Vector.<Object> = null;
		
		private var _grid_pos:Point = new Point();
		
		private var _type:Class;
		
		public function Grid(type:Class) {
			_type = type;
		}
		
		public function set_size(width:int, height:int, size:Number):void {
			_width = width;
			_width_max = _width - 1;
			_height = height;
			_height_max = _height - 1;
			
			_size = size;
			_grid = new Vector.<Object>( _width * _height, true );
			
			for(var i:int = 0; i < _grid.length; i++) {
				_grid[i] = new _type();
			}
		}

		private function get_grid(x:Number, y:Number):* {
			return _grid[grid_index(x, y)];
		}
		
		private function get_grid_p(p:Point):* {
			return _grid[grid_index(p.x, p.y)];
		}
		
		private function grid_index(x:Number, y:Number):int {
			grid_pos(x, y);
			return _grid_pos.y * _width + _grid_pos.x;
		}
		
		private function grid_index_p(p:Point):int {
			return grid_index(p.x, p.y);
		}
		
		private function grid_pos(x:Number, y:Number):void {
			_grid_pos.x = int(clamp(x / _size, _width_max));
			_grid_pos.y = int(clamp(y / _size, _height_max));
		}
		
		private function grid_pos_p(p:Point):void {
			grid_pos(p.x, p.y);
		}
		
		public function clamp(val:Number, max:Number = 1, min:Number = 0):Number {
			return val < min ? min : (val > max ? max : val);
		}	
	}
}
