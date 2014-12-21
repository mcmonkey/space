package {

	import flash.geom.Point;
	import flash.display.*;
	
	public class PopulationNode extends SpaceComponent implements IModelComponent {
		
		public var position:Point;
		
		public var population:uint = 0;
		
		private var m_population:Number = 0;
		
		public var num_population:Number = 0;
		
		public var max_population:uint = 1;
		
		public var food_store:Number = 0;
		
		public var max_food_store:Number = 200;
		
		override protected function init():void {
			position = require(PositionData).position;
		}
		
		override internal function added(space:Space):void {
			space.get_first_by_tag(LandGrid).add_node(this);
		}
		
		override internal function removed(space:Space):void {
				space.get_first_by_tag(LandGrid).remove_node(this);
		}
		
		public function is_population_full():Boolean {
			return population >= max_population;
		}
		
		public function is_food_store_full():Boolean {
			return food_store >= max_food_store;
		}
		
		public function on_model_update():void {
			food_store = food_store > max_food_store ? max_food_store : food_store;
			food_store -= population;
			if(food_store < 0) {
				food_store = 0;
				if(population > 0) {
					population--;
				}
			} else if(food_store > 0) {
				if(population < max_population) {
				
					m_population += food_store;
					food_store = 0;
					
					var increase_rate:Number = 20;
					
					var increase:Number = Math.min(max_population - population, int(m_population / increase_rate));
					
					m_population -= increase * increase_rate;
					
					population += increase;
				}
			}
		}
		
	}
}
		