

package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class DisplayPlanet extends Sprite {
	
		public static const DISPLAY_RADIUS_RATIO:Number = 20;
		
		public static function unit_to_pixel(units:Number):Number {
			return DISPLAY_RADIUS_RATIO * units;
		}
		
		public var text_info:TextField = new TextField();
		
		public var shape:Shape = new Shape();
		
		public var solid_object:SolidObject;
		
		private var m_needs_redraw:Boolean = false;
		
		public function DisplayPlanet(solid_object:SolidObject) {
		
			solid_object.radius;
			
			addChild(shape);
			addChild(text_info);
			
			this.solid_object = solid_object;
			
			solid_object.collision_state = CollisionBits.BIT_PLANET;
			solid_object.collides_with = CollisionBits.NONE;
			solid_object.well.fixed = true;

			request_redraw();
			
			addEventListener(Event.ENTER_FRAME, on_enter_frame);
			solid_object.addEventListener(SpaceObject.EVENT_ADDED_TO_SPACE, added);
			solid_object.addEventListener(SpaceObject.EVENT_REMOVED_FROM_SPACE, removed);
		}
		
		private function added(event:*):void {
			solid_object.space.pallet.addChild(this);
		}
		
		private function removed(event:*):void {
			if(this.parent) {
				this.parent.removeChild(this);
			}
		}
		
		public function pixel_radius():Number {
			return unit_to_pixel(solid_object.radius);
		}
		
		public function request_redraw():void {
			m_needs_redraw = true;
		}
		
		private function redraw():void {
			shape.graphics.clear();
			shape.graphics.beginFill(0x00000000, 0.2);
			shape.graphics.drawCircle(0, 0, pixel_radius());
			shape.graphics.endFill();
			text_info.text = solid_object.well.mass.toPrecision(2);
			text_info.x = -text_info.textWidth / 2;
			
		}
		
		private function check_redraw():void {
			if(m_needs_redraw) {
				m_needs_redraw = false;
				redraw();
			}
		}
		
		private function on_enter_frame(event:*):void {	
			check_redraw();
			var pos:Point = solid_object.newton.position;
			if(false && stage) {
				if(pos.x < 0) {
					pos.x = stage.stageWidth;
				} else if(pos.x > stage.stageWidth) {
					pos.x = 0;
				}
				if(pos.y < 0) {
					pos.y = stage.stageHeight;
				}
				if(pos.y > stage.stageHeight) {
					pos.y = 0;
				}
			}
			this.x = pos.x;
			this.y = pos.y;
		}
	}
}