package {

	import flash.geom.Point;
	import flash.display.*;
	
	public class FarmNode extends SpaceComponent implements IVisualComponent, IModelComponent {
		
		public var position:Point;
		
		private var _population:PopulationNode;
		
		private var _spawns_left:int = 3;
		
		override protected function init():void {
			_population = require(PopulationNode);
			position = _population.position;
			_population.population = 1;
			_population.food_store = 1;
			_population.max_food_store = 150;
			_population.max_population = 15;
		}
		
		public function on_model_update():void {
			_population.food_store += _population.population * 1.5;
			if(_spawns_left && _population.is_population_full() && _population.is_food_store_full() ) {
				expand();
			}
		}
		
		private function expand():void {
			var land:LandGrid = space_object.space.get_first_by_tag(LandGrid);
			var radius:Number = this.radius * 10;
			
			var tries:int = 10;
			var pos:Point = new Point();
			while(tries-->0) {
				var r:Number = radius * Math.random() + 64;
				var d:Number = Math.random() * Math.PI * 2;
				
				pos.x = r * Math.cos(d) + position.x;
				pos.y = r * Math.sin(d) + position.y;
				
				var count:int = land.get_count(pos.x, pos.y);
				var fertility:int = int( land.get_fertility(pos.x, pos.y) * 20);
				if( count < fertility) {
					var new_farm:FarmNode = SpaceObject.construct(FarmNode);
					new_farm.position.x = pos.x;
					new_farm.position.y = pos.y;
					new_farm._population.population = 1;
					new_farm._population.food_store = 1;
					
					_population.population--;
					_population.food_store--;
					
					object.space.add_space_object(new_farm.object);
					_spawns_left--;
					break;
				}
			}
		}
		
		
		public function get_palette():DisplayObject {
			return _sprite;
		}
		
		public var radius:Number = 3;
		
		private var _ratio:Number = 0;
		
		private var _redraw:Boolean = true;
		
		private var _sprite:Sprite = new Sprite();
		
		public function on_visual_update():void {
			_sprite.x = position.x;
			_sprite.y = position.y;
			
			var ratio:Number = Number(_population.population) / Number(_population.max_population);
			
			if(_redraw) {
				with(_sprite.graphics) {
					clear();
					
					lineStyle(0,1);
					beginFill(0x00FF00, 1.0);
					drawCircle(0, 0, radius);
					endFill();
					
					var x:Number;
					var y:Number;
					var num:Number = 0;
					
					lineStyle(0x0, 1.0);
					moveTo(radius, 0);
					do {
						x = radius * Math.cos(num);
						y = radius * Math.sin(num);
						lineTo(x, y);
						
						num += (1 / (Math.PI  * radius));
					} while(num <= (Math.PI * 2 * ratio));
				}
				_redraw = false;
			}
		}
		
	}
}