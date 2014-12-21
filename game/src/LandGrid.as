package {

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.*;
	import flash.text.TextField;
	
	public class LandGrid extends SpaceComponent implements IVisualComponent {
		
		public var _width:int = 0;
		public var _width_max:int;
		
		public var _height:int = 0;
		public var _height_max:int;
		
		public var _size:Number = 128;
		
		private var _nodes:Vector.<PopulationNode> = new Vector.<PopulationNode>();

		private var _grid:Vector.<GridSpace> = null;
		
		private var _grid_pos:Point = new Point();
		
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
				_grid[i].fertility = fert
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
			get_grid_p(node.position)._nodes.push(node);
			trace(grid_index_p(node.position), _grid_pos);
			_redraw = true;
		}
		
		private function remove_from_grid(node:PopulationNode):void {			
			var list:Vector.<PopulationNode>;
			var index:int;
			
			list = get_grid_p(node.position)._nodes;
			index = list.indexOf(node);
			if(index >= 0) { 
				list.splice(index, 1); 
			}
			
			list = _nodes;
			index = list.indexOf(node);
			if(index >= 0) { 
				list.splice(index, 1);
			}
			_redraw = true;
		}
		
		public function get_count(x:Number, y:Number):int {
			return get_grid(x, y)._nodes.length;
		}
		
		public function get_fertility(x:Number, y:Number):Number {
			return get_grid(x, y).fertility;
		}
		
		private function get_grid(x:Number, y:Number):GridSpace {
			return _grid[grid_index(x, y)];
		}
		
		private function get_grid_p(p:Point):GridSpace {
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
		
		private var _sprite:Sprite = new Sprite();
		
		private var _redraw:Boolean = true;
		
		public function get_palette():DisplayObject {
			return _sprite;
		}
		
		
		public function on_visual_update():void {
			if(_redraw) {
				
				var text:TextField;
				
				while(_sprite.numChildren) _sprite.removeChildAt(_sprite.numChildren - 1);
				_sprite.graphics.clear();
				_sprite.graphics.lineStyle(1.0, 0xAAAAAA);
				var i:int = 0;
				for(var y:int = 0; y < _height; y++) {
					for(var x:int = 0; x < _width; x++) {
						var grid:GridSpace = _grid[i];
						text = new TextField();
						text.text = grid._nodes.length.toString();
						text.x = x * _size;
						text.y = y * _size;
						text.selectable = false;
						
						_sprite.addChild(text);
						
						_sprite.graphics.beginFill((uint(0xFF * (0.5 * (grid.fertility) + 0.5)) * 0x100) | 0x880088, .70);
						_sprite.graphics.drawRect(x * _size, y * _size, _size, _size);
						_sprite.graphics.endFill();
													
						i++;
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