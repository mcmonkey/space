

package {
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	public class Game extends Sprite {
		
		private var m_space:Space;
		
		private var m_text:TextField = new TextField();
		
		private var m_space_pallet:Sprite = new Sprite();
		
		public function get space():Space {
			return m_space;
		}
		
		public function Game() {
			stage.align = StageAlign.TOP_LEFT;  // or StageAlign.TOP
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, on_click);
			m_text.multiline = true;
			m_text.selectable = false;
			m_text.height = stage.stageHeight;
			m_text.width = stage.stageWidth;
			addChild(m_text);
			
			make_pallet();
			
			
			var debug:DebugSprite = new DebugSprite(this);
			debug.alpha = 0.6;
			addChild(debug);
		}
		
		private function make_pallet():void {
			if(m_space_pallet.parent) {
				removeChild(m_space_pallet);
			}
			m_space_pallet = new Sprite();
			addChild(m_space_pallet);
			m_space = new Space(m_space_pallet);
			
			
			generate_planets();
		}
		private function generate_planets():void {
			var planets:Vector.<DisplayPlanet> = new Vector.<DisplayPlanet>();
			for(var i:int = 0; i < 10; i++) {
				var tries:int = 10;
				try_loop:
				while(tries-- > 0) {
					var r:Number = Math.random() * 5 + 1;
					var x:int = Math.random() * stage.stageWidth;
					var y:int = Math.random() * stage.stageHeight;
					var pixel_r:Number = DisplayPlanet.unit_to_pixel(r);
					for each(var existing_planet:DisplayPlanet in planets) {
						var dx:Number = x - existing_planet.solid_object.newton.position.x;
						var dy:Number = y - existing_planet.solid_object.newton.position.y;
						var distance:Number = pixel_r + existing_planet.pixel_radius(); 
						if((dx * dx) + (dy * dy) < (distance * distance)) {
							continue try_loop;
						}
					}
					tries = -1;
					
					var object:SolidObject = new SolidObject();
					object.radius = Math.random() * 100 + 25;
					object.well.mass = object.radius * object.radius * 5;
					object.well.fixed = true;
					
					object.newton.position.x = x;
					object.newton.position.y = y;
					var planet:DisplayPlanet = new DisplayPlanet(object);
					planets.push(planet);
					m_space.add_solid_object(object);
				}
			}
		}
		
		
		private function on_click(event:MouseEvent):void {
			if(!event.buttonDown) return;
			for(var i:int = 0; i < 10; i++) {
				var object:SolidObject = new SolidObject();
				object.newton.position.x = stage.mouseX;
				object.newton.position.y = stage.mouseY;
				object.newton.velocity.x = Math.random() * 5  -2.5;
				object.newton.velocity.y = Math.random() * 5  -2.5;
				
				var bullet:DisplayBullet = new DisplayBullet(object);
				
				m_space.add_solid_object(object);
				
			}
		}
	}
}