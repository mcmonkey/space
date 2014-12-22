package {

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.*;
	import flash.text.TextField;
	import util.*;
	
	public class LandGrid extends SpaceComponent implements IVisualComponent {
				
		private var _nodes:Vector.<PopulationNode> = new Vector.<PopulationNode>();
		
		private var _grid:Grid = new Grid(Class(GridSpace));
		
		private var _lines:Vector.<Point> = new Vector.<Point>();
		
		public function set_size(width:int, height:int, size:Number, fertility_seed:Number):void {
			
			_grid.set_size(width, height, size);
			
			
			
			for each(var node:PopulationNode in _nodes) {
				add_to_grid(node);
			}
			
			var point:Point = new Point();
			
			_lines = new Vector.<Point>();
			
			make_branch(new Point(0, Math.random()), 45, 4, Math.random(), Math.random());
			make_branch(new Point(0, Math.random()), 45, 4, Math.random(), Math.random());
			make_branch(new Point(0, 0), 45, 4, Math.random(), Math.random());
			
			var px:Number;
			var py:Number;
			var dx:Number;
			var dy:Number;
			
			for(var y:int = 0; y < height; y++) {
				for(var x:int = 0; x < width; x++) {
					px = x * size + size / 2;
					py = y * size + size / 2;
					var min_dist:Number = Number.MAX_VALUE;
					var dist:Number;
					for each(point in _lines) {
						dx = point.x * size * width - px;
						dy = point.y * size * height - py;
						dist = dx * dx + dy * dy;
						if(dist < min_dist) {
							min_dist = dist;
						}
					}
					
					var bar:Number = size * size * 8;
					min_dist = min_dist > bar ? bar : min_dist;
					min_dist = bar - min_dist;
					//trace(min_dist, bar, min_dist / bar);
					get_grid( x, y, true ).fertility = min_dist / bar;
				}
			}
		}
													// degrees
		private function make_branch(point:Point, radial_direction:Number, depth_left:uint, factor:Number, length:Number):void {
			if(depth_left == 0) return;
			
			var branches:int = MathUtil.random_i(1, 3);
			var branch_spread:Number = 45;
			var radial_spread:Number = branch_spread * branches;
			var radial_start:Number = radial_direction - radial_spread / 2;
				
			//trace("Branch ", radial_start, depth_left);
			while(branches-->0) {
				var direction_deg:Number = MathUtil.random_n(radial_start, radial_start + branch_spread);
				var direction:Point = MathUtil.direction_deg(direction_deg);
				
				//trace(" " + direction_deg, direction);
				
				var branch_point:Point = new Point();
				var branch_length:Number = length * (Math.random() * .2 + .8);
				
				branch_point.x = direction.x * branch_length + point.x;
				branch_point.y = direction.y * branch_length + point.y;
				
				curve_branch(point, branch_point, 5);
				
				//_lines.push(point);
				//_lines.push(branch_point);
				
				make_branch(branch_point, direction_deg, depth_left - 1, factor, branch_length * factor);
				
				radial_start += branch_spread;
			}
		}
		
		private function curve_branch(point:Point, branch_point:Point, depth_left:uint):void {
			if(depth_left == 0) {
				_lines.push(point);
				_lines.push(branch_point);
				
				return;
			}
			
			var dir:Point = branch_point.subtract(point);
			var distance:Number = Math.sqrt(dir.x * dir.x + dir.y * dir.y);
			
			dir.x /= distance;
			dir.y /= distance;
			
			var inv_dir:Point = new Point(dir.y, dir.x);
			
			var random:Number = Math.random() * 2.0 - 1.0;
			inv_dir.x *= distance * .25 * random;
			inv_dir.y *= distance * .25 * random;
			
			dir.x = dir.x * distance / 2;
			dir.y = dir.y * distance / 2;
			dir.x += inv_dir.x + point.x;
			dir.y += inv_dir.y + point.y;
			
			curve_branch(point, dir, depth_left - 1);
			curve_branch(dir, branch_point, depth_left - 1);
			
		}
		
		private function get_grid(x:Number, y:Number, grid_indexing:Boolean = false):GridSpace { return _grid.get_grid( x, y, grid_indexing ); }
		private function get_grid_p(p:Point, grid_indexing:Boolean = false):GridSpace { return _grid.get_grid_p(p, grid_indexing); }
		
		public function add_node(node:PopulationNode):void {
			add_to_grid(node);
			_nodes.push(node);
		}
		
		private function add_to_grid(node:PopulationNode):void {
			get_grid_p(node.position)._nodes.push(node);
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
		}
		
		public function get_count(x:Number, y:Number):int {
			return get_grid(x, y)._nodes.length;
		}
		
		public function get_fertility(x:Number, y:Number):Number {
			return get_grid(x, y).fertility;
		}
		
		private var _sprite:Sprite = new Sprite();
		
		private var _redraw:Boolean = true;
		
		public function get_palette():DisplayObject {
			return _sprite;
		}
		
		
		public function on_visual_update():void {
			if(_redraw) {
				
				var size:Number = _grid.size;
				var width:Number = _grid.width;
				var height:Number = _grid.height;
				
				var text:TextField;
				
				while(_sprite.numChildren) _sprite.removeChildAt(_sprite.numChildren - 1);
				_sprite.graphics.clear();
				//_sprite.graphics.lineStyle(1.0, 0xAAAAAA);
				_sprite.graphics.lineStyle();
				
				for(var y:int = 0; y < _grid.height; y++) {
					for(var x:int = 0; x < _grid.width; x++) {
						var grid:GridSpace = _grid.get_grid(x, y, true);
						text = new TextField();
						text.text = grid._nodes.length.toString();
						text.x = x * size;
						text.y = y * size;
						text.selectable = false;
						
						//_sprite.addChild(text);
						
						_sprite.graphics.beginFill((uint(0xFF * (0.5 * (grid.fertility) + 0.5)) * 0x100) | 0x880088, .70);
						_sprite.graphics.drawRect(x * size, y * size, size, size);
						_sprite.graphics.endFill();
					}
				}
				
				
				_sprite.graphics.lineStyle(1.0, 0x0000FF);
				for(var i:int = 0; i < _lines.length; i += 2) {
					//trace(_lines[i], _lines[i + 1]);
					_sprite.graphics.moveTo(_lines[i].x * width * size, _lines[i].y * height * size);
					_sprite.graphics.lineTo(_lines[i + 1].x * width * size, _lines[i + 1].y * height * size);
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