package com.gread.socialboard.view.socialFeed
{
	import mx.graphics.SolidColor;
	
	import spark.components.Image;
	import spark.components.Label;
	import spark.primitives.Rect;
	import spark.skins.SparkSkin;
	
	public class HeaderSkin extends SparkSkin
	{
		public var recEle:Rect;
		
		public var title:Label;
		
		public var logo:Image;
		
		[Embed(source="com/gread/socialboard/assets/logo.png")]
		public var logoObj:Class;
		
		private var solidColor:SolidColor = new SolidColor(0xf2e6ce);
		
		public function HeaderSkin()
		{
			super();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if(!recEle){
				recEle = new Rect();
				recEle.fill = solidColor;
				addElement(recEle);
			}
			
			if(!title){
				title = new Label();
				title.styleName = "logo";
				addElement(title);
			}
			
			if(!logo){
				logo = new Image();
				logo.source = logoObj;
				addElement(logo);
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			recEle.width = unscaledWidth;
			recEle.height = 40; //unscaledHeight
			
			logo.x = 10;
			logo.y = 10;
			
			title.x = logo.width + logo.x + 5;
			title.y = logo.y + (logo.height/2) - (title.height/2) + 4;
		
		}
		
		override protected function commitProperties():void{
			super.commitProperties();
		}
		
	}
}