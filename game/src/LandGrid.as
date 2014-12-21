package {

	import flash.geom.Point;
	import flash.display.*;
	
	public class LandGrid extends SpaceComponent implements IVisualComponent {
		
		public var _width:int = 0;
		public var _width_max:int;
		
		public var _height:int = 0;
		public var _height_max:int;
		
		public var _size:Number = 128;
		
		private var _nodes:Vector.<PopulationNode> = new Vector.<PopulationNode>();

		private var _grid:Vector.<GridSpace> = null;
		
		public function set_size(width:int, height:int, size:Number, fertility_seed:Number):void {
			_width = width;
			_width_max = _width - 1;
			_height = height;
			_height_max = _height - 1;
			
			_size = size;
			_grid = new Vector.<GridSpace>( _width * _height, true );
			
			var fert:Number;
			for(var i:int = 0; i < _grid.length; i++) {
				fert = Math.random();
			
				_grid[i] = new GridSpace();
				_grid[i].fertility = Number(fert);
			}
			
			for each(var node:PopulationNode in _nodes) {
				add_to_grid(node);
			}
		}
		
		public function add_node(node:PopulationNode):void {
			add_to_grid(node);
			_nodes.push(node);
		}
		
		private function add_to_grid(node:PopulationNode):void {
			var x:int = clamp(node.position.x / _size, _width_max);
			var y:int = clamp(node.position.y / _size, _height_max);
			var index:int = y * _width + x;
			
			_grid[index]._nodes.push(node);
		}
		
		public function clamp(val:Number, max:Number = 1, min:Number = 0):Number {
			return val < min ? min : (val > max ? max : val);
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
					lineStyle(0x0, 1.0);
					var i:int = 0;
					for(var x:int = 0; x < _width; x++) {
						for(var y:int = 0; y < _height; y++) {
							beginFill((uint(0xFF * (1.0 - 0.5 * _grid[i].fertility)) * 0x100) | 0x880088, .70);
							drawRect(x * _size, y * _size, _size, _size);
							endFill();
						
							i++;
						}
					}
				}
				_redraw = false;
			}
		}
		
	}
}

internal class GridSpace {
	
	public var fertility:Number = 0;
	
	public var _nodes:Vector.<PopulationNode> = new Vector.<PopulationNode>();
	
}