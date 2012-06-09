package com.gread.socialboard.view.home
{
	import mx.graphics.SolidColor;
	
	import spark.components.Label;
	import spark.primitives.Rect;
	import spark.skins.SparkSkin;
	
	public class SourceBlockSkin extends SparkSkin
	{
		public var recEle:Rect;
		public var title:Label;
		
		private var solidColor:SolidColor = new SolidColor(0xd54f4f);
		
		public function SourceBlockSkin()
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
				title.styleName = "title";
				addElement(title);
			}
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			recEle.width = recEle.height = 200;
			
			title.x = unscaledWidth / 2 - title.width / 2;
			title.y = unscaledHeight / 2 - title.height / 2;
		}
		
	}
}