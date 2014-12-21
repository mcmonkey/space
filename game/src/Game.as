

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
			
			
		}
		private function generate_resource_nodes():void {
		
		}
		
		
		private function on_click(event:MouseEvent):void {
			
		}
	}
}