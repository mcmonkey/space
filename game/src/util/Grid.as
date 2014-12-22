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
		
		public function get size():Number { return _size;	}
		public function get width():int { return _width; }
		public function get height():int { return _height; }
		
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

		public function get_grid(x:Number, y:Number, grid_indexing:Boolean = false):* {
			return _grid[grid_index(x, y, grid_indexing)];
		}
		
		public function get_grid_p(p:Point, grid_indexing:Boolean = false):* {
			return _grid[grid_index(p.x, p.y, grid_indexing)];
		}
		
		private function grid_index(x:Number, y:Number, grid_indexing:Boolean = false):int {
			grid_pos(x, y, grid_indexing);
			return _grid_pos.y * _width + _grid_pos.x;
		}
		
		private function grid_index_p(p:Point, grid_indexing:Boolean = false):int {
			return grid_index(p.x, p.y, grid_indexing);
		}
		
		private function grid_pos(x:Number, y:Number, grid_indexing:Boolean = false):void {
			if(!grid_indexing) {
				x /= _size;
				y /= _size;
			}
			_grid_pos.x = int(clamp(x, _width_max));
			_grid_pos.y = int(clamp(y, _height_max));
		}
		
		private function grid_pos_p(p:Point, grid_indexing:Boolean = false):void {
			grid_pos(p.x, p.y, grid_indexing);
		}
		
		public function clamp(val:Number, max:Number = 1, min:Number = 0):Number {
			return val < min ? min : (val > max ? max : val);
		}	
	}
}
