

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
			
			stage.addEventListener(MouseEvent.CLICK, on_click);
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
			
			
			generate_resource_nodes();
		}
		private function generate_resource_nodes():void {
			var resources:Vector.<ResourceNode> = new Vector.<ResourceNode>();
			for(var i:int = 0; i < 100; i++) {
				var tries:int = 10;
				try_loop:
				while(tries-- > 0) {
					var r:Number = Math.random() * 1000 + 25;
					var x:int = Math.random() * stage.stageWidth;
					var y:int = Math.random() * stage.stageHeight;
					var pixel_r:Number = ResourceNode.resource_to_pixel(r);
					for each(var existing_resource:ResourceNode in resources) {
						var dx:Number = x - existing_resource.position.position.x;
						var dy:Number = y - existing_resource.position.position.y;
						var distance:Number = pixel_r + existing_resource.pixel_radius(); 
						if((dx * dx) + (dy * dy) < (distance * distance)) {
							continue try_loop;
						}
					}
					tries = -1;
					
					var object:SpaceObject = new SpaceObject();
					var resource:ResourceNode = object.add_controller(ResourceNode);
					resource.resources_left = r;
					
					resource.position.position.x = x;
					resource.position.position.y = y;
					
					resources.push(resource);
					m_space.add_space_object(object);
				}
			}
		}
		
		
		private function on_click(event:MouseEvent):void {
			for(var i:int = 0; i < 1; i++) {
				var object:SpaceObject = new SpaceObject();
				var nexus:FactionNexus = object.add_controller(FactionNexus);
				nexus.position.position.x = stage.mouseX;
				nexus.position.position.y = stage.mouseY;
				
				m_space.add_space_object(object);
				
			}
		}
	}
}